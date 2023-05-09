import 'dart:async';

import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/cardDescription.dart';

class PostDetail extends StatelessWidget {
  PostDetail(this.postdocid, this.isOwner, {Key? key}) : super(key: key);
  String postdocid = "";
  bool isOwner;

  deletPost(BuildContext context, String postId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This action will permanently delete this data'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(
          postId,
        )
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red, content: Text("post Deleted")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = FirebaseFirestore.instance
        .collection('posts')
        .doc(postdocid) //ID OF DOCUMENT
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
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
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 30),
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Text(
                              post['title'],
                              style: const TextStyle(
                                  fontSize: 25, fontFamily: 'Raleway'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              post['description'],
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 20,
                      child: const Text(
                        "Contact me",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    //email adress
                    Card(
                      elevation: 5,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          //email
                          InkWell(
                            onTap: () {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: post["email"],
                              );

                              launchUrl(emailLaunchUri);
                            },
                            child: CardDescription(post["email"], Icons.email),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //phone call
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: post["phone"],
                              );
                              await launchUrl(launchUri);
                            },
                            child: CardDescription(post["phone"], Icons.phone),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //Telegrame
                          InkWell(
                            onTap: () async {
                              await launch(
                                "https://t.me/${post["telegram"]}",
                                forceSafariVC: false,
                                forceWebView: false,
                                headers: <String, String>{
                                  'my_header_key': 'my_header_value'
                                },
                              );
                            },
                            child: CardDescription(
                                post["telegram"], Icons.telegram),
                          ),
                        ]),
                      ),
                    ),
                    if (isOwner)
                      Card(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            deletPost(context, post.id);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.delete_forever_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
