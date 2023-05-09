import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bouncy_widget/bouncy_widget.dart';

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

  //login fuction
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    try {
      if (isValid) {
        _formKey.currentState?.save();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(66, 19, 19, 18),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    semanticsLabel: "Loadding",
                    strokeWidth: 7,
                    color: Color.fromARGB(255, 24, 135, 102),
                  ),
                ),
              ),
            );
          },
        );

        await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);

        Navigator.of(context).pop();

        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
      } //user authentication
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Text("No user found ,try sign up instead ")));
      } else if (e.code == "wrong-password") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Text("Please Enter the correct password")));
      }
    }
    print("validated");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    //logo

                    Bouncy(
                      duration: const Duration(milliseconds: 2000),
                      lift: 20,
                      ratio: 0.5,
                      pause: 0.5,
                      child: Image.asset(
                        'lib/images/Wollo-University-logo.png',
                        height: 150,
                      ),
                    ),

                    //welcome back
                    const SizedBox(
                      height: 50,
                    ),
                    Bouncy(
                        duration: const Duration(milliseconds: 2000),
                        lift: 20,
                        ratio: 0.5,
                        pause: 0.5,
                        child: const Text(
                          "Welcome back ",
                          style: TextStyle(fontSize: 20),
                        )),

                    // email text filed
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.5),
                      child: TextFormField(
                        key: const ValueKey("email"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please your email ";
                          } else if (!value.contains("@")) {
                            return "Your Email Format is Invalid";
                          }
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            )),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        onSaved: (value) => _userEmail = value!,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),

                    // password textfield
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please your password ";
                          } else if (value.length < 4) {
                            return "at least 4 character ";
                          }
                        },
                        key: const ValueKey("password"),
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            )),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        onSaved: (value) => _userPassword = value!,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // sing in button
                    InkWell(
                      onTap: _trySubmit,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    //not a member? regster Now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member?"),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/signup", (route) => false);
                            },
                            child: const Text("Regster now"))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
