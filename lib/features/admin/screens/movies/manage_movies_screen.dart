import 'package:flutter/material.dart';
import 'package:tet/data/models/movie.dart';
import '../../../../data/repositories/movie_repository.dart';
import 'add_edit_movie_screen.dart';
import 'widgets/movie_list_tile.dart';

class ManageMoviesScreen extends StatefulWidget {
  const ManageMoviesScreen({super.key});

  @override
  State<ManageMoviesScreen> createState() => _ManageMoviesScreenState();
}

class _ManageMoviesScreenState extends State<ManageMoviesScreen> {
  final MovieRepository _movieRepository = MovieRepository();
  List<Movie> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    try {
      final data = await _movieRepository.getAllMovies();
      setState(() {
        _movies = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải danh sách phim: $e')),
      );
    }
  }

  Future<void> _deleteMovie(int movieId) async {
    // await _movieRepository.deleteMovie(movieId);
    _loadMovies();
  }

  void _confirmDelete(Movie movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text('Bạn có chắc chắn muốn xóa phim "${movie.title}"?',
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMovie(movie.id);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _goToAddEdit([Movie? movie]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditMovieScreen(movie: movie)),
    ).then((value) {
      if (value == true) _loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('Quản Lý Phim', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadMovies),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _movies.isEmpty
              ? const Center(child: Text('Chưa có phim nào', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _movies.length,
                  itemBuilder: (_, i) {
                    final movie = _movies[i];
                    return MovieListTile(
                      movie: movie,
                      onEdit: () => _goToAddEdit(movie),
                      onDelete: () => _confirmDelete(movie),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _goToAddEdit(),
      ),
    );
  }
}
