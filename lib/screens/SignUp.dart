import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studecom/screens/Signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState?.save();
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _userEmail, password: _userPassword); //user authentication
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authResult.user?.uid)
          .set({"username": _userName, "email": _userEmail});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey("email"),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return 'please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: "email address"),
                      onSaved: ((newValue) {
                        _userEmail = newValue!;
                      }),
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
                      onSaved: ((newValue) {
                        _userPassword = newValue!;
                      }),
                    ),
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "username"),
                      onSaved: ((newValue) {
                        _userName = newValue!;
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: _trySubmit, child: const Text("sign up")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signin()));
                        },
                        child: const Text(" I already have an account"))
                  ],
                )),
          ),
        ),
      )),
    );
  }
}
