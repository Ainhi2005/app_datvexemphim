import 'package:flutter/material.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/cinema_api_service.dart';
import 'widgets/cinema_breadcrumb.dart';
import 'widgets/cinema_form_dialog.dart';
import 'widgets/cinema_list_tile.dart';
import 'widgets/room_form_dialog.dart';
import 'widgets/room_list_tile.dart';
import 'widgets/seat_config_dialog.dart';
import 'widgets/seat_grid_view.dart';

/// Màn hình quản lý rạp, phòng chiếu và sơ đồ ghế.
/// Điều hướng 3 lớp: Danh sách rạp → Danh sách phòng → Sơ đồ ghế.
class ManageCinemasScreen extends StatefulWidget {
  const ManageCinemasScreen({super.key});

  @override
  State<ManageCinemasScreen> createState() => _ManageCinemasScreenState();
}

class _ManageCinemasScreenState extends State<ManageCinemasScreen> {
  final CinemaApiService _api = CinemaApiService();

  // 0 = Danh sách rạp, 1 = Danh sách phòng, 2 = Sơ đồ ghế
  int _viewIndex = 0;
  bool _isLoading = false;

  dynamic _selectedCinema;
  dynamic _selectedRoom;

  List<dynamic> _cinemas = [];
  List<dynamic> _rooms = [];
  Map<String, List<dynamic>> _seatMap = {};

