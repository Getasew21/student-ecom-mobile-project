import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetail extends StatelessWidget {
  PostDetail(this.postdocid, {Key? key}) : super(key: key);
  String postdocid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("post"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(postdocid) //ID OF DOCUMENT
              .snapshots(),
          builder: (context, snapshot) {
            var post = snapshot.data;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Image.network(
                            post!['image_url'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 30),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Column(children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 15,
                          shadowColor: Theme.of(context).primaryColor,
                          child: Row(children: [
                            Container(
                              child: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(post["email"]),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 10,
                          shadowColor: Theme.of(context).primaryColor,
                          child: Row(children: [
                            Container(
                              child: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(post["email"]),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 15,
                          shadowColor: Theme.of(context).primaryColor,
                          child: Row(children: [
                            Container(
                              child: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(post["email"]),
                            )
                          ]),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
