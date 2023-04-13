import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:studecom/screens/PostCreate.dart";
import "package:studecom/screens/Posts.dart";
import "package:studecom/screens/Profile.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String useremail = FirebaseAuth.instance.currentUser!.email.toString();
  final _pageController = PageController(initialPage: 0);
  final List<Widget> bottomBarPages = [
    const Posts(),
    const PostCreate(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.linear,
        height: 50,
        backgroundColor: Theme.of(context).primaryColor,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          Icon(
            Icons.manage_accounts,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          //Handle button tap
        },
      ),
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
