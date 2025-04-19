import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_app/modals/movie_datail_model.dart';
import 'package:movie_app/modals/movies_model.dart';

class ApiService {
  final aiken = "api_key=06f55ef6b15be934f95b8147bdc4a4bc";
  final popular = "https://api.themoviedb.org/3/movie/popular?";
//send request
  Future<List<Movie>> getMovies({required int page}) async {
    Response response = await get(Uri.parse("$popular$aiken&page=$page"));

    // check responce status code
    if (response.statusCode == 200) {
      //extract responce body
      Map<String, dynamic> body = jsonDecode(response.body);

      //extarct result from body
      List<dynamic> data = body['results'];

      // map to movie modal
      List<Movie> movies = data.map((movie) => Movie.fromJason(movie)).toList();
      return movies;
    } else {
      throw Exception(response.statusCode);
    }
  }

//movie data fetching and put datas to models
  Future<MovieDetailsModel> getDetails({required String id}) async {
     String url = "https://api.themoviedb.org/3/movie/$id?$aiken";
  print("URL: $url");
  
  Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
       print(json);
      return MovieDetailsModel.fromJson(json);
    } else {
      throw Exception(response.statusCode);
    }
  }
}
