import 'package:digginfront/models/postModel.dart';
import 'package:digginfront/models/userModel.dart';
import 'package:digginfront/services/api_services.dart';
import 'package:digginfront/widgets/search_list_view.dart';
import 'package:digginfront/widgets/search_user_view.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  late Future<List<postModel>> searchTitleResult;
  late Future<List<postModel>> searchAuthorResult;
  late Future<List<userModel>> searchUserResult;
  bool searched = false;

  emptyTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(str) async {
    setState(() {
      searchTitleResult = Posting.searchPost(str, 'title');
      searchAuthorResult = Posting.searchPost(str, 'author');
      searchUserResult = Account.getSearchUser(str);
      searched = true;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchTextEditingController,
        decoration: InputDecoration(
            hintText: '검색어를 입력해주세요...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            prefixIcon: const Icon(
              Icons.search,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: emptyTextFormField,
            )),
        style: const TextStyle(fontSize: 18),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  displayNoSearchResultScreen() {
    return Container(
        child: Center(
            child: ListView(
      shrinkWrap: true,
      children: const <Widget>[
        // Icon(Icons.group, color: Colors.grey, size: 150),
        Text(
          'Search Page',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 40),
        ),
      ],
    )));
  }

  displaySearchFoundScreen() {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: FutureBuilder(
              future: searchUserResult,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '유저 검색 결과',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SearchUserView(users: searchUserResult),
                    ],
                  ),
                );
              }),
        ),
        Flexible(
          flex: 4,
          child: FutureBuilder(
              future: searchTitleResult,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '타이틀 검색 결과',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SearchListView(posts: searchTitleResult),
                    ],
                  ),
                );
              }),
        ),
        Flexible(
          flex: 4,
          child: FutureBuilder(
              future: searchAuthorResult,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '작성자 검색 결과',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SearchListView(posts: searchAuthorResult),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: searchPageHeader(),
      body:
          searched ? displaySearchFoundScreen() : displayNoSearchResultScreen(),
    );
  }
}
