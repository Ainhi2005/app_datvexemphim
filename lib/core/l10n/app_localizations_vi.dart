// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get common_loading => 'Đang tải...';

  @override
  String get common_error => 'Đã xảy ra lỗi';

  @override
  String get common_retry => 'Thử lại';

  @override
  String get common_cancel => 'Hủy bỏ';

  @override
  String get common_confirm => 'Xác nhận';

  @override
  String get common_save => 'Lưu';

  @override
  String get common_success => 'Thành công';

  @override
  String get auth_login_title => 'Đăng nhập tài khoản';

  @override
  String get auth_email_hint => 'Địa chỉ Email';

  @override
  String get auth_password_hint => 'Mật khẩu';

  @override
  String get auth_login_button => 'Đăng nhập';

  @override
  String get auth_register_title => 'Tạo tài khoản mới';

  @override
  String get auth_register_button => 'Đăng ký';

  @override
  String get auth_forgot_password => 'Quên mật khẩu?';

  @override
  String get auth_dont_have_account => 'Chưa có tài khoản? Đăng ký ngay';

  @override
  String get auth_already_have_account => 'Đã có tài khoản? Đăng nhập';

  @override
  String get home_tab_movies => 'Phim lẻ';

  @override
  String get home_tab_tv_shows => 'Phim bộ';

  @override
  String get home_trending_now => 'Thịnh hành';

  @override
  String get home_popular => 'Phổ biến nhất';

  @override
  String get home_top_rated => 'Đánh giá cao';

  @override
  String get home_upcoming => 'Sắp ra mắt';

  @override
  String get home_search_hint => 'Tìm kiếm phim, diễn viên...';

  @override
  String get home_see_all => 'Xem tất cả';

  @override
  String get detail_cast => 'Diễn viên';

  @override
  String get detail_director => 'Đạo diễn';

  @override
  String get detail_release_date => 'Ngày phát hành';

  @override
  String get detail_rating => 'Đánh giá';

  @override
  String get detail_play_trailer => 'Xem Trailer';

  @override
  String get detail_book_ticket => 'Đặt vé';

  @override
  String get detail_synopsis => 'Nội dung phim';

  @override
  String get detail_similar_movies => 'Phim tương tự';

  @override
  String detail_duration_minutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get profile_title => 'Hồ sơ cá nhân';

  @override
  String get profile_my_tickets => 'Vé của tôi';

  @override
  String get profile_favorites => 'Phim yêu thích';

  @override
  String get profile_settings => 'Cài đặt';

  @override
  String get profile_language => 'Ngôn ngữ';

  @override
  String get profile_logout => 'Đăng xuất';

  @override
  String get profile_edit_account => 'Chỉnh sửa tài khoản';

  @override
  String get profile_dark_mode => 'Chế độ tối';

  @override
  String get booking_select_cinema => 'Chọn rạp phim';

  @override
  String get booking_select_date => 'Chọn ngày';

  @override
  String get booking_select_time => 'Chọn suất chiếu';

  @override
  String get booking_select_seat => 'Chọn Ghế';

  @override
  String get booking_total_price => 'Tổng tiền';

  @override
  String get booking_checkout => 'Thanh toán';

  @override
  String get booking_payment_method => 'Phương thức thanh toán';

  @override
  String get booking_confirm_payment => 'Xác nhận thanh toán';

  @override
  String get auth_sign_in => 'Đăng nhập';

  @override
  String get auth_sign_up => 'Đăng ký';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_username => 'Tên người dùng';

  @override
  String get auth_password => 'Mật khẩu';

  @override
  String get auth_confirm_password => 'Xác nhận mật khẩu';

  @override
  String get auth_continue_btn => 'Tiếp tục';

  @override
  String get auth_terms_and_privacy =>
      'Bằng cách đăng nhập hoặc đăng ký, bạn đồng ý với Điều khoản Dịch vụ và Chính sách Bảo mật của chúng tôi';

  @override
  String get home_greeting => 'Chào';

  @override
  String get home_ready_to_watch => 'Sẵn sàng xem phim chưa?';

  @override
  String get home_guest => 'Khách';

  @override
  String get main_tab_home => 'Trang chủ';

  @override
  String get main_tab_ticket => 'Vé';

  @override
  String get main_tab_movie => 'Phim';

  @override
  String get main_tab_profile => 'Hồ sơ';

  @override
  String get common_login_required_title => 'Yêu cầu đăng nhập';

  @override
  String get common_login_required_msg =>
      'Bạn cần đăng nhập để truy cập tính năng này.';

  @override
  String get common_login_required_profile_msg =>
      'Bạn cần đăng nhập để xem hồ sơ cá nhân.';

  @override
  String get common_login_required_booking_msg =>
      'Bạn cần đăng nhập để thực hiện đặt vé xem phim.';

  @override
  String get common_login_later => 'Để sau';

  @override
  String get common_login => 'Đăng nhập';

  @override
  String get search_hint => 'Tìm kiếm phim...';

  @override
  String get search_not_found => 'Không tìm thấy phim nào.';

  @override
  String get rating_error_title => 'Thông báo';

  @override
  String get rating_understood => 'Đã hiểu';

  @override
  String get rating_success_msg => '🎉 Cảm ơn bạn đã gửi đánh giá thành công!';

  @override
  String get rating_default_review => 'Phim rất hay!';

  @override
  String get rating_dialog_title => 'Đánh giá phim';

  @override
  String get rating_input_hint => 'Nhập nhận xét của bạn về bộ phim...';

  @override
  String get rating_submit_btn => 'Gửi đánh giá';

  @override
  String get rating_audience_reviews => 'Đánh giá từ khán giả';

  @override
  String get rating_no_reviews => 'Chưa có đánh giá nào.';

  @override
  String get rating_already_rated => 'Đã đánh giá';

  @override
  String get rating_review_tab => 'Review';

  @override
  String get rating_rate_btn => 'Đánh giá';

  @override
  String get movie_no_now_playing => 'Không có phim đang chiếu';

  @override
  String get movie_no_coming_soon => 'Không có phim sắp chiếu';

  @override
  String get booking_seat_map_empty => 'Sơ đồ phòng chiếu đang trống';

  @override
  String get booking_total_payment => 'Tổng thanh toán';

  @override
  String get booking_continue => 'Tiếp tục';

  @override
  String get booking_seat_available => 'Có sẵn';

  @override
  String get booking_seat_reserved => 'Đã đặt';

  @override
  String get booking_seat_selected => 'Đang chọn';

  @override
  String get booking_seat_standard => 'Ghế thường';

  @override
  String get booking_seat_vip => 'Ghế VIP';

  @override
  String get booking_seat_couple => 'Ghế đôi (Couple)';

  @override
  String get payment_title => 'Thanh toán';

  @override
  String get payment_order_id => 'Mã đơn hàng';

  @override
  String get payment_pending => 'Chờ thanh toán';

  @override
  String get payment_seat => 'Ghế';

  @override
  String get payment_select_combo => 'Chọn combo ưu đãi';

  @override
  String get payment_total => 'Tổng cộng';

  @override
  String get payment_method => 'Phương thức thanh toán';

  @override
  String get payment_discount_hint => 'Mã giảm giá';

  @override
  String get payment_apply => 'Áp dụng';

  @override
  String get payment_error => 'Lỗi thanh toán. Vui lòng thử lại!';

  @override
  String get payment_pay_btn => 'Thanh toán';

  @override
  String get ticket_my_tickets => 'Vé của tôi';

  @override
  String get ticket_error_occurred => 'Có lỗi xảy ra: ';

  @override
  String get ticket_no_tickets => 'Bạn chưa có vé nào.';

  @override
  String get ticket_no_data => 'Không có dữ liệu vé';

  @override
  String get ticket_movie_title => 'Tên phim';

  @override
  String get ticket_room => 'Phòng ';

  @override
  String get ticket_cinema_system => 'Hệ thống rạp chiếu';

  @override
  String get ticket_processing => 'Đang xử lý';

  @override
  String get ticket_no_combo => 'Không có combo';

  @override
  String get ticket_updating => 'Đang cập nhật';

  @override
  String get ticket_detail_title => 'Chi tiết vé';

  @override
  String get ticket_payment_success => 'Thanh toán thành công!';

  @override
  String get ticket_available_branch => 'Cơ sở hệ thống khả dụng';

  @override
  String get ticket_barcode_instruction =>
      'Xuất trình mã vạch này cho nhân viên\nphòng vé để nhận vé của bạn';

  @override
  String get auth_admin_access => 'QUYỀN TRUY CẬP ADMIN';

  @override
  String get auth_admin_dialog_msg =>
      'Tài khoản của bạn có quyền Quản trị viên. Bạn muốn tiếp tục vào trang quản trị hay vào trải nghiệm đặt vé?';

  @override
  String get auth_admin_go_admin => 'Vào Trang Quản Trị';

  @override
  String get auth_admin_go_user => 'Trải Nghiệm Mua Vé';

  @override
  String get admin_dashboard_title => 'Bảng Điều Khiển Admin';

  @override
  String get admin_overview_stats => 'Thống kê tổng quan';

  @override
  String get admin_revenue => 'Doanh thu';

  @override
  String get admin_tickets_sold => 'Vé đã bán';

  @override
  String get admin_active_movies => 'Đang chiếu';

  @override
  String get admin_management_functions => 'Chức năng quản trị';

  @override
  String get admin_manage_movies => 'Quản lý Phim';

  @override
  String get admin_manage_showtimes => 'Quản lý Suất Chiếu';

  @override
  String get admin_manage_users => 'Quản lý Người Dùng';

  @override
  String get admin_manage_cinemas => 'Quản lý Rạp & Phòng';

  @override
  String get admin_revenue_reports => 'Báo cáo doanh thu';

  @override
  String get admin_manage_combos => 'Quản lý Combo';

  @override
  String get admin_error_loading_report => 'Lỗi tải báo cáo tổng quan: ';

  @override
  String get admin_currency_unit => ' đ';

  @override
  String get admin_ticket_unit => ' vé';

  @override
  String get admin_movie_unit => ' phim';

  @override
  String get val_please_enter_email => 'Vui lòng nhập email';

  @override
  String get val_please_enter_username => 'Vui lòng nhập tên người dùng';

  @override
  String get val_please_enter_password => 'Vui lòng nhập mật khẩu';

  @override
  String get val_please_confirm_password => 'Vui lòng xác nhận mật khẩu';

  @override
  String get val_password_too_short => 'Mật khẩu phải chứa ít nhất 6 ký tự';

  @override
  String get auth_remember_me => 'Nhớ mật khẩu';

  @override
  String get home_now_playing => 'Đang chiếu';

  @override
  String get home_coming_soon => 'Sắp chiếu';

  @override
  String get home_movie_news => 'Tin tức phim';

  @override
  String get auth_welcome => 'Chào mừng';

  @override
  String get auth_your_registered_username_is =>
      'Tên người dùng đã đăng ký của bạn là:';

  @override
  String get home_app_greeting => 'Xin chào từ Movie App!';

  @override
  String get home_enjoy_favorite_movies =>
      'Thưởng thức những bộ phim yêu thích của bạn';

  @override
  String get profile_payment_history => 'Lịch sử thanh toán';

  @override
  String get profile_change_password => 'Đổi mật khẩu';

  @override
  String get profile_edit_profile => 'Chỉnh sửa hồ sơ';

  @override
  String get profile_full_name => 'Họ và tên';

  @override
  String get profile_phone_number => 'Số điện thoại';

  @override
  String get profile_date_of_birth => 'Ngày sinh';

  @override
  String get profile_save_changes => 'Lưu thay đổi';

  @override
  String get profile_open_image_picker => 'Mở trình chọn ảnh';

  @override
  String get profile_update_success => 'Cập nhật hồ sơ thành công!';

  @override
  String get profile_current_password => 'Mật khẩu hiện tại';

  @override
  String get profile_new_password => 'Mật khẩu mới';

  @override
  String get profile_confirm => 'Xác nhận';

  @override
  String get profile_change_password_success => 'Đổi mật khẩu thành công!';

  @override
  String get val_password_not_match => 'Mật khẩu xác nhận không khớp!';

  @override
  String get profile_vietnamese => 'Vietnamese';

  @override
  String get profile_english => 'English';

  @override
  String get profile_language_changed => 'Ngôn ngữ đã được thay đổi!';
}