  // ─── Init ──────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadCinemas();
  }

  // ─── Data loading ──────────────────────────────────────────────────────────

  Future<void> _loadCinemas() async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.getCinemas();
      setState(() {
        _cinemas = data;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Lỗi tải danh sách rạp: $e');
    }
  }

  Future<void> _loadRooms(dynamic cinema) async {
    setState(() {
      _isLoading = true;
      _selectedCinema = cinema;
      _viewIndex = 1;
    });
    try {
      final data = await _api.getRooms(cinema['id']);
      setState(() {
        _rooms = data;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Lỗi tải danh sách phòng: $e');
    }
  }

  Future<void> _loadSeats(dynamic room) async {
    setState(() {
      _isLoading = true;
      _selectedRoom = room;
      _viewIndex = 2;
    });
    try {
      final data = await _api.getRoomSeats(room['id']);
      final Map<String, List<dynamic>> grouped = {};

      if (data is Map) {
        final rawMap = data['seatMap'];
        if (rawMap is Map) {
          rawMap.forEach((key, val) {
            if (val is List) grouped[key.toString()] = List<dynamic>.from(val);
          });
        }
      } else if (data is List) {
        for (final seat in data) {
          final row = seat['row'] ?? 'A';
          grouped.putIfAbsent(row, () => []).add(seat);
        }
      }

      setState(() {
        _seatMap = grouped;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Lỗi tải sơ đồ ghế: $e');
    }
  }

  // ─── Cinema CRUD ───────────────────────────────────────────────────────────

  Future<void> _openCinemaDialog([dynamic cinema]) async {
    final result = await CinemaFormDialog.show(context, cinema: cinema);
    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      String? imageUrl = result['currentImageUrl'];
      if (result['localImagePath'] != null) {
        imageUrl = await UserRepository().uploadImage(result['localImagePath']);
      }

      if (cinema == null) {
        await _api.createCinema(
          result['name'],
          result['address'],
          city: result['city'],
          phone: result['phone'],
          imageUrl: imageUrl,
        );
        _showSnack('Thêm rạp thành công!');
      } else {
        await _api.updateCinema(
          cinema['id'],
          result['name'],
          result['address'],
          city: result['city'],
          phone: result['phone'],
          imageUrl: imageUrl,
        );
        _showSnack('Cập nhật rạp thành công!');
      }
      _loadCinemas();
    } catch (e) {
      _handleError('Thao tác thất bại: $e');
    }
  }

  Future<void> _deleteCinema(int id) async {
    setState(() => _isLoading = true);
    try {
      await _api.deleteCinema(id);
      _showSnack('Xóa rạp thành công!');
      _loadCinemas();
    } catch (e) {
      _handleError('Xóa rạp thất bại: $e');
    }
  }

  // ─── Room CRUD ─────────────────────────────────────────────────────────────

  Future<void> _openRoomDialog([dynamic room]) async {
    final result = await RoomFormDialog.show(context, room: room);
    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      if (room == null) {
        await _api.createRoom(
          cinemaId: _selectedCinema['id'],
          name: result['name'],
          type: result['type'],
          totalRows: result['totalRows'],
          seatsPerRow: result['seatsPerRow'],
        );
        _showSnack('Thêm phòng thành công! Ghế đã được tự động sinh theo Grid.');
      } else {
        await _api.updateRoom(
          room['id'],
          name: result['name'],
          type: result['type'],
          totalRows: room['totalRows'] ?? 8,
          seatsPerRow: room['seatsPerRow'] ?? 10,
        );
        _showSnack('Cập nhật phòng thành công!');
      }
      _loadRooms(_selectedCinema);
    } catch (e) {
      _handleError('Thao tác thất bại: $e');
    }
  }

  Future<void> _deleteRoom(int roomId) async {
    setState(() => _isLoading = true);
    try {
      await _api.deleteRoom(roomId);
      _showSnack('Xóa phòng thành công!');
      _loadRooms(_selectedCinema);
    } catch (e) {
      _handleError('Xóa phòng thất bại: $e');
    }
  }

  // ─── Seat CRUD ─────────────────────────────────────────────────────────────

  Future<void> _openSeatDialog(dynamic seat) async {
    final result = await SeatConfigDialog.show(context, seat: seat);
    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      await _api.updateSeat(seat['id'], type: result['type'], isActive: result['isActive']);
      _showSnack('Cập nhật ghế thành công!');
      _loadSeats(_selectedRoom);
    } catch (e) {
      _handleError('Lỗi cập nhật ghế: $e');
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _handleError(String msg) {
    setState(() => _isLoading = false);
    _showSnack(msg);
  }

  void _confirmDelete({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Quản Lý Rạp & Phòng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: _viewIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => _viewIndex--),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Column(
              children: [
                CinemaBreadcrumb(
                  currentViewIndex: _viewIndex,
                  selectedCinema: _selectedCinema,
                  selectedRoom: _selectedRoom,
                  onGoToCinemas: () => setState(() => _viewIndex = 0),
                  onGoToRooms: () => setState(() => _viewIndex = 1),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _viewIndex,
                    children: [
                      _buildCinemaList(),
                      _buildRoomList(),
                      SeatGridView(
                        seatMap: _seatMap,
                        onSeatTap: _openSeatDialog,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: _viewIndex < 2
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                if (_viewIndex == 0) _openCinemaDialog();
                if (_viewIndex == 1) _openRoomDialog();
              },
            )
          : null,
    );
  }

  // ─── Sub-views ─────────────────────────────────────────────────────────────

  Widget _buildCinemaList() {
    if (_cinemas.isEmpty) {
      return const Center(
        child: Text('Chưa có rạp chiếu phim nào', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cinemas.length,
      itemBuilder: (_, i) {
        final cinema = _cinemas[i];
        return CinemaListTile(
          cinema: cinema,
          onTap: () => _loadRooms(cinema),
          onEdit: () => _openCinemaDialog(cinema),
          onDelete: () => _confirmDelete(
            title: 'Xác nhận xóa',
            message: 'Bạn có chắc muốn xóa rạp ${cinema['name']}?',
            onConfirm: () => _deleteCinema(cinema['id']),
          ),
        );
      },
    );
  }

  Widget _buildRoomList() {
    if (_rooms.isEmpty) {
      return const Center(
        child: Text('Chưa có phòng chiếu nào', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _rooms.length,
      itemBuilder: (_, i) {
        final room = _rooms[i];
        return RoomListTile(
          room: room,
          onTap: () => _loadSeats(room),
          onEdit: () => _openRoomDialog(room),
          onDelete: () => _confirmDelete(
            title: 'Xác nhận xóa',
            message: 'Bạn có chắc muốn xóa phòng ${room['name']}? (Sẽ xóa toàn bộ ghế trong phòng này)',
            onConfirm: () => _deleteRoom(room['id']),
          ),
        );
      },
    );
  }
}
