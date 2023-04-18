import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../widgets/cardDescription.dart';

class PostDetail extends StatelessWidget {
  PostDetail(this.postdocid, {Key? key}) : super(key: key);
  String postdocid = "";

  @override
  Widget build(BuildContext context) {
    var snapshot = FirebaseFirestore.instance
        .collection('posts')
        .doc(postdocid) //ID OF DOCUMENT
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: StreamBuilder(
          stream: snapshot,
          builder: (context, snapshot) {
            var post = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final imageProvider =
                            Image.network(post["image_url"]).image;
                        showImageViewer(context, imageProvider);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(post['title']),
                          Text(post['description']),
                        ],
                      ),
                    ),
                    //email adress
                    Column(children: [
                      InkWell(
                        onTap: () {},
                        child: CardDescription(post["email"], Icons.email),
                      ),
                      InkWell(
                        onTap: () {},
                        child: CardDescription(post["phone"], Icons.phone),
                      ),
                      InkWell(
                        onTap: () {},
                        child:
                            CardDescription(post["telegram"], Icons.telegram),
                      ),
                    ]),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
