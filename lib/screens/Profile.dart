import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studecom/screens/PostDetail.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  var user = FirebaseAuth.instance.currentUser;
  var userEmail = FirebaseAuth.instance.currentUser?.email.toString();

  final postRef = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .where("email", isEqualTo: userEmail ?? "")
              .snapshots(),
          builder: (context, snapshot) {
            final postDoc = snapshot.hasData ? snapshot.data!.docs : [];
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 40,
                                child: Icon(Icons.manage_accounts, size: 60),
                              ),
                              Text("${postDoc.length}")
                            ],
                          ),
                          Column(
                            children: const [
                              Text("5"),
                              Text("posts"),
                            ],
                          ),
                          Column(
                            children: [Text("data")],
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: GridView.count(
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            crossAxisCount: 4,
                            children: List.generate(postDoc.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PostDetail(postDoc[index].id);
                                  }));
                                },
                                child: Image.network(
                                  postDoc[index]["image_url"],
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 30),
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ))
                    ],
                  ));
            }
          }),
    );
  }

  void showEditDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey("username"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'please enter a valid password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "password"),
                    onSaved: ((newValue) {}),
                  ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'please enter a valid password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: "password"),
                    onSaved: ((newValue) {}),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
