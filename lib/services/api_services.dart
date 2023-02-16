import 'dart:convert';
import 'dart:io';

import 'package:digginfront/models/commentModel.dart';
import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  static Future<String> profileUpdate(
      Map<String, dynamic> userInfo, File? image, File? bgimage) async {
    final url = Uri.parse(baseUrl);
    final req = http.MultipartRequest('PUT', url);
    req.fields['uid'] = userInfo['uid'];
    req.fields['email'] = userInfo['email'];
    req.fields['nickname'] = userInfo['nickname'];
    req.fields['introduce'] = userInfo['introduce'];
    req.fields['gender'] = userInfo['gender'];
    req.fields['is_signed'] = 'True';
    if (userInfo['birth'].runtimeType == DateTime) {
      req.fields['birth'] = DateFormat('yyyy-MM-dd').format(userInfo['birth']);
    }
    if (image != null) {
      req.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    if (bgimage != null) {
      req.files.add(await http.MultipartFile.fromPath('image', bgimage.path));
    }

    final response = await req.send();
    final result = await http.Response.fromStream(response);
    if (result.statusCode == 200) {
      final res = jsonDecode(result.body);
      return res['status'];
    }
    throw Error();
  }

  static Future<userModel> getProfile(String uid) async {
    final url = Uri.parse('$baseUrl?uid=$uid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final profile = jsonDecode(response.body);
      return userModel.fromJson(profile);
    }
    throw Error();
  }

  static Future<List<userModel>> getSearchUser(String nickname) async {
    String usersearch = "search?nickname=$nickname";
    List<userModel> userinstances = [];
    final url = Uri.parse('$baseUrl$usersearch');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      for (var user in users) {
        final instance = userModel.fromJson(user);
        userinstances.add(instance);
      }
      return userinstances;
    } else {
      throw Error();
    }
  }

  static Future<String> isFollowing(String follower, String followee) async {
    String follow = "follow?follower=$follower&followee=$followee";
    final url = Uri.parse('$baseUrl$follow');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'true') {
        return 'true';
      } else {
        return 'false';
      }
    } else {
      throw Error();
    }
  }

  static Future<List<userModel>> getFollow(String uid, String type) async {
    String follow = "follow?$type=$uid";
    List<userModel> userinstances = [];
    final url = Uri.parse('$baseUrl$follow');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      for (var user in users) {
        final instance = userModel.fromJson(user);
        userinstances.add(instance);
      }
      return userinstances;
    } else {
      throw Error();
    }
  }
}

class Posting {
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
      return postinstances;
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
      return postinstances;
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

  static Future<List<postModel>> getMyFeed(String uid) async {
    String recentPosts = "myfeed?uid=$uid";
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

  static Future<bool> newPosting(Map<String, dynamic> postInfo) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: postInfo,
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    }
    throw Error();
  }

  static Future<List<postModel>> searchPost(String keyword, String type) async {
    String search = "search?$type=$keyword";
    List<postModel> postinstances = [];
    final url = Uri.parse('$baseUrl$search');
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
