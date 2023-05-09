import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studecom/widgets/Post.dart';
import 'package:url_launcher/url_launcher.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

final userEmail = FirebaseAuth.instance.currentUser!.email;

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Posts",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // drawer header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.manage_accounts,
                      size: 50,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${userEmail}",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),

            //drawer list items

            ListTile(
              leading: const Icon(Icons.contact_emergency),
              title: const Text("Contact Us"),
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'getasewadane9@gmail.com',
                );

                launchUrl(emailLaunchUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'getasewadane9@gmail.com',
                );

                launchUrl(emailLaunchUri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/signin", (route) => false);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context, AsyncSnapshot postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final postDoc = postSnapshot.data!.docs;

            return ListView.builder(
                itemCount: postDoc.length == 0 ? 1 : postDoc.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Material(
                      child: Column(children: [
                        postDoc.length == 0
                            ? Container(
                                margin: const EdgeInsets.only(top: 200),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.bubble_chart_outlined,
                                      size: 200,
                                      color: Colors.purple,
                                    ),
                                    Text(
                                      "No Post Yet ",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.purple),
                                    ),
                                  ],
                                ))
                            : Post(
                                postDoc[index]['image_url'],
                                postDoc[index]['title'],
                                postDoc[index]['price'],
                                postDoc[index]['email'],
                                postDoc[index].id)
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
