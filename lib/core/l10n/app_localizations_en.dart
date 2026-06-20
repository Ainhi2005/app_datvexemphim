// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_error => 'An error occurred';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_save => 'Save';

  @override
  String get common_success => 'Success';

  @override
  String get auth_login_title => 'Login to your account';

  @override
  String get auth_email_hint => 'Email address';

  @override
  String get auth_password_hint => 'Password';

  @override
  String get auth_login_button => 'Login';

  @override
  String get auth_register_title => 'Create new account';

  @override
  String get auth_register_button => 'Register';

  @override
  String get auth_forgot_password => 'Forgot password?';

  @override
  String get auth_dont_have_account => 'Don\'t have an account? Sign up';

  @override
  String get auth_already_have_account => 'Already have an account? Sign in';

  @override
  String get home_tab_movies => 'Movies';

  @override
  String get home_tab_tv_shows => 'TV Shows';

  @override
  String get home_trending_now => 'Trending Now';

  @override
  String get home_popular => 'Popular';

  @override
  String get home_top_rated => 'Top Rated';

  @override
  String get home_upcoming => 'Upcoming';

  @override
  String get home_search_hint => 'Search movies, actors...';

  @override
  String get home_see_all => 'See all';

  @override
  String get detail_cast => 'Cast';

  @override
  String get detail_director => 'Director';

  @override
  String get detail_release_date => 'Release Date';

  @override
  String get detail_rating => 'Rating';

  @override
  String get detail_play_trailer => 'Play Trailer';

  @override
  String get detail_book_ticket => 'Book Ticket';

  @override
  String get detail_synopsis => 'Synopsis';

  @override
  String get detail_similar_movies => 'Similar Movies';

  @override
  String detail_duration_minutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_my_tickets => 'My Tickets';

  @override
  String get profile_favorites => 'Favorite Movies';

  @override
  String get profile_settings => 'Settings';

  @override
  String get profile_language => 'Language';

  @override
  String get profile_logout => 'Logout';

  @override
  String get profile_edit_account => 'Edit Account';

  @override
  String get profile_dark_mode => 'Dark Mode';

  @override
  String get booking_select_cinema => 'Select Cinema';

  @override
  String get booking_select_date => 'Select Date';

  @override
  String get booking_select_time => 'Select Time';

  @override
  String get booking_select_seat => 'Select Seat';

  @override
  String get booking_total_price => 'Total Price';

  @override
  String get booking_checkout => 'Checkout';

  @override
  String get booking_payment_method => 'Payment Method';

  @override
  String get booking_confirm_payment => 'Confirm Payment';

  @override
  String get auth_sign_in => 'Sign In';

  @override
  String get auth_sign_up => 'Sign Up';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_username => 'Username';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_confirm_password => 'Confirm Password';

  @override
  String get auth_continue_btn => 'Continue';

  @override
  String get auth_terms_and_privacy =>
      'By signing in or signing up, you agree to our Terms of Service and Privacy Policy';

  @override
  String get home_greeting => 'Hello';

  @override
  String get home_ready_to_watch => 'Ready to watch movies?';

  @override
  String get home_guest => 'Guest';

  @override
  String get main_tab_home => 'Home';

  @override
  String get main_tab_ticket => 'Ticket';

  @override
  String get main_tab_movie => 'Movies';

  @override
  String get main_tab_profile => 'Profile';

  @override
  String get common_login_required_title => 'Login Required';

  @override
  String get common_login_required_msg =>
      'You need to login to access this feature.';

  @override
  String get common_login_required_profile_msg =>
      'You need to login to view your profile.';

  @override
  String get common_login_required_booking_msg =>
      'You need to login to book tickets.';

  @override
  String get common_login_later => 'Later';

  @override
  String get common_login => 'Login';

  @override
  String get search_hint => 'Search movies...';

  @override
  String get search_not_found => 'No movies found.';

  @override
  String get rating_error_title => 'Notice';

  @override
  String get rating_understood => 'Understood';

  @override
  String get rating_success_msg =>
      '🎉 Thank you for submitting your review successfully!';

  @override
  String get rating_default_review => 'Great movie!';

  @override
  String get rating_dialog_title => 'Rate Movie';

  @override
  String get rating_input_hint => 'Enter your review about the movie...';

  @override
  String get rating_submit_btn => 'Submit Review';

  @override
  String get rating_audience_reviews => 'Audience Reviews';

  @override
  String get rating_no_reviews => 'No reviews yet.';

  @override
  String get rating_already_rated => 'Already rated';

  @override
  String get rating_review_tab => 'Review';

  @override
  String get rating_rate_btn => 'Rate';

  @override
  String get movie_no_now_playing => 'No movies currently showing';

  @override
  String get movie_no_coming_soon => 'No upcoming movies';

  @override
  String get booking_seat_map_empty => 'Seat map is empty';

  @override
  String get booking_total_payment => 'Total Payment';

  @override
  String get booking_continue => 'Continue';

  @override
  String get booking_seat_available => 'Available';

  @override
  String get booking_seat_reserved => 'Reserved';

  @override
  String get booking_seat_selected => 'Selected';

  @override
  String get booking_seat_standard => 'Standard Seat';

  @override
  String get booking_seat_vip => 'VIP Seat';

  @override
  String get booking_seat_couple => 'Couple Seat';

  @override
  String get payment_title => 'Payment';

  @override
  String get payment_order_id => 'Order ID';

  @override
  String get payment_pending => 'Pending payment';

  @override
  String get payment_seat => 'Seat';

  @override
  String get payment_select_combo => 'Select Combo';

  @override
  String get payment_total => 'Total';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get payment_discount_hint => 'discount code';

  @override
  String get payment_apply => 'Apply';

  @override
  String get payment_error => 'Payment error. Please try again!';

  @override
  String get payment_pay_btn => 'Pay';

  @override
  String get ticket_my_tickets => 'My Tickets';

  @override
  String get ticket_error_occurred => 'An error occurred: ';

  @override
  String get ticket_no_tickets => 'You don\'t have any tickets yet.';

  @override
  String get ticket_no_data => 'No ticket data';

  @override
  String get ticket_movie_title => 'Movie title';

  @override
  String get ticket_room => 'Room ';

  @override
  String get ticket_cinema_system => 'Cinema system';

  @override
  String get ticket_processing => 'Processing';

  @override
  String get ticket_no_combo => 'No combo';

  @override
  String get ticket_updating => 'Updating';

  @override
  String get ticket_detail_title => 'Ticket Detail';

  @override
  String get ticket_payment_success => 'Payment successful!';

  @override
  String get ticket_available_branch => 'Available system branch';

  @override
  String get ticket_barcode_instruction =>
      'Show this barcode to the ticket\ncounter to receive your ticket';

  @override
  String get auth_admin_access => 'Admin Access';

  @override
  String get auth_admin_dialog_msg =>
      'Your account has Administrator privileges. Do you want to continue to the admin page or to the booking experience?';

  @override
  String get auth_admin_go_admin => 'Go to Admin Page';

  @override
  String get auth_admin_go_user => 'Book Tickets Experience';

  @override
  String get admin_dashboard_title => 'Admin Dashboard';

  @override
  String get admin_overview_stats => 'Overview Statistics';

  @override
  String get admin_revenue => 'Revenue';

  @override
  String get admin_tickets_sold => 'Tickets Sold';

  @override
  String get admin_active_movies => 'Active Movies';

  @override
  String get admin_management_functions => 'Management Functions';

  @override
  String get admin_manage_movies => 'Manage Movies';

  @override
  String get admin_manage_showtimes => 'Manage Showtimes';

  @override
  String get admin_manage_users => 'Manage Users';

  @override
  String get admin_manage_cinemas => 'Manage Cinemas & Rooms';

  @override
  String get admin_revenue_reports => 'Revenue Reports';

  @override
  String get admin_manage_combos => 'Manage Combos';

  @override
  String get admin_error_loading_report => 'Error loading overview report: ';

  @override
  String get admin_currency_unit => ' VND';

  @override
  String get admin_ticket_unit => ' tickets';

  @override
  String get admin_movie_unit => ' movies';

  @override
  String get val_please_enter_email => 'Please enter email';

  @override
  String get val_please_enter_username => 'Please enter username';

  @override
  String get val_please_enter_password => 'Please enter password';

  @override
  String get val_please_confirm_password => 'Confirm password';

  @override
  String get val_password_too_short => 'Password must be at least 6 characters';

  @override
  String get auth_remember_me => 'Remember me';

  @override
  String get home_now_playing => 'Now Playing';

  @override
  String get home_coming_soon => 'Coming Soon';

  @override
  String get home_movie_news => 'Movie News';

  @override
  String get auth_welcome => 'Welcome';

  @override
  String get auth_your_registered_username_is => 'Your registered username is:';

  @override
  String get home_app_greeting => 'Hello from Movie App!';

  @override
  String get home_enjoy_favorite_movies => 'Enjoy your favorite movies';

  @override
  String get profile_payment_history => 'Payment History';

  @override
  String get profile_change_password => 'Change Password';

  @override
  String get profile_edit_profile => 'Edit Profile';

  @override
  String get profile_full_name => 'Full Name';

  @override
  String get profile_phone_number => 'Phone Number';

  @override
  String get profile_date_of_birth => 'Date of Birth';

  @override
  String get profile_save_changes => 'Save Changes';

  @override
  String get profile_open_image_picker => 'Open Image Picker';

  @override
  String get profile_update_success => 'Profile updated successfully!';

  @override
  String get profile_current_password => 'Current Password';

  @override
  String get profile_new_password => 'New Password';

  @override
  String get profile_confirm => 'Confirm';

  @override
  String get profile_change_password_success =>
      'Password changed successfully!';

  @override
  String get val_password_not_match => 'Passwords do not match!';

  @override
  String get profile_vietnamese => 'Vietnamese';

  @override
  String get profile_english => 'English';

  @override
  String get profile_language_changed => 'Language changed successfully!';
}
