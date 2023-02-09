import 'dart:convert';

import 'package:digginfront/models/commentModel.dart';
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
    } else {
      print(response);
    }
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
  static const String baseUrl = "http://diggin.kro.kr:4000/post/";

  static Future<List<postModel>> getRecommendedPost() async {
    const String recommended = "search?recommended=5";
    List<postModel> postinstances = [];
    final url = Uri.parse('$baseUrl$recommended');
    final response = await http.get(url);
    try {
      final List<dynamic> posts = jsonDecode(response.body);
      for (var post in posts) {
        final instance = postModel.fromJson(post);
        postinstances.add(instance);
      }
      return postinstances;
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  static Future<List<postModel>> getRecentPosts(int number, int page) async {
    String recentPosts = "?number=$number&page=$page";
    List<postModel> postinstances = [];
    final url = Uri.parse('$baseUrl$recentPosts');
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

  static Future<List<postModel>> getMyPosts(String uid) async {
    String recentPosts = "mypost?uid=$uid";
    List<postModel> postinstances = [];
    final url = Uri.parse('$baseUrl$recentPosts');
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

class Comment {
  static const String baseUrl = "http://diggin.kro.kr:4000/comment/";

  static Future<List<commentModel>> getComment(int postId) async {
    String postid = postId.toString();
    List<commentModel> commentinstances = [];
    final url = Uri.parse('$baseUrl$postid');
    final response = await http.get(url);
    try {
      final List<dynamic> comments = jsonDecode(response.body);
      for (var comment in comments) {
        final instance = commentModel.fromJson(comment);
        commentinstances.add(instance);
      }
      return commentinstances;
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
