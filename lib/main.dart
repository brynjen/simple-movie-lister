import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_movie_lister/models/movie.dart';
import 'package:simple_movie_lister/services/movie_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Lister',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieListPage(),
    );
  }
}

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Movie> _movies = [];
  bool _isLoading = false;
  int _currentPage = 1;
  String _currentQuery = '';
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMovies();
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _movies = [];
      _currentPage = 1;
      _currentQuery = query;
      _hasMore = true;
      _isLoading = true;
    });

    try {
      final results = await _movieService.searchMovies(query, _currentPage);
      setState(() {
        _movies = results;
        _isLoading = false;
        if (results.length < 20) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading movies: $e')),
        );
      }
    }
  }

  Future<void> _loadMovies() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      _currentPage++;
      final results = await _movieService.searchMovies(_currentQuery, _currentPage);
      setState(() {
        _movies.addAll(results);
        _isLoading = false;
        if (results.length < 20) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Movie Lister'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for movies...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _movies.isEmpty && !_isLoading
                ? const Center(child: Text('Search for movies to see results'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _movies.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _movies.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final movie = _movies[index];
                      return ListTile(
                        leading: Hero(
                          tag: movie.imdbId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterUrl,
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.movie),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
