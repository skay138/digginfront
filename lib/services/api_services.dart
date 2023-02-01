import 'dart:convert';

import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Account {
  static const String baseUrl = "http://diggin.kro.kr:4000/account/";

  static Future<dynamic> djangoLogin() async {
    late final user = FirebaseAuth.instance.currentUser;
    final userToken = await user!.getIdToken();
    Map<String, String> header = {"Authorization": "Bearer$userToken"};

    final response =
        await http.get(Uri.parse('${baseUrl}firebaselogin'), headers: header);
    if (response.statusCode == 200) {
      final profile = jsonDecode(response.body);
      return userModel.fromJson(profile);
    } else if (response.statusCode == 201) {
      return 'new';
    }
    throw Error();
  }

  static Future<userModel> getprofile(String uid) async {
    final url = Uri.parse('$baseUrl?uid=$uid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final profile = jsonDecode(response.body);
      return userModel.fromJson(profile);
    }
    throw Error();
  }
}

class Post {
  static const String baseUrl =
      "http://diggin.kro.kr:4000/post/?number=5&page=1";

  static Future<List<postModel>> getPosts() async {
    List<postModel> postinstances = [];
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> posts = jsonDecode(response.body);
      for (var post in posts) {
        final instance = postModel.fromJson(post);
        postinstances.add(instance);
      }
      return postinstances;
    } else {
      throw Error();
    }
  }
}
