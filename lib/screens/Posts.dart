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
      backgroundColor: Color.fromARGB(255, 190, 190, 190),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context, AsyncSnapshot postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final postDoc = postSnapshot.data!.docs;

            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              children: List.generate(postDoc.length, (index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      print(index);
                    },
                    child: Material(
                      child: Post(
                        postDoc[index]['image_url'],
                        postDoc[index]['title'],
                        postDoc[index]['price'],
                        postDoc[index]['email'],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
    );
  }
}
