import 'package:flutter/material.dart';
import 'package:movies/Cards/MovieCard.dart';
import 'package:movies/HomeSection/HomeLists/Shimmers.dart';
import 'package:movies/Utilities/Utilities.dart';
import 'package:movies/models/Movie.dart';

class HorizontalUpcomingMoviesList extends StatelessWidget {
  const HorizontalUpcomingMoviesList(
      {Key? key, required this.getUpcomingMovies, required this.openItem})
      : super(key: key);

  final Function getUpcomingMovies;
  final Function openItem;

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      builder: (context, movieSnap) {
        if (movieSnap.connectionState != ConnectionState.done &&
            movieSnap.hasData == false) {
          return const Shimmers(); // Shimmer
        }
        List<Movie> items =
            Utilities.mapMovies((movieSnap.data as Map)["results"]);
        return items.isNotEmpty
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Movie item = items[index];
                  return MovieCard(item: item, openItem: openItem);
                },
                scrollDirection: Axis.horizontal,
              )
            : const Text("no data");
      },
      future: getUpcomingMovies(),
    );
  }
}
