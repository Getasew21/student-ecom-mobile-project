import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studecom/screens/Signin.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 50,
      ),
      const Text("profile"),
      ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signin()));
          },
          child: const Text("Sign out"))
    ]);
  }
}
