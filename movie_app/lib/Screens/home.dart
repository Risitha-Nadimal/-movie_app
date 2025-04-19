import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/Screens/movie_Details.dart';
import 'package:movie_app/modals/movies_model.dart';
import 'package:movie_app/services/api_sevices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService service = ApiService();
  List<Movie> movies = [];
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                  ),
                  Text(
                    "TMDB movies",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.favorite)
                ],
              ),
              FutureBuilder(
                future: service.getMovies(page: page),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    movies = [...movies, ...snapshot.data!];
                    movies = movies.toSet().toList();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.59),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>  MovieDetails(movie:movies[index] ),
                                ));
                          },
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: NetworkImage(
                                              "https://image.tmdb.org/t/p/w500${movies[index].posterPath}"))),
                                ),
                              ),
                              Text(
                                movies[index].title.toString(),
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page++;
                    });
                  },
                  child: const Text("Load More"))
            ],
          ),
        ),
      ),
    ));
  }
}
