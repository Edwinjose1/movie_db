// // lib/presentation/pages/movie_details_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:movie_search_app/core/constants/utils/theme_provider.dart';
// import 'package:movie_search_app/data/models/movie_details.dart';
// import '../../bloc/movie_details/movie_details_bloc.dart';
// import '../../bloc/movie_details/movie_details_event.dart';
// import '../../bloc/movie_details/movie_details_state.dart';
// import '../../widgets/loading_widget.dart';
// import '../../widgets/error_widget.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/constants/app_dimensions.dart';
// import '../../../core/constants/app_text_styles.dart';
// // ignore: depend_on_referenced_packages
// import 'package:provider/provider.dart';

// class MovieDetailsPage extends StatefulWidget {
//   final String movieId;

//   const MovieDetailsPage({
//     super.key,
//     required this.movieId,
//   });

//   @override
//   State<MovieDetailsPage> createState() => _MovieDetailsPageState();
// }

// class _MovieDetailsPageState extends State<MovieDetailsPage> {
//   @override
//   void initState() {
//     super.initState();
//     _loadMovieDetails();
//   }

//   void _loadMovieDetails() {
//     context.read<MovieDetailsBloc>().add(FetchMovieDetailsEvent(imdbId: widget.movieId));
//   }
  
//   Widget _getPlaceholderImage({
//     required double height,
//     required double width,
//     required bool isDarkMode,
//     String text = 'No Image Available',
//   }) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.movie_outlined,
//             size: height * 0.3,
//             color: isDarkMode ? Colors.white38 : Colors.black26,
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white54 : Colors.black54,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
    
