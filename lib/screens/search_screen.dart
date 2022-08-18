import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/screens/other_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  bool _isSearching = false;

  List<AppUser> searchResults = [];

  void searchForResults(String query) async {
    setState(() {
      _isSearching = true;
    });
    if (query.trim().isNotEmpty) {
      searchResults = await DatabaseService().getUsersByQuery(query);
    }
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 8,
                  color: Colors.blue,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8.0)),
                ),
                child: TextFormField(
                    controller: _queryController,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    showCursor: false,
                    onEditingComplete: () async =>
                        searchForResults(_queryController.text),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search By Name',
                        hintStyle: TextStyle(color: Colors.white))),
              ),
              !_isSearching
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NeumorphicButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => OtherProfileScreen(
                                                  user: searchResults[index],
                                                )));
                                  },
                                  padding: const EdgeInsets.all(0),
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    depth: 4,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(8.0)),
                                  ),
                                  child: ListTile(
                                    title: Text(searchResults[index].username),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(searchResults[
                                                  index]
                                              .profileImageUrl ??
                                          'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                      child: CircularProgressIndicator(),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
