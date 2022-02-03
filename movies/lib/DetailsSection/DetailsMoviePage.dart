import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:movies/AppBar/AppBar.dart';
import 'package:movies/Colors/Colors.dart';
import 'package:movies/Constants/Constants.dart';
import 'package:movies/SearchSection/GridViewSearch/GridViewCard/GridViewCard.dart';
import 'package:movies/Utilities/Utilities.dart';
import 'package:movies/data_manager/DataManager.dart';
import 'package:movies/models/interfaces/MovieDetails.dart';
import 'package:movies/models/providers/ProviderFavs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DetailsMoviePage extends StatefulWidget {
  const DetailsMoviePage({Key? key, required this.item}) : super(key: key);

  final dynamic item;

  @override
  State<DetailsMoviePage> createState() => _DetailsMoviePageState();
}

class _DetailsMoviePageState extends State<DetailsMoviePage> {
  DataManager dataManager = DataManager();
  dynamic get _item => widget.item;
  MovieDetails _movieDetails = initialMovieDetails;
  bool isFavourite = false;

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: ColorSelect.customBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ));

  void _getDetails() async {
    MovieDetails newMovieDetails = await dataManager.getMovieDetails(_item.id);
    if (mounted) {
      setState(() {
        _movieDetails = newMovieDetails;
      });
    }
    final Box<dynamic> _favBox = Hive.box<dynamic>("favBox");
    List<dynamic> newList = [];
    if (_favBox.get("favourites") ?? true) {
      newList = Utilities.fromHiveToDataGenericItem(_favBox.get("favourites"));
    }
    if (newList.indexWhere((element) => element.id == _item.id) >= 0) {
      setState(() {
        isFavourite = true;
      });
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _getDetails();
    });
    super.initState();
  }

  void _openLink() async {
    if (!await launch(
        _movieDetails.homepage != "" ? _movieDetails.homepage : "")) {
      throw 'Could not launch ${_movieDetails.homepage}';
    }
  }

  void _manageFavourites() async {
    final Box<dynamic> _favBox = Hive.box<dynamic>("favBox");
    List<dynamic> tempList = [];
    if (_favBox.get("favourites") ?? true) {
      tempList = _favBox.get("favourites");
      if (tempList.any((element) => element.id == _item.id)) {
        tempList.removeWhere((element) => element.id == _item.id);
        setState(() {
          isFavourite = false;
        });
      } else {
        tempList = [...tempList, Utilities.fromDataToHiveMovie(_item)];
        setState(() {
          isFavourite = true;
        });
      }
    }
    _favBox.put("favourites", tempList);
  }

  void _launchTrailer() async {
    if (!await launch('$youtubePath${_movieDetails.trailer}')) {
      throw 'Could not launch $youtubePath${_movieDetails.trailer}';
    }
  }

  void _navigateBack() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderFavs>(builder: (context, favProvider, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: const CustomAppBar(),
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: FloatingActionButton(
                  onPressed: _navigateBack,
                  backgroundColor: const Color.fromARGB(215, 255, 255, 255),
                  child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white)))),
          body: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(children: [
                    const Padding(padding: EdgeInsets.only(top: 75)),
                    InkWell(
                        onTap: _launchTrailer,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                              height: 240,
                              child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FittedBox(
                                        child: _item.backdropPath != ""
                                            ? FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/placeholder_movie.png',
                                                image:
                                                    '$basePathImages${_item.backdropPath}')
                                            : Container(
                                                height: 240,
                                                child: const FittedBox(
                                                    child: Image(
                                                  image: AssetImage(
                                                      "assets/images/placeholder_movie.png"),
                                                  fit: BoxFit.cover,
                                                ))),
                                        fit: BoxFit.cover),
                                    Container(
                                        height: 240,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            gradient: RadialGradient(
                                                center: Alignment.center,
                                                radius: 1.0,
                                                colors: [
                                                  Colors.black54,
                                                  Colors.grey.withOpacity(0.0),
                                                ],
                                                stops: const [
                                                  0.0,
                                                  1.0,
                                                ]))),
                                    Container(
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.play_arrow_outlined,
                                            size: 120,
                                            color: Colors.white70))
                                  ],
                                  fit: StackFit.expand)),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                          _movieDetails.title != "" ? _movieDetails.title : "",
                          style: const TextStyle(
                              fontSize: 28, color: Colors.white70)),
                    ),
                    Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 5, bottom: 30),
                          child: Stack(
                              alignment: Alignment.bottomRight,
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                        height: 170,
                                        child: _item.posterPath != ""
                                            ? FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/movie_poster_placeholder.jpeg',
                                                image:
                                                    '$basePathImages${_item.posterPath}')
                                            : Container(
                                                height: 170,
                                                child: const FittedBox(
                                                    child: Image(
                                                  image: AssetImage(
                                                      "assets/images/movie_poster_placeholder.jpeg"),
                                                  fit: BoxFit.cover,
                                                ))))),
                                Transform.translate(
                                    offset: const Offset(5, 10),
                                    child: ClipOval(
                                        child: CircularPercentIndicator(
                                      radius: 30,
                                      lineWidth: 7,
                                      backgroundColor: Colors.white,
                                      fillColor: Colors.grey.withOpacity(0.8),
                                      progressColor: ColorSelect.customBlue,
                                      percent: _movieDetails.voteAverage
                                              .ceilToDouble() /
                                          10,
                                      center: Text(
                                          _movieDetails.voteAverage.toString(),
                                          style: const TextStyle(
                                              color: ColorSelect.customBlue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ))),
                              ])),
                      Expanded(
                          child: Column(children: [
                        Center(
                            child: Column(children: [
                          Text("Length: ${_movieDetails.runtime} minutes"),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: ElevatedButton(
                                  onPressed: _openLink,
                                  style: buttonStyle,
                                  child: const Text("Open site"))),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ElevatedButton(
                                  onPressed: _manageFavourites,
                                  style: buttonStyle,
                                  child: isFavourite
                                      ? const Text("Remove from favourites")
                                      : const Text("Add to favourites")))
                        ])),
                        Row(children: [
                          _movieDetails.watchProviders.isNotEmpty
                              ? GridView.builder(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount:
                                      _movieDetails.watchProviders.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Container(
                                            height: 60,
                                            width: 60,
                                            color: Colors.white,
                                            child: _movieDetails
                                                        .watchProviders[index]
                                                        .logoPath !=
                                                    ""
                                                ? FadeInImage.assetNetwork(
                                                    placeholder: '',
                                                    image:
                                                        '$basePathImages${_movieDetails.watchProviders[index].logoPath}')
                                                : Container()));
                                  })
                              : Container()
                        ])
                      ]))
                    ]),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                color: ColorSelect.customBlue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: _movieDetails.description != ""
                                    ? Text(_movieDetails.description,
                                        style: const TextStyle(
                                            fontSize: 16, height: 1.4))
                                    : Container(width: 0, height: 0)))),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _movieDetails.gallery.isNotEmpty
                        ? const Text("Gallery",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))
                        : Container(),
                    _movieDetails.gallery.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.only(top: 15, bottom: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _movieDetails.gallery.length,
                            itemBuilder: (context, index) {
                              return (ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                      height: 60,
                                      width: 110,
                                      child: _movieDetails.gallery[index] != ""
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/placeholder_movie.png',
                                              image:
                                                  '$basePathImages${_movieDetails.gallery[index]}')
                                          : Container(
                                              height: 60,
                                              width: 110,
                                              child: const FittedBox(
                                                  child: Image(
                                                image: AssetImage(
                                                    "assets/images/placeholder_movie.png"),
                                                fit: BoxFit.cover,
                                              ))))));
                            })
                        : Container(),
                    _movieDetails.similars.isNotEmpty
                        ? const Text("Suggested",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600))
                        : Container(),
                    _movieDetails.similars.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.only(top: 15, bottom: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _movieDetails.similars.length,
                            itemBuilder: (context, index) {
                              return GridViewCard(
                                  item: _movieDetails.similars[index]);
                            })
                        : Container(),
                  ]))));
    });
  }
}
