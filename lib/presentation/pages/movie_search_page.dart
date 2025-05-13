// lib/presentation/pages/movie_search_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import '../bloc/movie_search/movie_search_bloc.dart';
import '../bloc/movie_search/movie_search_event.dart';
import '../bloc/movie_search/movie_search_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/movie_list_item.dart';
import 'movie_details_page.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';

import '../../core/constants/utils/theme_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;
  
  // Speech to text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
      // Show dialog to open settings
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
        _onSearchChanged(result.recognizedWords);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final currentState = context.read<MovieSearchBloc>().state;
      if (currentState is MovieSearchLoaded && !currentState.hasReachedEnd) {
        context.read<MovieSearchBloc>().add(
              LoadMoreMoviesEvent(
                query: currentState.currentQuery,
                page: currentState.currentPage + 1,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<MovieSearchBloc>().add(SearchMoviesEvent(query: query));
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Modern header with back button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.kPaddingM,
                vertical: AppDimensions.kPaddingM,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.kPaddingXS),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Search Movies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                    borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.kPaddingXS),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.amber : Colors.blueGrey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Modern search bar
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
                  onChanged: _onSearchChanged,
                ),
              ),
            ),
            
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
            
            Expanded(
              child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  if (state is MovieSearchInitial) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                          ),
                          SizedBox(height: AppDimensions.kPaddingM),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingL),
                            child: Text(
                              AppStrings.searchInitialMessage,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is MovieSearchLoading) {
                    return const LoadingWidget();
                  } else if (state is MovieSearchLoaded || state is MovieSearchLoadingMore) {
                    final movies = state is MovieSearchLoaded 
                        ? state.movies 
                        : (state as MovieSearchLoadingMore).currentMovies;
                    
                    final isLoadingMore = state is MovieSearchLoadingMore;
                    
                    return movies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.movie_filter_rounded,
                                  size: 80,
                                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                ),
                                SizedBox(height: AppDimensions.kPaddingM),
                                Text(
                              AppStrings.noResultsFound,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.kPaddingM,
                              vertical: AppDimensions.kPaddingS,
                            ),
                            itemCount: isLoadingMore
                                ? movies.length + 1
                                : movies.length,
                            itemBuilder: (context, index) {
                              if (index >= movies.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: AppDimensions.kPaddingM),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              
                              final movie = movies[index];
                              return MovieListItem(
                                movie: movie,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsPage(
                                        movieId: movie.imdbId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                  } else if (state is MovieSearchError) {
                    return ErrorDisplayWidget(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          context.read<MovieSearchBloc>().add(
                                SearchMoviesEvent(query: _searchController.text),
                              );
                        }
                      },
                    );
                  }
                  
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}