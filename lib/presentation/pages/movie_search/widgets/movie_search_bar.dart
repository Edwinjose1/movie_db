// lib/presentation/widgets/search_page_widgets/movie_search_bar.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/app_strings.dart';
import 'package:movie_search_app/core/constants/utils/theme_provider.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:movie_search_app/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:provider/provider.dart';

class MovieSearchBar extends StatelessWidget {
  const MovieSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return _MovieSearchBarContent();
  }
}

class _MovieSearchBarContent extends StatefulWidget {
  @override
  State<_MovieSearchBarContent> createState() => _MovieSearchBarContentState();
}

class _MovieSearchBarContentState extends State<_MovieSearchBarContent> {
  final _searchController = TextEditingController();
  
  // Speech to text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
      },
    );
    setState(() {});
  }

  // Request microphone permission
  Future<bool> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      status = await Permission.microphone.request();
      return status.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      _showPermissionSettingsDialog();
      return false;
    }
    
    return false;
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDarkMode = themeProvider.isDarkMode;
        
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          title: Text(
            'Microphone Permission Required',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'This app needs microphone access for voice search. Please enable it in app settings.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Open Settings',
                style: TextStyle(
                  color: isDarkMode ? AppColors.primaryColor : Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  // Listen for speech input
  void _listen() async {
    bool hasPermission = await _requestMicrophonePermission();
    
    if (!hasPermission) {
      return;
    }

    if (!_speechEnabled) {
      await _initSpeech();
    }

    if (_speechEnabled) {
      setState(() {
        _isListening = true;
      });

      await _speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        // ignore: deprecated_member_use
        partialResults: true,
        localeId: 'en_US',
        // ignore: deprecated_member_use
        cancelOnError: true,
        // ignore: deprecated_member_use
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available on this device'),
        ),
      );
    }
  }

  // Stop listening for speech input
  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Process speech recognition result
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      setState(() {
        _searchController.text = result.recognizedWords;
        _submitSearch(); // Submit search after voice recognition completes
      });
    }
  }

  // Submit search explicitly - always triggers search with current query
  void _submitSearch() {
    final query = _searchController.text;
    // Even if query is empty, send the event to update the list
    context.read<MovieSearchBloc>().add(SearchMoviesEvent(query: query));
  }

  // Clear search text and update list to show all results
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      // When search is cleared, update the list with empty query
      context.read<MovieSearchBloc>().add(SearchMoviesEvent(query: ""));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.kPaddingM,
            vertical: AppDimensions.kPaddingS,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: _submitSearch, // Search button triggers the search
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        onPressed: _clearSearch,
                      ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening 
                            ? Colors.red
                            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                      ),
                      onPressed: _isListening ? _stopListening : _listen,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.kPaddingM,
                  horizontal: AppDimensions.kPaddingM,
                ),
              ),
              // Only trigger search on submission, not on every change
              onSubmitted: (_) => _submitSearch(),
              // No onChanged handler to prevent searching during typing
            ),
          ),
        ),
        
        // Listening indicator
        if (_isListening)
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppDimensions.kPaddingM,
              vertical: AppDimensions.kPaddingXS,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.kPaddingM,
              vertical: AppDimensions.kPaddingXS,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700] : Colors.blue[50],
              borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic,
                  color: Colors.red,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Listening...',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.blue[800],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}