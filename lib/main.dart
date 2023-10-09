import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/user.dart';

void main() {
  runApp(
    const MaterialApp(
      home: FetchData(),
    ),
  );
}

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  List<User> users = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fetch Data API"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user.firstName;
          final email = user.email;
          final imageUrl = user.imgUrl;

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(imageUrl),
            ),
            title: Text(name),
            subtitle: Text(email),
          );
        },
      ),
    );
  }

  //make this function in another file.
  Future<void> fetchData() async {
    print("Fetching Started!");
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    final transformed = results.map((user) {
      return User(
        firstName: user['name']['first'],
        email: user['email'],
        imgUrl: user['picture']['thumbnail']
      );
    }).toList();
    setState(() {
      users = transformed;
    });
    print("Fetching completed!");
  }
}
