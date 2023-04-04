import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studecom/widgets/Post.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context, AsyncSnapshot postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final postDoc = postSnapshot.data!.docs;

            return GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(postDoc.length, (index) {
                return Center(
                  child: Post(
                    postDoc[index]['image_url'],
                    postDoc[index]['title'],
                    postDoc[index]['price'],
                    postDoc[index]['email'],
                  ),
                );
              }),
            );
          }),
    );
  }
}
