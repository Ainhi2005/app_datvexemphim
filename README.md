# 🎬 Hệ Thống Đặt Vé Xem Phim - Cinema Booking App (Frontend)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-Backend-339933?style=for-the-badge&logo=nodedotjs)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

**Cinema Booking App** là ứng dụng di động được thiết kế nhằm số hóa quy trình mua vé xem phim, mang lại trải nghiệm đặt vé nhanh chóng, tiện lợi cho khách hàng và cung cấp công cụ quản lý doanh thu hiệu quả cho rạp chiếu phim.

Dự án này được phát triển với mô hình Client-Server. Đây là Repository dành cho **Mobile App (Flutter)**. 
👉 *Tham khảo Backend Repository (Node.js & MySQL) tại đây: [Thêm link Github Backend của bạn nếu có]*

---

## 🎯 Mục tiêu dự án (Business Objectives)
- **Với Khách hàng:** Xóa bỏ tình trạng xếp hàng chờ đợi, cho phép chủ động xem lịch chiếu, chọn chỗ ngồi ưng ý và thanh toán không tiền mặt.
- **Với Doanh nghiệp (Rạp phim):** Tối ưu hóa quy trình bán vé, số hóa dữ liệu khách hàng và thống kê doanh thu theo thời gian thực.

---

## ✨ Luồng nghiệp vụ & Tính năng cốt lõi (Business Features)

Hệ thống được phân tích và thiết kế dựa trên trải nghiệm thực tế của người dùng (Customer Journey):

### 1. Phân hệ Khách hàng (Customer App)
* **Khám phá phim (Movie Discovery):** 
  * Hiển thị danh sách Phim Đang Chiếu (Now Showing) và Sắp Chiếu (Coming Soon).
  * Tìm kiếm phim nhanh chóng qua `search_bar`.
  * Xem chi tiết thông tin phim: Trailer, tóm tắt, đạo diễn, diễn viên, thời lượng.
* **Quy trình đặt vé (Booking Flow):**
  * Chọn Rạp và Ngày chiếu linh hoạt.
  * **Sơ đồ ghế ngồi thông minh (`seat_matrix`):** Hiển thị trạng thái ghế (Trống, Đang chọn, Đã bán) theo thời gian thực. Phân loại giá vé theo loại ghế (Ghế thường, Ghế VIP).
* **Thanh toán & Xuất vé (Payment & Ticketing):**
  * Tích hợp thanh toán bằng **Mã QR** (`qr_payment_dialog`).
  * Sau khi thanh toán thành công, hệ thống tự động sinh vé điện tử (E-ticket) kèm mã QR/Barcode dùng để check-in tại rạp.
* **Quản lý tài khoản (Profile Management):**
  * Quản lý thông tin cá nhân, lịch sử đặt vé (`my_ticket_screen`).

### 2. Phân hệ Quản lý (Admin / Cinema Manager)
* **Quản lý dữ liệu:** Đồng bộ dữ liệu phim, rạp chiếu, phòng chiếu từ Server.
* **Báo cáo & Thống kê (`report_repository`):** Giao tiếp với API Backend để trích xuất dữ liệu doanh thu, số lượng vé bán ra theo ngày/tháng/phim.

---

## 🛠️ Kiến trúc Kỹ thuật (Technical Architecture)

Dự án được xây dựng theo chuẩn **Clean Architecture** kết hợp với kiến trúc **Feature-based**, giúp code dễ bảo trì, mở rộng và test.

### Tech Stack
- **Framework:** Flutter (Mobile - Android/iOS)
- **Ngôn ngữ:** Dart
- **Quản lý trạng thái (State Management):** BLoC / Provider *(Sửa lại theo tool bạn dùng)*
- **Giao tiếp API:** `http` / `dio` (Tiêu thụ RESTful API từ Backend Node.js).
- **Lưu trữ cục bộ:** `shared_preferences` (Lưu token đăng nhập, thông tin user).

### Cấu trúc thư mục (Folder Structure)
```text
lib/
 ┣ data/                     # Data Layer: Giao tiếp với API và Database
 ┃ ┣ repositories/           # Chứa các file như movie_repository.dart, report_repository.dart
 ┃ ┗ services/               # Chứa cấu hình gọi API như showtime_api_service.dart
 ┣ features/                 # Presentation Layer: Chia theo từng cụm tính năng
 ┃ ┣ booking/                # Luồng đặt vé (chọn suất chiếu, seat_matrix, v.v.)
 ┃ ┣ home/                   # Màn hình chính, search_bar
 ┃ ┣ main/                   # Điều hướng chính (Bottom Navigation)
 ┃ ┣ movie/                  # Chi tiết phim
 ┃ ┣ payment/                # Luồng thanh toán QR
 ┃ ┣ profile/                # Quản lý người dùng
 ┃ ┗ ticket/                 # Quản lý vé đã đặt
 ┣ core/                     # Utils, Constants, Themes dùng chung
 ┗ main.dart                 # Điểm bắt đầu (Entry point) của ứng dụng
📸 Giao diện ứng dụng 


