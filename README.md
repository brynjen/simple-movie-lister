# Simple Movie Lister

A modern Flutter application for searching and listing movies with high-performance caching and pagination.

## Features

- **API**: Powered by the [TVMaze API](https://www.tvmaze.com/api) - No API Key Required!
- **Search**: Interactive search field that fetches movies on enter or button click.
- **Pagination**: Efficiently loads 20 movies at a time as you scroll.
- **Rich Thumbnails**: High-quality movie posters with efficient memory and disk caching via `cached_network_image`.
- **Material 3**: Modern UI design system with dynamic coloring.

## Architecture

- **Models**: Simple and extensible `Movie` model.
- **Services**: `MovieService` handles data fetching and pagination logic using the public TVMaze API.
- **UI**: Clean `MovieListPage` with `ScrollController` based pagination.

## Getting Started

1.  **Dependencies**: Run `flutter pub get`.
2.  **Run**: Launch the app via `flutter run` or VS Code.
3.  **Search**: Type a query in the search bar to start exploring movie awesomeness.