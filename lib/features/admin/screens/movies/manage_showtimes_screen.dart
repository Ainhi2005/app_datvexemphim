import 'package:flutter/material.dart';
import 'package:tet/data/models/showtime.dart';
import 'package:tet/data/models/movie.dart';
import 'package:tet/data/services/showtime_api_service.dart';
import 'package:tet/data/repositories/movie_repository.dart';
import 'package:tet/data/services/movie_api_service.dart';

class ManageShowtimesScreen extends StatefulWidget {
  const ManageShowtimesScreen({super.key});

  @override
  State<ManageShowtimesScreen> createState() => _ManageShowtimesScreenState();
}

class _ManageShowtimesScreenState extends State<ManageShowtimesScreen> {
  final ShowtimeApiService _showtimeApiService = ShowtimeApiService();
  final MovieRepository _movieRepository = MovieRepository();
  final MovieApiService _movieApiService = MovieApiService();

  List<Showtime> _showtimes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShowtimes();
  }

  Future<void> _loadShowtimes() async {
    setState(() => _isLoading = true);
    try {
      final data = await _showtimeApiService.getAllShowtimes();
      setState(() {
        _showtimes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải danh sách suất chiếu: $e')),
      );
    }
  }

  Future<void> _deleteShowtime(int showtimeId) async {
    setState(() => _isLoading = true);
    try {
      await _showtimeApiService.deleteShowtime(showtimeId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa suất chiếu thành công!')),
      );
      _loadShowtimes();
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa suất chiếu: $e')),
      );
    }
  }

  void _openAddShowtimeDialog() async {
    List<Movie> movies = [];
    List<dynamic> cinemas = [];
    List<dynamic> rooms = [];

    Movie? selectedMovie;
    dynamic selectedCinema;
    dynamic selectedRoom;
    final TextEditingController priceController = TextEditingController();
    final TextEditingController vipPriceController = TextEditingController();
    final TextEditingController couplePriceController = TextEditingController();
    DateTime? selectedDateTime;

    priceController.addListener(() {
      final double? base = double.tryParse(priceController.text);
      if (base != null) {
        vipPriceController.text = (base + 20000).toStringAsFixed(0);
        couplePriceController.text = (base + 40000).toStringAsFixed(0);
      }
    });

    setState(() => _isLoading = true);
    try {
      movies = await _movieRepository.getAllMovies();
      final cinemaResponse = await _movieApiService.getCinemasList();
      cinemas = cinemaResponse is Map ? (cinemaResponse['data'] ?? []) : [];
    } catch (e) {
      debugPrint('Lỗi chuẩn bị dữ liệu: $e');
    } finally {
      setState(() => _isLoading = false);
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    'Thêm Suất Chiếu Mới',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Chọn Phim
                  DropdownButtonFormField<Movie>(
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(
                      labelText: 'Chọn Phim',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.white),
                    initialValue: selectedMovie,
                    items: movies.map((m) {
                      return DropdownMenuItem(value: m, child: Text(m.title));
                    }).toList(),
                    onChanged: (val) => setModalState(() => selectedMovie = val),
                  ),
                  const SizedBox(height: 12),

                  // Chọn Rạp
                  DropdownButtonFormField<dynamic>(
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(
                      labelText: 'Chọn Rạp',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.white),
                    initialValue: selectedCinema,
                    items: cinemas.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c['name'] ?? 'Rạp'));
                    }).toList(),
                    onChanged: (val) async {
                      setModalState(() {
                        selectedCinema = val;
                        selectedRoom = null;
                        rooms = [];
                      });
                      if (val != null) {
                        final int cinemaId = val['id'] ?? 0;
                        final roomResponse = await _movieApiService.getRoomsByCinema(cinemaId);
                        setModalState(() {
                          rooms = roomResponse is Map ? (roomResponse['data'] ?? []) : [];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Chọn Phòng
                  DropdownButtonFormField<dynamic>(
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(
                      labelText: 'Chọn Phòng Chiếu',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.white),
                    initialValue: selectedRoom,
                    items: rooms.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r['name'] ?? 'Phòng'));
                    }).toList(),
                    onChanged: (val) => setModalState(() => selectedRoom = val),
                  ),
                  const SizedBox(height: 12),

                  // Chọn Giá Vé Thường
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Giá vé thường (basePrice VNĐ)',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chọn Giá Vé VIP
                  TextField(
                    controller: vipPriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Giá vé VIP (vipPrice VNĐ)',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chọn Giá Vé Couple
                  TextField(
                    controller: couplePriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Giá vé Couple (couplePrice VNĐ)',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chọn Thời Gian
                  ListTile(
                    title: Text(
                      selectedDateTime == null
                          ? 'Chọn ngày & giờ bắt đầu'
                          : 'Giờ chiếu: ${selectedDateTime.toString()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.amber),
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        if (!mounted) return;
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setModalState(() {
                            selectedDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () async {
                      if (selectedMovie == null ||
                          selectedRoom == null ||
                          selectedDateTime == null ||
                          priceController.text.isEmpty ||
                          vipPriceController.text.isEmpty ||
                          couplePriceController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
                        );
                        return;
                      }

                      final double price = double.tryParse(priceController.text) ?? 0.0;
                      final double vipPrice = double.tryParse(vipPriceController.text) ?? price;
                      final double couplePrice = double.tryParse(couplePriceController.text) ?? price;

                      Navigator.pop(modalContext);
                      setState(() => _isLoading = true);
                      try {
                        await _showtimeApiService.createShowtime(
                          movieId: selectedMovie!.id,
                          roomId: selectedRoom['id'],
                          startTime: selectedDateTime!.toIso8601String(),
                          basePrice: price,
                          vipPrice: vipPrice,
                          couplePrice: couplePrice,
                        );
                        _loadShowtimes();
                      } catch (e) {
                        setState(() => _isLoading = false);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi tạo suất chiếu: $e')),
                        );
                      }
                    },
                    child: const Text('TẠO SUẤT CHIẾU', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('Quản Lý Suất Chiếu', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadShowtimes),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showtimes.isEmpty
              ? const Center(child: Text('Chưa có suất chiếu nào', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _showtimes.length,
                  itemBuilder: (context, index) {
                    final st = _showtimes[index];

                    return ListTile(
                      leading: const Icon(Icons.schedule, color: Colors.amber),
                      title: Text('ID Suất chiếu: ${st.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Phòng: ${st.roomId} - Bắt đầu: ${st.startTime}\nGiá vé: ${st.basePrice} VNĐ',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E1E1E),
                              title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
                              content: Text('Bạn có chắc muốn xóa suất chiếu #${st.id}?', style: const TextStyle(color: Colors.grey)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteShowtime(st.id);
                                  },
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _openAddShowtimeDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
