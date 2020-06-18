import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class SavedWordsView extends StatelessWidget {
  const SavedWordsView({Key key, this.savedWordPairs}) : super(key: key);

  final Set<WordPair> savedWordPairs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Words"),
      ),
      body: savedWordPairs.length == 0 ? _emptySavedWords() : _buildListView(),
    );
  }

  Widget _emptySavedWords() {
    return Center(
      child: Text("Your saved words is empty."),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: savedWordPairs.length,
      itemBuilder: (context, index) {
        final word = savedWordPairs.elementAt(index);

        return ListTile(
          title: Text(word.asPascalCase),
        );
      },
    );
  }
}
