```bash
lib/
├── core/                         # Thành phần dùng chung toàn app
│   ├── constants/                # Hằng số (màu, text, api)
│   │   ├── app_colors.dart       # Màu sắc toàn app
│   │   ├── app_text_styles.dart  # Style chữ
│   │   └── api_constants.dart    # Base URL, endpoints
│   ├── theme/                    # Theme của app
│   │   └── app_theme.dart
│   └── widgets/                  # Widget dùng chung (KHÔNG hardcode data)
│       ├── movie_card.dart       # Card phim (dùng nhiều nơi)
│       ├── news_card.dart        # Card tin tức
│       ├── now_playing_carousel.dart  # Carousel tự động
│       ├── section_header.dart   # Header + nút See all
│       ├── loading_indicator.dart     # Loading spinner
│       ├── error_view.dart       # Màn hình lỗi + thử lại
│       └── custom_app_bar.dart   # AppBar dùng chung
│
├── data/                         # Xử lý dữ liệu
│   ├── models/                   # Model (chỉ chứa field + getter format)
│   │   └── movie.dart            # Model Movie (map từ API)
│   ├── services/                 # Gọi API
│   │   └── movie_api_service.dart     # Dio calls
│   └── repositories/             # Trung gian giữa Provider và API
│       └── movie_repository.dart
│
├── features/                     # Các màn hình theo tính năng
│   ├── main/                     # Màn hình chính (có bottom nav cố định)
│   │   └── screens/
│   │       └── main_screen.dart  # ⭐ Quản lý 4 tab chính
│   ├── home/                     # Màn hình Trang chủ
│   │   ├── providers/
│   │   │   └── home_provider.dart     # State cho HomeScreen
│   │   ├── widgets/              # Widget chỉ dùng riêng cho Home
│   │   │   ├── home_header.dart
│   │   │   ├── search_bar.dart
│   │   │   └── news_section.dart
│   │   └── screens/
│   │       └── home_screen.dart
│   └── movie/                    # Màn hình Phim
│       ├── providers/
│       │   └── movie_provider.dart    # State cho MovieScreen
│       ├── widgets/              # Widget chỉ dùng riêng cho Movie
│       │   ├── tab_bar_widget.dart
│       │   └── movie_grid.dart
│       └── screens/
│           └── movie_screen.dart
│
├── app.dart                      # Khởi tạo MaterialApp
└── main.dart                     # Entry point
text

## 🔄 Luồng dữ liệu
UI (Screens)
↓ gọi
Provider (State Management)
↓ gọi
Repository (Trung gian)
↓ gọi
API Service (Dio)
↓ gọi
Backend (NodeJS)
↓ trả về JSON
Model.fromJson()
↓
Provider cập nhật state
↓ rebuild
UI hiển thị lại


1. Widget dùng chung
Đặt trong core/widgets/

KHÔNG hardcode dữ liệu

Có comment rõ props và cách dùng

2. Widget theo màn hình
Đặt trong features/xxx/widgets/

Chỉ dùng cho màn hình đó

3. Model
Chỉ chứa fields từ API

Getter dùng để format dữ liệu (KHÔNG gọi API)

4. Provider
Chứa logic gọi API

Quản lý state (isLoading, error, data)

5. Không hardcode
Không hardcode text, màu, kích thước trong widget

Dùng AppColors, AppTextStyles

6. Bottom navigation
Chỉ quản lý DUY NHẤT tại MainScreen

Các màn hình con KHÔNG có bottom nav riêng

🔧 Thêm màn hình mới
Tạo thư mục features/new_feature/

Tạo providers/, screens/, widgets/ (nếu cần)

Import vào MainScreen

Thêm vào _screens và _navItems

dart
// main_screen.dart
final List<Widget> _screens = [
  const HomeScreen(),
  const NewFeatureScreen(),  // ← thêm
];

final List<NavItem> _navItems = const [
  NavItem(Icons.home, 'Trang chủ'),
  NavItem(Icons.new_label, 'Tính năng mới'),  // ← thêm
];
