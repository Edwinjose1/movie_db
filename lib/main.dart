// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'di/injection_container.dart' as di;
import 'presentation/bloc/movie_search/movie_search_bloc.dart';
import 'presentation/bloc/movie_categories/movie_categories_bloc.dart';
import 'presentation/bloc/movie_details/movie_details_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(
          create: (_) => di.sl<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<MovieCategoriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<MovieDetailsBloc>(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie Search App',
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              primaryColor: AppColors.primaryColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}