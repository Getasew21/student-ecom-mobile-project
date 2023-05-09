import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _userEmail = TextEditingController();

  void _trySubmit() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _userEmail.text.trim());
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Reset Link will be set to this email"),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.5),
              child: TextField(
                key: const ValueKey("email"),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 2,
                    )),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey[400])),
                controller: _userEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),
            MaterialButton(
              onPressed: _trySubmit,
              child: const Text("Reset"),
              color: Colors.deepPurple[200],
            )
          ],
        ),
      )),
    );
  }
}
