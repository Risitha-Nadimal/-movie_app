import 'package:flutter/material.dart';
import 'package:movie_app/modals/movie_datail_model.dart';
import 'package:movie_app/modals/movies_model.dart';
import 'package:movie_app/services/api_sevices.dart';

class MovieDetails extends StatefulWidget {
  Movie movie;
  MovieDetails({required this.movie, super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  ApiService service = ApiService();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: service.getDetails(id: widget.movie.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MovieDetailsModel data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken),
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500${widget.movie.backdropPath.toString()}"),
                            fit: BoxFit.fill),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.movie.title.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.5,
                            height: size.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w500${widget.movie.posterPath.toString()}",
                                  ),
                                )),
                          ),
                          Column(
                            children: [
                              Text(
                                data.tagline.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.movie.overview.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    data.company!.isNotEmpty
                        ? const Text(
                            "Production Companies",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800),
                          )
                        : const Text(""),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List.generate(
                        data.company!.length,
                        (index) => data.company![index].logo.toString() != ""
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(20)),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.network(
                                          "https://image.tmdb.org/t/p/w500${data.company![index].logo.toString()}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Text(data.company![index].name
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      )),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
