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
      appBar: AppBar(
        title: Text("posts"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context, AsyncSnapshot postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final postDoc = postSnapshot.data!.docs;

            return ListView.builder(
                itemCount: postDoc.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        print(postDoc[index]['title']);
                      },
                      child: Material(
                        child: Column(children: [
                          Post(
                              postDoc[index]['image_url'],
                              postDoc[index]['title'],
                              postDoc[index]['price'],
                              postDoc[index]['email'],
                              postDoc[index].id),
                        ]),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
