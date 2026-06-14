import 'package:flutter/material.dart';
import '../features/admin/screens/admin_dashboard_screen.dart' show AdminDashboardScreen;
import '../features/admin/screens/movies/manage_movies_screen.dart' show ManageMoviesScreen;
import '../features/admin/screens/users/manage_users_screen.dart' show ManageUsersScreen;
import '../features/admin/screens/movies/manage_showtimes_screen.dart' show ManageShowtimesScreen;
import '../features/admin/screens/reports/report_details_screen.dart' show ReportDetailsScreen;
import '../features/admin/screens/cinemas/manage_cinemas_screen.dart' show ManageCinemasScreen;
import '../features/admin/screens/combos/manage_combos_screen.dart' show ManageCombosScreen;
import '../features/auth/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/main/screens/main_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/movie/screens/movie_screen.dart';
import '../features/booking/screens/select_seat_screen.dart';
import '../features/movie/screens/movie_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String movie = '/movie';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String selectSeat = '/select-seat';
  static const String movieDetail = '/movie-detail';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMovies = '/admin/movies';
  static const String adminUsers = '/admin/users';
  static const String adminShowtimes = '/admin/showtimes';
  static const String adminReports = '/admin/reports';
  static const String adminCinemas = '/admin/cinemas';
  static const String adminCombos = '/admin/combos';

  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      main: (context) => const MainScreen(),
      home: (context) => HomeScreen(),
      movie: (context) => const MovieScreen(),
      selectSeat: (context) => const SelectSeatScreen(),
      movieDetail: (context) => MovieDetailScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
      adminMovies: (context) => const ManageMoviesScreen(),
      adminUsers: (context) => const ManageUsersScreen(),
      adminShowtimes: (context) => const ManageShowtimesScreen(),
      adminReports: (context) => const ReportDetailsScreen(),
      adminCinemas: (context) => const ManageCinemasScreen(),
      adminCombos: (context) => const ManageCombosScreen(),
    };
  }
}
