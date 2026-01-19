class Movie {
  final String title;
  final String year;
  final String posterUrl;
  final String imdbId;

  Movie({
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.imdbId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final show = json['show'] ?? {};
    final image = show['image'] ?? {};
    final externals = show['externals'] ?? {};
    
    return Movie(
      title: show['name'] ?? 'No Title',
      year: (show['premiered'] ?? '').split('-').first,
      posterUrl: image['medium'] ?? '',
      imdbId: externals['imdb'] ?? '',
    );
  }
}
