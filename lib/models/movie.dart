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
    return Movie(
      title: json['Title'] ?? 'No Title',
      year: json['Year'] ?? 'N/A',
      posterUrl: json['Poster'] ?? '',
      imdbId: json['imdbID'] ?? '',
    );
  }
}
