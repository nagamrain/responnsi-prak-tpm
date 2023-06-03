// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Informasi Film',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SharedPreferences logindata;
  late String username;
  TextEditingController searchController = TextEditingController();
  List<dynamic> movies = [];

  Future<void> searchMovies() async {
    final apiKey = '46539e83';
    final query = searchController.text;

    final response = await http.get(
      Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&s=$query'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        movies = jsonData['Search'];
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Gagal mengambil data movie.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Pencarian Film dan Series Film"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              logindata.setBool('login', true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyLoginPage()));
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 231, 184, 30),
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu Icon',
          onPressed: () {},
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: searchMovies,
            child: const Text('Search'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie['Title']),
                  subtitle: Text(movie['Year']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(movie: movie),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class DetailScreen extends StatefulWidget {
//   final dynamic moviesName;
//   DetailScreen({required this.moviesName});

//   @override
//   _DetailScreenState createState() => _DetailScreenState(movies: moviesName);
// }

// class _DetailScreenState extends State<DetailScreen> {
//   var movies;
//   _DetailScreenState({required this.movies});
//   dynamic movie;
//   bool isLoading = true;

//   get http => null;

//   @override
//   void initState() {
//     super.initState();
//     fetchMovieDetails();
//   }

//   Future<void> fetchMovieDetails() async {
//     final apiKey = '46539e83';
//     final movieTitle = movies;

//     final response = await http.get(
//       Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&t=$movieTitle'),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       setState(() {
//         movie = jsonData;
//         isLoading = false;
//       });
//     } else {
//       // ignore: use_build_context_synchronously
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Gagal menampilkan detail movie.'),
//             actions: [
//               TextButton(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Movie Details'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (movie['Poster'] != 'N/A') Image.network(movie['Poster']),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Title: ${movie['Title']}'),
//                       Text('Year: ${movie['Year']}'),
//                       Text('Rated: ${movie['Rated']}'),
//                       Text('Runtime: ${movie['Runtime']}'),
//                       Text('Genre: ${movie['Genre']}'),
//                       Text('Director: ${movie['Director']}'),
//                       Text('Actors: ${movie['Actors']}'),
//                       Text('Plot: ${movie['Plot']}'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

class DetailScreen extends StatelessWidget {
  final dynamic movie;
  DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['Title']),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: const Color.fromARGB(255, 231, 184, 30),
        elevation: 50.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (movie['Poster'] != 'N/A') Image.network(movie['Poster']),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${movie['Title']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text('Tahun Release: ${movie['Year']}'),
                Text('Tipe: ${movie['Type']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
