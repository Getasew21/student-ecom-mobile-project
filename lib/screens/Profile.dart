import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studecom/screens/PostDetail.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profile"),
      ),

      //drawer
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

            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pushNamed(context, "/admin");
                },
              ),
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
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("email", isEqualTo: userEmail ?? "")
                .snapshots(),
            builder: (context, snapshot) {
              final postDoc = snapshot.hasData ? snapshot.data!.docs : [];
              final postNum = snapshot.hasData ? snapshot.data!.docs.length : 0;
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
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
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${postNumber ?? 0}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const Text(
                                      "Total Posts",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //user admin card

                        const SizedBox(
                          height: 50,
                        ),
                        // user post list
                        Text(
                          "RECENT POSTS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey[600]),
                        ),
                        if (postNum == 0)
                          Center(
                              child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_4,
                            title: 'No Post Yet',
                            subTitle: 'Please create new Post',
                            titleTextStyle: const TextStyle(
                              fontSize: 22,
                              color: Color(0xff9da9c7),
                              fontWeight: FontWeight.w500,
                            ),
                            subtitleTextStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xffabb8d6),
                            ),
                          )),

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
                                        child:
                                            const CircularProgressIndicator(),
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
}
