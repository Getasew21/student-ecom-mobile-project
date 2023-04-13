import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studecom/screens/Home.dart';
import 'package:studecom/screens/SignUp.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    try {
      if (isValid) {
        _formKey.currentState?.save();
        await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        Navigator.pushNamed(context, "/home"); //user authentication
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 20000),
          content: Text(
            e.toString(),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('./assets/log4.jpg'), fit: BoxFit.cover)),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.black54,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            key: const ValueKey("email"),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return 'please enter a valid email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromARGB(255, 43, 255, 0))),
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: "email "),
                            onSaved: ((newValue) {
                              _userEmail = newValue!;
                            }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            key: const ValueKey("password"),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'please enter a valid password';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromARGB(255, 43, 255, 0))),
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: "password"),
                            onSaved: ((newValue) {
                              _userPassword = newValue!;
                            }),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                              onPressed: _trySubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 24, 136, 1), // Background color
                              ),
                              child: const Text("Sign In ")),
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: const Text(
                                  "Does not Have account? Create Account"))
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }
}
