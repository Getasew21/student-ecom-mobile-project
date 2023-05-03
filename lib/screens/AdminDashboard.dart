// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  var isLoading = false;
  changePermision(String userId, bool isPermit) async {
    //loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 24, 135, 102),
          ),
        );
      },
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({'ispermit': !isPermit});

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green, content: Text("permition changed")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Admin Dashboard"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final userDoc = snapshot.data!.docs;

            return ListView.builder(
              itemCount: userDoc.length,
              itemBuilder: (context, index) {
                var isPermited = userDoc[index]['ispermit'];
                return SingleChildScrollView(
                  child: Center(
                      child: Card(
                    child: SwitchListTile(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(userDoc[index]['email']),
                      value: isPermited,
                      onChanged: (bool value) {
                        changePermision(userDoc[index].id, isPermited);
                      },
                    ),
                  )),
                );
              },
            );
          },
        ));
  }
}