//     return Scaffold(
//       backgroundColor: isDarkMode ? AppColors.dark : Colors.white,
//       body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
//         builder: (context, state) {
//           if (state is MovieDetailsLoading) {
//             return const LoadingWidget();
//           } else if (state is MovieDetailsLoaded) {
//             return _buildMovieDetails(context, state.movieDetails, isDarkMode);
//           } else if (state is MovieDetailsError) {
//             return ErrorDisplayWidget(
//               message: state.message,
//               onRetry: _loadMovieDetails,
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildMovieDetails(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         _buildAppBar(context, movie, isDarkMode),
//         SliverList(
//           delegate: SliverChildListDelegate([
//             _buildMovieHeader(context, movie, isDarkMode),
//             _buildSectionDivider(isDarkMode),
//             _buildPlot(context, movie, isDarkMode),
//             _buildSectionDivider(isDarkMode),
//             _buildInfo(context, movie, isDarkMode),
//             _buildSectionDivider(isDarkMode),
//             _buildCast(context, movie, isDarkMode),
//             _buildSectionDivider(isDarkMode),
//             _buildRatings(context, movie, isDarkMode),
//             SizedBox(height: AppDimensions.kPaddingXL),
//           ]),
//         ),
//       ],
//     );
//   }

//   Widget _buildAppBar(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     final screenHeight = MediaQuery.of(context).size.height;
    
//     return SliverAppBar(
//       expandedHeight: AppDimensions.getResponsiveHeight(context, 0.4),
//       pinned: true,
//       stretch: true,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Movie poster background
//             movie.poster != 'N/A'
//                 ? Image.network(
//                     movie.poster,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded / 
//                                   loadingProgress.expectedTotalBytes!
//                                 : null,
//                             color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       debugPrint('Error loading poster (${movie.title}): $error');
//                       return _getPlaceholderImage(
//                         height: screenHeight * 0.4,
//                         width: double.infinity,
//                         isDarkMode: isDarkMode,
//                         text: 'Poster unavailable for ${movie.title}',
//                       );
//                     },
//                   )
//                 : _getPlaceholderImage(
//                     height: screenHeight * 0.4,
//                     width: double.infinity,
//                     isDarkMode: isDarkMode,
//                   ),
                  
//             // Double gradient overlay for better text visibility
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     // ignore: deprecated_member_use
//                     Colors.black.withOpacity(0.2),
//                     // ignore: deprecated_member_use
//                     Colors.black.withOpacity(0.5),
//                     // ignore: deprecated_member_use
//                     Colors.black.withOpacity(0.8),
//                   ],
//                   stops: const [0.3, 0.7, 1.0],
//                 ),
//               ),
//             ),
            
//             // Side gradient for title protection
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                   colors: [
//                     // ignore: deprecated_member_use
//                     Colors.black.withOpacity(0.7),
//                     // ignore: deprecated_member_use
//                     Colors.black.withOpacity(0.5),
//                     Colors.transparent,
//                   ],
//                   stops: const [0.0, 0.3, 0.6],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         title: Opacity(
//           opacity: 0.9, // Slight opacity for better visual effect
//           child: Text(
//             movie.title,
//             style: AppTextStyles.titleDark(context),
//           ),
//         ),
//         stretchModes: const [
//           StretchMode.zoomBackground,
//           StretchMode.blurBackground,
//         ],
//       ),
//       backgroundColor: isDarkMode ? AppColors.dark : AppColors.primaryColor,
//       actions: [
//         // Add a share button
//         IconButton(
//           icon: const Icon(Icons.share_outlined, color: Colors.white),
//           onPressed: () {
//             // Implement share functionality
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Share functionality coming soon!')),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildMovieHeader(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     final posterHeight = AppDimensions.getResponsiveHeight(context, 0.25);
//     final posterWidth = AppDimensions.getResponsiveWidth(context, 0.33);
    
//     return Padding(
//       padding: EdgeInsets.all(AppDimensions.kPaddingM),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Movie poster
//           Hero(
//             tag: 'movie-poster-${movie.imdbId}',
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
//               child: movie.poster != 'N/A'
//                 ? Image.network(
//                     movie.poster,
//                     height: posterHeight,
//                     width: posterWidth,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         height: posterHeight,
//                         width: posterWidth,
//                         color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded / 
//                                   loadingProgress.expectedTotalBytes!
//                                 : null,
//                             color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       debugPrint('Error loading image (${movie.title}): $error');
//                       return _getPlaceholderImage(
//                         height: posterHeight,
//                         width: posterWidth,
//                         isDarkMode: isDarkMode,
//                         text: 'Image unavailable',
//                       );
//                     },
//                   )
//                 : _getPlaceholderImage(
//                     height: posterHeight,
//                     width: posterWidth,
//                     isDarkMode: isDarkMode,
//                   ),
//             ),
//           ),
//           SizedBox(width: AppDimensions.kPaddingM),
          
//           // Movie info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   movie.title,
//                   style: AppTextStyles.title(context, isDarkMode),
//                 ),
//                 SizedBox(height: AppDimensions.kPaddingXS),
                
//                 // Movie metadata with icons
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 8,
//                   children: [
//                     // Year
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.calendar_today_outlined, 
//                           size: 16, 
//                           color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           movie.year,
//                           style: AppTextStyles.caption(context, isDarkMode),
//                         ),
//                       ],
//                     ),
                    
//                     // Rating
//                     if (movie.rated != 'N/A') Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.remove_red_eye_outlined, 
//                           size: 16, 
//                           color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           movie.rated,
//                           style: AppTextStyles.caption(context, isDarkMode),
//                         ),
//                       ],
//                     ),
                    
//                     // Runtime
//                     if (movie.runtime != 'N/A') Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.timer_outlined, 
//                           size: 16, 
//                           color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           movie.runtime,
//                           style: AppTextStyles.caption(context, isDarkMode),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
                
//                 SizedBox(height: AppDimensions.kPaddingS),
//                 _buildGenreChips(context, movie.genre.split(', '), isDarkMode),
//                 SizedBox(height: AppDimensions.kPaddingM),
                
//                 // IMDB Rating with improved visuals
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     // ignore: deprecated_member_use
//                     color: isDarkMode ? Colors.amber.withOpacity(0.1) : Colors.amber.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       // ignore: deprecated_member_use
//                       color: Colors.amber.withOpacity(0.5),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.star_rounded,
//                         color: Colors.amber,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 8),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: movie.imdbRating,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDarkMode ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             TextSpan(
//                               text: '/10',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: isDarkMode ? Colors.white70 : Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '(${movie.imdbVotes})',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isDarkMode ? Colors.white60 : Colors.black45,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenreChips(BuildContext context, List<String> genres, bool isDarkMode) {
//     return Wrap(
//       spacing: AppDimensions.kPaddingXS,
//       runSpacing: AppDimensions.kPaddingXS,
//       children: genres.map((genre) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
//               width: 1,
//             ),
//           ),
//           child: Text(
//             genre,
//             style: TextStyle(
//               fontSize: AppDimensions.textS(context),
//               color: isDarkMode ? Colors.white : Colors.black87,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildPlot(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.description_outlined,
//                 size: 22,
//                 color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//               ),
//               SizedBox(width: AppDimensions.kPaddingS),
//               Text(
//                 'Plot',
//                 style: AppTextStyles.subtitle(context, isDarkMode),
//               ),
//             ],
//           ),
//           SizedBox(height: AppDimensions.kPaddingS),
//           Text(
//             movie.plot,
//             style: AppTextStyles.body(context, isDarkMode),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfo(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.info_outline,
//                 size: 22,
//                 color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//               ),
//               SizedBox(width: AppDimensions.kPaddingS),
//               Text(
//                 'Movie Info',
//                 style: AppTextStyles.subtitle(context, isDarkMode),
//               ),
//             ],
//           ),
//           SizedBox(height: AppDimensions.kPaddingM),
//           _buildInfoCard('Director', movie.director, Icons.movie_creation_outlined, isDarkMode),
//           _buildInfoCard('Writer', movie.writer, Icons.edit_outlined, isDarkMode),
//           _buildInfoCard('Released', movie.released, Icons.event_outlined, isDarkMode),
//           _buildInfoCard('Country', movie.country, Icons.public_outlined, isDarkMode),
//           _buildInfoCard('Language', movie.language, Icons.language_outlined, isDarkMode),
//           _buildInfoCard('Awards', movie.awards, Icons.emoji_events_outlined, isDarkMode),
//           if (movie.boxOffice != null && movie.boxOffice != 'N/A')
//             _buildInfoCard('Box Office', movie.boxOffice!, Icons.attach_money_outlined, isDarkMode),
//           if (movie.production != null && movie.production != 'N/A')
//             _buildInfoCard('Production', movie.production!, Icons.business_outlined, isDarkMode),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(String label, String value, IconData icon, bool isDarkMode) {
//     if (value == 'N/A') return const SizedBox.shrink();
    
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               size: 22,
//               color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
//             ),
//           ),
//           SizedBox(width: AppDimensions.kPaddingM),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
//                     fontSize: AppDimensions.textM(context),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: AppTextStyles.body(context, isDarkMode),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCast(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.people_outline,
//                 size: 22,
//                 color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//               ),
//               SizedBox(width: AppDimensions.kPaddingS),
//               Text(
//                 'Cast',
//                 style: AppTextStyles.subtitle(context, isDarkMode),
//               ),
//             ],
//           ),
//           SizedBox(height: AppDimensions.kPaddingM),
          
//           // Build actor chips instead of plain text
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: movie.actors.split(', ').map((actor) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.person_outline,
//                       size: 16,
//                       color: isDarkMode ? Colors.white70 : Colors.black54,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       actor,
//                       style: TextStyle(
//                         color: isDarkMode ? Colors.white : Colors.black87,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRatings(BuildContext context, MovieDetails movie, bool isDarkMode) {
//     if (movie.ratings.isEmpty) {
//       return const SizedBox.shrink();
//     }
    
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppDimensions.kPaddingM, vertical: AppDimensions.kPaddingS),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.stars_outlined,
//                 size: 22,
//                 color: isDarkMode ? AppColors.primaryColor : Colors.blue,
//               ),
//               SizedBox(width: AppDimensions.kPaddingS),
//               Text(
//                 'Ratings',
//                 style: AppTextStyles.subtitle(context, isDarkMode),
//               ),
//             ],
//           ),
//           SizedBox(height: AppDimensions.kPaddingM),
//           ...movie.ratings.map((rating) => _buildRatingItem(rating, isDarkMode)),
//         ],
//       ),
//     );
//   }

//   Widget _buildRatingItem(Rating rating, bool isDarkMode) {
//     // Function to get appropriate icon based on rating source
//     IconData getSourceIcon() {
//       switch (rating.source.toLowerCase()) {
//         case 'internet movie database':
//           return Icons.movie_filter_outlined;
//         case 'rotten tomatoes':
//           return Icons.thumb_up_alt_outlined;
//         case 'metacritic':
//           return Icons.analytics_outlined;
//         default:
//           return Icons.star_outline;
//       }
//     }
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         // ignore: deprecated_member_use
//         color: isDarkMode ? Colors.grey.shade800.withOpacity(0.6) : Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isDarkMode ? Colors.grey.shade700 : Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   // ignore: deprecated_member_use
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Icon(
//               getSourceIcon(),
//               size: 24,
//               color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   rating.source,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black87,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   rating.value,
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white70 : Colors.black54,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionDivider(bool isDarkMode) {
//     return Divider(
//       color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
//       thickness: 1,
//       height: AppDimensions.kPaddingL,
//       indent: AppDimensions.kPaddingM,
//       endIndent: AppDimensions.kPaddingM,
//     );
//   }
// }

// lib/presentation/pages/movie_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_app/core/constants/app_colors.dart';
import 'package:movie_search_app/core/constants/app_dimensions.dart';
import 'package:movie_search_app/core/constants/utils/theme_provider.dart';
import 'package:movie_search_app/data/models/movie_details.dart';
import 'package:movie_search_app/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:movie_search_app/presentation/bloc/movie_details/movie_details_event.dart';
import 'package:movie_search_app/presentation/bloc/movie_details/movie_details_state.dart';
import 'package:movie_search_app/presentation/pages/movie_details/widgets/movie_cast_and_ratings.dart';
import 'package:movie_search_app/presentation/pages/movie_details/widgets/movie_detail_app_bar.dart' show MovieDetailAppBar;
import 'package:movie_search_app/presentation/pages/movie_details/widgets/movie_header_widget.dart';
import 'package:movie_search_app/presentation/pages/movie_details/widgets/movie_info_section.dart';
import 'package:movie_search_app/presentation/widgets/error_widget.dart';
import 'package:movie_search_app/presentation/widgets/loading_widget.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatelessWidget {
  final String movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    // Dispatch the event when the widget is built
    // Using BlocProvider.of to avoid context.read which is typically used in callbacks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<MovieDetailsBloc>(context).add(FetchMovieDetailsEvent(imdbId: movieId));
    });
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : Colors.white,
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const LoadingWidget();
          } else if (state is MovieDetailsLoaded) {
            return _buildMovieDetails(context, state.movieDetails, isDarkMode);
          } else if (state is MovieDetailsError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () => BlocProvider.of<MovieDetailsBloc>(context)
                  .add(FetchMovieDetailsEvent(imdbId: movieId)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, MovieDetails movie, bool isDarkMode) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        MovieDetailAppBar(movie: movie, isDarkMode: isDarkMode),
        SliverList(
          delegate: SliverChildListDelegate([
            MovieHeaderWidget(movie: movie, isDarkMode: isDarkMode),
            _buildSectionDivider(isDarkMode),
            MovieInfoSection(movie: movie, isDarkMode: isDarkMode),
            _buildSectionDivider(isDarkMode),
            MovieCastAndRatings(movie: movie, isDarkMode: isDarkMode),
            SizedBox(height: AppDimensions.kPaddingXL),
          ]),
        ),
      ],
    );
  }

  Widget _buildSectionDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      thickness: 1,
      height: AppDimensions.kPaddingL,
      indent: AppDimensions.kPaddingM,
      endIndent: AppDimensions.kPaddingM,
    );
  }
}