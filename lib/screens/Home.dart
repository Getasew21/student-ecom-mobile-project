import "package:cloud_firestore/cloud_firestore.dart";
import 'package:google_nav_bar/google_nav_bar.dart';
import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:studecom/screens/PostCreate.dart";
import "package:studecom/screens/Posts.dart";
import "package:studecom/screens/Profile.dart";

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String useremail = FirebaseAuth.instance.currentUser!.email.toString();

  late bool isadmin;

  final _pageController = PageController(initialPage: 0);

  final List<Widget> bottomBarPages = [
    const Posts(),
    const PostCreate(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    var iswaiting = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: useremail)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var isAdmin = querySnapshot.docs.first.get('isadmin');
        setState(() {
          isadmin = isAdmin;
        });
      } else {
        print('No user found with email $useremail');
      }
    });

    return Scaffold(
      bottomNavigationBar: GNav(
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade500,
          gap: 10,
          padding: const EdgeInsets.all(10),
          onTabChange: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.decelerate,
            );
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.add,
              text: 'Create',
            ),
            GButton(
              icon: Icons.manage_accounts,
              text: 'Profile',
            )
          ]),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      backgroundColor: const Color.fromARGB(255, 190, 190, 190),
    );
  }
}
