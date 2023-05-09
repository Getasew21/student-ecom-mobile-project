import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studecom/screens/PostDetail.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user = FirebaseAuth.instance.currentUser;
  var userEmail = FirebaseAuth.instance.currentUser?.email.toString();
  final postRef = FirebaseFirestore.instance.collection("posts");
  var isAdmin = false;
  int? postNumber;

  void checkUserStatus() async {
    var permission = await FirebaseFirestore.instance
        .collection("users")
        .where("isadmin", isEqualTo: true)
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    var postNum = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    if (mounted) {
      setState(() {
        isAdmin = permission.docs.isNotEmpty;
        postNumber = postNum.docs.first["totalpost"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserStatus();
    print(postNumber);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profile"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
            ListTile(
              title: const Text('Create post'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/signup", (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("email", isEqualTo: userEmail ?? "")
                .snapshots(),
            builder: (context, snapshot) {
              final postDoc = snapshot.hasData ? snapshot.data!.docs : [];
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
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
                            //circular avator
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 40,
                                  child: const Icon(
                                    Icons.manage_accounts,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  user!.email.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),

                            Column(
                              children: [
                                Text(
                                  '${postNumber}',
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const Text(
                                  "Total Posts",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //user admin card
                        if (isAdmin)
                          Card(
                            color: Color.fromARGB(209, 1, 108, 112),
                            child: GestureDetector(
                              child: const ListTile(
                                title: Text(
                                  'User Admin',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/admin');
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("RECENT POSTS"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: GridView.count(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount: 3,
                              children: List.generate(postDoc.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PostDetail(
                                          postDoc[index].id, true);
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
                                        child: CircularProgressIndicator(),
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
      ),
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
