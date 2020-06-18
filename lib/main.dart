import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpair_flutter/saved_words.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _wordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();
  ScrollController _scrollController = ScrollController();
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  void checkUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (!(_sharedPreferences.getBool("isLoggedIn") ?? false)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WordPair Generator"),
        leading: InkWell(
          child: Center(
            child: Text("Clear"),
          ),
          onTap: () => setState(() => _savedWordPairs.clear()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SavedWordsView(
                    savedWordPairs: _savedWordPairs,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );

              await _sharedPreferences.clear();
            },
          ),
        ],
      ),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        tooltip: "Scroll to Top",
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _savedWordPairs.contains(wordPair);

    return ListTile(
      title: Text(wordPair.asPascalCase),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(wordPair);
            _wordPairs.remove(wordPair);
            _wordPairs.insert(_savedWordPairs.length, wordPair);
          } else {
            _wordPairs.remove(wordPair);
            _wordPairs.insert(_savedWordPairs.length, wordPair);
            _savedWordPairs.add(wordPair);
          }
        });
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider();

        final item = index ~/ 2;

        if (item >= _wordPairs.length) {
          _wordPairs.addAll(generateWordPairs().take(20));
        }

        return _buildRow(_wordPairs[item]);
      },
    );
  }
}
