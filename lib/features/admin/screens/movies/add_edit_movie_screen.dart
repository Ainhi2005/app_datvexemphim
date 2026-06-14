import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tet/data/models/movie.dart';
import 'package:tet/data/repositories/movie_repository.dart';
import 'package:tet/data/repositories/user_repository.dart';

class AddEditMovieScreen extends StatefulWidget {
  final Movie? movie; // Nhận phim nếu ở chế độ chỉnh sửa

  const AddEditMovieScreen({super.key, this.movie});

  @override
  State<AddEditMovieScreen> createState() => _AddEditMovieScreenState();
}

class _AddEditMovieScreenState extends State<AddEditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final MovieRepository _movieRepository = MovieRepository();

  // Các Controller cho các ô nhập liệu
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;
  late TextEditingController _posterUrlController;
  
  // Các Controller mới
  late TextEditingController _genresController;
  late TextEditingController _directorsController;

  bool _isEditMode = false;
  bool _isLoading = false;
  
  final ImagePicker _imagePicker = ImagePicker();
  String? _localPosterPath;

  // Biến cho các trường kiểu dropdown/date
  DateTime? _releaseDate;
  DateTime? _endDate;
  String _ageRating = 'P';
  String _language = 'Vietsub';

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.movie != null;

    // Khởi tạo các giá trị cũ nếu đang ở chế độ Edit
    _titleController = TextEditingController(text: _isEditMode ? widget.movie!.title : '');
    _durationController = TextEditingController(text: _isEditMode ? widget.movie!.duration.toString() : '');
    _descriptionController = TextEditingController(text: _isEditMode ? widget.movie!.description : '');
    _posterUrlController = TextEditingController(text: _isEditMode ? widget.movie!.posterUrl : '');
    
    _genresController = TextEditingController(text: _isEditMode ? widget.movie!.genres.join(', ') : '');
    _directorsController = TextEditingController(text: _isEditMode ? widget.movie!.directors.join(', ') : '');
    
    if (_isEditMode) {
      _releaseDate = widget.movie!.releaseDate;
      _endDate = widget.movie!.endDate;
      _ageRating = widget.movie!.ageRating.isNotEmpty ? widget.movie!.ageRating : 'P';
      _language = widget.movie!.language.isNotEmpty ? widget.movie!.language : 'Vietsub';
    }

    _posterUrlController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _posterUrlController.dispose();
    _genresController.dispose();
    _directorsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _localPosterPath = pickedFile.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã chọn ảnh poster mới!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_releaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày chiếu')));
      return;
    }
    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày kết thúc')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String title = _titleController.text;
      final int duration = int.parse(_durationController.text);
      final String description = _descriptionController.text;
      String posterUrl = _posterUrlController.text;

      // Chuyển chuỗi phẩy thành List<String>
      final List<String> genres = _genresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final List<String> directors = _directorsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final String releaseDateStr = _releaseDate!.toIso8601String();
      final String endDateStr = _endDate!.toIso8601String();

      // Chỉ thực hiện upload lên Cloudinary khi nhấn Save/Submit nếu có chọn ảnh mới
      if (_localPosterPath != null) {
        posterUrl = await UserRepository().uploadImage(_localPosterPath!);
      }

      if (_isEditMode) {
        await _movieRepository.updateMovie(
          widget.movie!.id,
          title: title,
          duration: duration,
          description: description,
          posterUrl: posterUrl,
          genres: genres,
          directors: directors,
          releaseDate: releaseDateStr,
          endDate: endDateStr,
          ageRating: _ageRating,
          language: _language,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật phim thành công!')));
      } else {
        await _movieRepository.createMovie(
          title: title,
          duration: duration,
          description: description,
          posterUrl: posterUrl,
          genres: genres,
          directors: directors,
          releaseDate: releaseDateStr,
          endDate: endDateStr,
          ageRating: _ageRating,
          language: _language,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm phim mới thành công!')));
      }

      if (!mounted) return;
      Navigator.pop(context, true); // Trả về true báo cho màn hình trước để tải lại danh sách
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: Text(_isEditMode ? 'Chỉnh Sửa Phim' : 'Thêm Phim Mới', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Tên phim
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Tên phim',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên phim' : null,
                    ),
                    const SizedBox(height: 16),

                    // Thời lượng phim
                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Thời lượng (phút)',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Vui lòng nhập thời lượng';
                        if (int.tryParse(value) == null) return 'Thời lượng phải là số nguyên';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Thể loại
                    TextFormField(
                      controller: _genresController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Thể loại (phân tách bằng dấu phẩy)',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập thể loại' : null,
                    ),
                    const SizedBox(height: 16),

                    // Đạo diễn
                    TextFormField(
                      controller: _directorsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Đạo diễn (phân tách bằng dấu phẩy)',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập đạo diễn' : null,
                    ),
                    const SizedBox(height: 16),

                    // Giới hạn độ tuổi & Ngôn ngữ
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _ageRating,
                            dropdownColor: const Color(0xFF1A1A1A),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Độ tuổi giới hạn',
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                            items: ['P', 'K', 'T13', 'T16', 'T18'].map((rating) {
                              return DropdownMenuItem(
                                value: rating,
                                child: Text(rating),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _ageRating = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _language,
                            dropdownColor: const Color(0xFF1A1A1A),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Ngôn ngữ',
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                            items: ['Vietsub', 'Lồng tiếng', 'Nguyên bản'].map((lang) {
                              return DropdownMenuItem(
                                value: lang,
                                child: Text(lang),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _language = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ngày chiếu & Ngày kết thúc
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _releaseDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _releaseDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Ngày khởi chiếu',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                              child: Text(
                                _releaseDate == null
                                    ? 'Chọn ngày'
                                    : '${_releaseDate!.day}/${_releaseDate!.month}/${_releaseDate!.year}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _endDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Ngày kết thúc',
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                              child: Text(
                                _endDate == null
                                    ? 'Chọn ngày'
                                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Đường dẫn Poster Phim
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _posterUrlController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Đường dẫn ảnh Poster (URL)',
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            ),
                            validator: (value) => value == null || value.isEmpty && _localPosterPath == null ? 'Vui lòng nhập URL ảnh hoặc chọn ảnh mới' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.image, color: Colors.amber),
                          tooltip: 'Chọn ảnh từ thư viện',
                          onPressed: _pickImage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Preview ảnh poster nếu có
                    if (_localPosterPath != null || _posterUrlController.text.isNotEmpty) ...[
                      Center(
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: _localPosterPath != null
                                ? Image.file(
                                    File(_localPosterPath!),
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    _posterUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Mô tả nội dung phim
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Mô tả nội dung',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Nút xác nhận lưu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _submitForm,
                      child: Text(_isEditMode ? 'Cập Nhật' : 'Thêm Mới', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
