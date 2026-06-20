import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get common_error;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get common_success;

  /// No description provided for @auth_login_title.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get auth_login_title;

  /// No description provided for @auth_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get auth_email_hint;

  /// No description provided for @auth_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password_hint;

  /// No description provided for @auth_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_button;

  /// No description provided for @auth_register_title.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get auth_register_title;

  /// No description provided for @auth_register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get auth_register_button;

  /// No description provided for @auth_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_forgot_password;

  /// No description provided for @auth_dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get auth_dont_have_account;

  /// No description provided for @auth_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get auth_already_have_account;

  /// No description provided for @home_tab_movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get home_tab_movies;

  /// No description provided for @home_tab_tv_shows.
  ///
  /// In en, this message translates to:
  /// **'TV Shows'**
  String get home_tab_tv_shows;

  /// No description provided for @home_trending_now.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get home_trending_now;

  /// No description provided for @home_popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get home_popular;

  /// No description provided for @home_top_rated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get home_top_rated;

  /// No description provided for @home_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get home_upcoming;

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search movies, actors...'**
  String get home_search_hint;

  /// No description provided for @home_see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get home_see_all;

  /// No description provided for @detail_cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get detail_cast;

  /// No description provided for @detail_director.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get detail_director;

  /// No description provided for @detail_release_date.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get detail_release_date;

  /// No description provided for @detail_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get detail_rating;

  /// No description provided for @detail_play_trailer.
  ///
  /// In en, this message translates to:
  /// **'Play Trailer'**
  String get detail_play_trailer;

  /// No description provided for @detail_book_ticket.
  ///
  /// In en, this message translates to:
  /// **'Book Ticket'**
  String get detail_book_ticket;

  /// No description provided for @detail_synopsis.
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get detail_synopsis;

  /// No description provided for @detail_similar_movies.
  ///
  /// In en, this message translates to:
  /// **'Similar Movies'**
  String get detail_similar_movies;

  /// No description provided for @detail_duration_minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String detail_duration_minutes(int minutes);

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_my_tickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get profile_my_tickets;

  /// No description provided for @profile_favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite Movies'**
  String get profile_favorites;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @profile_edit_account.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get profile_edit_account;

  /// No description provided for @profile_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_dark_mode;

  /// No description provided for @booking_select_cinema.
  ///
  /// In en, this message translates to:
  /// **'Select Cinema'**
  String get booking_select_cinema;

  /// No description provided for @booking_select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get booking_select_date;

  /// No description provided for @booking_select_time.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get booking_select_time;

  /// No description provided for @booking_select_seat.
  ///
  /// In en, this message translates to:
  /// **'Select Seat'**
  String get booking_select_seat;

  /// No description provided for @booking_total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get booking_total_price;

  /// No description provided for @booking_checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get booking_checkout;

  /// No description provided for @booking_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get booking_payment_method;

  /// No description provided for @booking_confirm_payment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get booking_confirm_payment;

  /// No description provided for @auth_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_sign_in;

  /// No description provided for @auth_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_sign_up;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get auth_username;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirm_password;

  /// No description provided for @auth_continue_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get auth_continue_btn;

  /// No description provided for @auth_terms_and_privacy.
  ///
  /// In en, this message translates to:
  /// **'By signing in or signing up, you agree to our Terms of Service and Privacy Policy'**
  String get auth_terms_and_privacy;

  /// No description provided for @home_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get home_greeting;

  /// No description provided for @home_ready_to_watch.
  ///
  /// In en, this message translates to:
  /// **'Ready to watch movies?'**
  String get home_ready_to_watch;

  /// No description provided for @home_guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get home_guest;

  /// No description provided for @main_tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get main_tab_home;

  /// No description provided for @main_tab_ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get main_tab_ticket;

  /// No description provided for @main_tab_movie.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get main_tab_movie;

  /// No description provided for @main_tab_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get main_tab_profile;

  /// No description provided for @common_login_required_title.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get common_login_required_title;

  /// No description provided for @common_login_required_msg.
  ///
  /// In en, this message translates to:
  /// **'You need to login to access this feature.'**
  String get common_login_required_msg;

  /// No description provided for @common_login_required_profile_msg.
  ///
  /// In en, this message translates to:
  /// **'You need to login to view your profile.'**
  String get common_login_required_profile_msg;

  /// No description provided for @common_login_required_booking_msg.
  ///
  /// In en, this message translates to:
  /// **'You need to login to book tickets.'**
  String get common_login_required_booking_msg;

  /// No description provided for @common_login_later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get common_login_later;

  /// No description provided for @common_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get common_login;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search movies...'**
  String get search_hint;

  /// No description provided for @search_not_found.
  ///
  /// In en, this message translates to:
  /// **'No movies found.'**
  String get search_not_found;

  /// No description provided for @rating_error_title.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get rating_error_title;

  /// No description provided for @rating_understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get rating_understood;

  /// No description provided for @rating_success_msg.
  ///
  /// In en, this message translates to:
  /// **'🎉 Thank you for submitting your review successfully!'**
  String get rating_success_msg;

  /// No description provided for @rating_default_review.
  ///
  /// In en, this message translates to:
  /// **'Great movie!'**
  String get rating_default_review;

  /// No description provided for @rating_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Rate Movie'**
  String get rating_dialog_title;

  /// No description provided for @rating_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your review about the movie...'**
  String get rating_input_hint;

  /// No description provided for @rating_submit_btn.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get rating_submit_btn;

  /// No description provided for @rating_audience_reviews.
  ///
  /// In en, this message translates to:
  /// **'Audience Reviews'**
  String get rating_audience_reviews;

  /// No description provided for @rating_no_reviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get rating_no_reviews;

  /// No description provided for @rating_already_rated.
  ///
  /// In en, this message translates to:
  /// **'Already rated'**
  String get rating_already_rated;

  /// No description provided for @rating_review_tab.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get rating_review_tab;

  /// No description provided for @rating_rate_btn.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rating_rate_btn;

  /// No description provided for @movie_no_now_playing.
  ///
  /// In en, this message translates to:
  /// **'No movies currently showing'**
  String get movie_no_now_playing;

  /// No description provided for @movie_no_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'No upcoming movies'**
  String get movie_no_coming_soon;

  /// No description provided for @booking_seat_map_empty.
  ///
  /// In en, this message translates to:
  /// **'Seat map is empty'**
  String get booking_seat_map_empty;

  /// No description provided for @booking_total_payment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get booking_total_payment;

  /// No description provided for @booking_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get booking_continue;

  /// No description provided for @booking_seat_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get booking_seat_available;

  /// No description provided for @booking_seat_reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get booking_seat_reserved;

  /// No description provided for @booking_seat_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get booking_seat_selected;

  /// No description provided for @booking_seat_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard Seat'**
  String get booking_seat_standard;

  /// No description provided for @booking_seat_vip.
  ///
  /// In en, this message translates to:
  /// **'VIP Seat'**
  String get booking_seat_vip;

  /// No description provided for @booking_seat_couple.
  ///
  /// In en, this message translates to:
  /// **'Couple Seat'**
  String get booking_seat_couple;

  /// No description provided for @payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment_title;

  /// No description provided for @payment_order_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get payment_order_id;

  /// No description provided for @payment_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get payment_pending;

  /// No description provided for @payment_seat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get payment_seat;

  /// No description provided for @payment_select_combo.
  ///
  /// In en, this message translates to:
  /// **'Select Combo'**
  String get payment_select_combo;

  /// No description provided for @payment_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get payment_total;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @payment_discount_hint.
  ///
  /// In en, this message translates to:
  /// **'discount code'**
  String get payment_discount_hint;

  /// No description provided for @payment_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get payment_apply;

  /// No description provided for @payment_error.
  ///
  /// In en, this message translates to:
  /// **'Payment error. Please try again!'**
  String get payment_error;

  /// No description provided for @payment_pay_btn.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payment_pay_btn;

  /// No description provided for @ticket_my_tickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get ticket_my_tickets;

  /// No description provided for @ticket_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: '**
  String get ticket_error_occurred;

  /// No description provided for @ticket_no_tickets.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any tickets yet.'**
  String get ticket_no_tickets;

  /// No description provided for @ticket_no_data.
  ///
  /// In en, this message translates to:
  /// **'No ticket data'**
  String get ticket_no_data;

  /// No description provided for @ticket_movie_title.
  ///
  /// In en, this message translates to:
  /// **'Movie title'**
  String get ticket_movie_title;

  /// No description provided for @ticket_room.
  ///
  /// In en, this message translates to:
  /// **'Room '**
  String get ticket_room;

  /// No description provided for @ticket_cinema_system.
  ///
  /// In en, this message translates to:
  /// **'Cinema system'**
  String get ticket_cinema_system;

  /// No description provided for @ticket_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get ticket_processing;

  /// No description provided for @ticket_no_combo.
  ///
  /// In en, this message translates to:
  /// **'No combo'**
  String get ticket_no_combo;

  /// No description provided for @ticket_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get ticket_updating;

  /// No description provided for @ticket_detail_title.
  ///
  /// In en, this message translates to:
  /// **'Ticket Detail'**
  String get ticket_detail_title;

  /// No description provided for @ticket_payment_success.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get ticket_payment_success;

  /// No description provided for @ticket_available_branch.
  ///
  /// In en, this message translates to:
  /// **'Available system branch'**
  String get ticket_available_branch;

  /// No description provided for @ticket_barcode_instruction.
  ///
  /// In en, this message translates to:
  /// **'Show this barcode to the ticket\ncounter to receive your ticket'**
  String get ticket_barcode_instruction;

  /// No description provided for @auth_admin_access.
  ///
  /// In en, this message translates to:
  /// **'Admin Access'**
  String get auth_admin_access;

  /// No description provided for @auth_admin_dialog_msg.
  ///
  /// In en, this message translates to:
  /// **'Your account has Administrator privileges. Do you want to continue to the admin page or to the booking experience?'**
  String get auth_admin_dialog_msg;

  /// No description provided for @auth_admin_go_admin.
  ///
  /// In en, this message translates to:
  /// **'Go to Admin Page'**
  String get auth_admin_go_admin;

  /// No description provided for @auth_admin_go_user.
  ///
  /// In en, this message translates to:
  /// **'Book Tickets Experience'**
  String get auth_admin_go_user;

  /// No description provided for @admin_dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get admin_dashboard_title;

  /// No description provided for @admin_overview_stats.
  ///
  /// In en, this message translates to:
  /// **'Overview Statistics'**
  String get admin_overview_stats;

  /// No description provided for @admin_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get admin_revenue;

  /// No description provided for @admin_tickets_sold.
  ///
  /// In en, this message translates to:
  /// **'Tickets Sold'**
  String get admin_tickets_sold;

  /// No description provided for @admin_active_movies.
  ///
  /// In en, this message translates to:
  /// **'Active Movies'**
  String get admin_active_movies;

  /// No description provided for @admin_management_functions.
  ///
  /// In en, this message translates to:
  /// **'Management Functions'**
  String get admin_management_functions;

  /// No description provided for @admin_manage_movies.
  ///
  /// In en, this message translates to:
  /// **'Manage Movies'**
  String get admin_manage_movies;

  /// No description provided for @admin_manage_showtimes.
  ///
  /// In en, this message translates to:
  /// **'Manage Showtimes'**
  String get admin_manage_showtimes;

  /// No description provided for @admin_manage_users.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get admin_manage_users;

  /// No description provided for @admin_manage_cinemas.
  ///
  /// In en, this message translates to:
  /// **'Manage Cinemas & Rooms'**
  String get admin_manage_cinemas;

  /// No description provided for @admin_revenue_reports.
  ///
  /// In en, this message translates to:
  /// **'Revenue Reports'**
  String get admin_revenue_reports;

  /// No description provided for @admin_manage_combos.
  ///
  /// In en, this message translates to:
  /// **'Manage Combos'**
  String get admin_manage_combos;

  /// No description provided for @admin_error_loading_report.
  ///
  /// In en, this message translates to:
  /// **'Error loading overview report: '**
  String get admin_error_loading_report;

  /// No description provided for @admin_currency_unit.
  ///
  /// In en, this message translates to:
  /// **' VND'**
  String get admin_currency_unit;

  /// No description provided for @admin_ticket_unit.
  ///
  /// In en, this message translates to:
  /// **' tickets'**
  String get admin_ticket_unit;

  /// No description provided for @admin_movie_unit.
  ///
  /// In en, this message translates to:
  /// **' movies'**
  String get admin_movie_unit;

  /// No description provided for @val_please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get val_please_enter_email;

  /// No description provided for @val_please_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get val_please_enter_username;

  /// No description provided for @val_please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get val_please_enter_password;

  /// No description provided for @val_please_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get val_please_confirm_password;

  /// No description provided for @val_password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get val_password_too_short;

  /// No description provided for @auth_remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get auth_remember_me;

  /// No description provided for @home_now_playing.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get home_now_playing;

  /// No description provided for @home_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get home_coming_soon;

  /// No description provided for @home_movie_news.
  ///
  /// In en, this message translates to:
  /// **'Movie News'**
  String get home_movie_news;

  /// No description provided for @auth_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get auth_welcome;

  /// No description provided for @auth_your_registered_username_is.
  ///
  /// In en, this message translates to:
  /// **'Your registered username is:'**
  String get auth_your_registered_username_is;

  /// No description provided for @home_app_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello from Movie App!'**
  String get home_app_greeting;

  /// No description provided for @home_enjoy_favorite_movies.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your favorite movies'**
  String get home_enjoy_favorite_movies;

  /// No description provided for @profile_payment_history.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get profile_payment_history;

  /// No description provided for @profile_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_change_password;

  /// No description provided for @profile_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit_profile;

  /// No description provided for @profile_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profile_full_name;

  /// No description provided for @profile_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profile_phone_number;

  /// No description provided for @profile_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profile_date_of_birth;

  /// No description provided for @profile_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profile_save_changes;

  /// No description provided for @profile_open_image_picker.
  ///
  /// In en, this message translates to:
  /// **'Open Image Picker'**
  String get profile_open_image_picker;

  /// No description provided for @profile_update_success.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profile_update_success;

  /// No description provided for @profile_current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get profile_current_password;

  /// No description provided for @profile_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get profile_new_password;

  /// No description provided for @profile_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get profile_confirm;

  /// No description provided for @profile_change_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get profile_change_password_success;

  /// No description provided for @val_password_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get val_password_not_match;

  /// No description provided for @profile_vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get profile_vietnamese;

  /// No description provided for @profile_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profile_english;

  /// No description provided for @profile_language_changed.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully!'**
  String get profile_language_changed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
