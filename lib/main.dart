// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woah custom fonts!?',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: RandomWords(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        fontFamily: 'Inter',
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: SelectableText(
        pair.asPascalCase,
        style: TextStyle(
          fontFamily: 'Inter',
        ),
      ),
      leading: CircleAvatar(
        child: Text(
          pair.asPascalCase[0],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.purple : null,
      ),
      onTap: () {
        log('tapped');
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      // padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[i]);
      },
    );
  }

  void _pushSaved() {
    var page = MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: SelectableText(
                pair.asPascalCase,
              ),
            );
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: divided.isEmpty
              ? Center(child: Text('No Suggestions Saved'))
              : ListView(children: divided),
        );
      },
    );
    Navigator.of(context).push(page);
  }

  void _pushForm() {
    var page = MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Form'),
            ),
            body: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: const Text('Log in to your account',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                focusColor: Colors.purple,
                                prefixIcon: Icon(Icons.email_outlined)),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: 'Inter',
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                focusColor: Colors.purple,
                                prefixIcon: Icon(Icons.lock_outlined)),
                            obscureText: true,
                            style: TextStyle(
                              fontFamily: 'Inter',
                            ),
                          )),
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.purple),
                            enableFeedback: true),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
    Navigator.of(context).push(page);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ye', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border_outlined),
            onPressed: _pushSaved,
          ),
        ],
        elevation: 24,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _saved.clear();
            });
          },
          child: Icon(Icons.delete, color: Colors.purple),
          backgroundColor: Colors.white),
      body: _buildSuggestions(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
                tooltip: 'Home',
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: _pushSaved,
                tooltip: 'Favorites',
              ),
              IconButton(
                icon: Icon(Icons.supervised_user_circle),
                onPressed: _pushForm,
                tooltip: 'Form',
              )
            ],
          ),
        ),
      ),
    );
  }
}
