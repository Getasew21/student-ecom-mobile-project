import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class PostCreate extends StatefulWidget {
  const PostCreate({Key? key}) : super(key: key);

  @override
  _PostCreateState createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  var dropdownvalue = "Mobile";
  var items = ["Mobile", "Computer", "Books"];

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  UploadTask? uploadTask;
  var category = "Mobile";
  var email = '';
  var title = '';
  var price = '';
  var description = "";
  var telegramAdress = "";
  var phoneNumber = "";
  File? image;
  bool isPost = true;

  Future _trySubmit() async {
    setState(() {
      isPost = false;
    });
    if (image != null) {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("post_images/${Timestamp.now()}");
        setState(() {
          uploadTask = ref.putFile(image!);
        });
        final snapshot = await uploadTask!.whenComplete(() => {});
        final urlLink = await snapshot.ref.getDownloadURL();

        setState(() {
          uploadTask = null;
        });
        _formKey.currentState?.save();

        //print(await FirebaseMessaging.instance.getToken());
        await FirebaseFirestore.instance.collection("posts").add({
          "title": title,
          "category": category,
          "price": price,
          "image_url": urlLink,
          "description": description,
          "phone": phoneNumber,
          "telegram": telegramAdress,
          "email": _auth.currentUser!.email
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("post complated")));
      }

      setState(() {
        isPost = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: AlertDialog(
        actions: [Text("please choose or capture image")],
      )));
      setState(() {
        isPost = true;
      });
      return;
    }
  }

  void getImageCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);
    if (image == null) return;
    final imagetemp = File(image.path);
    setState(() {
      this.image = imagetemp;
    });
  }

  void getImageGallery() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (image == null) return;
    final imagetemp = File(image.path);
    setState(() {
      this.image = imagetemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      alignment: Alignment.center,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image != null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 300,
                                      width: 300,
                                      child: Image.file(
                                        image!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ))
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Text("choose photo"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: getImageCamera,
                          child: const Icon(Icons.add_a_photo_outlined)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: getImageGallery,
                          child: const Icon(Icons.photo)),
                    ],
                  ),
                  if (!isPost) buildProgess(),
                  const SizedBox(
                    height: 20,
                  ),
                  //item name ********************************************
                  TextFormField(
                    key: const ValueKey("title"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter item name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "item name",
                      filled: true,
                      fillColor: const Color.fromARGB(99, 1, 108, 112),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.redAccent),
                      ),
                    ),
                    onSaved: ((newValue) {
                      title = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //category ********************************************
                  DropdownButtonFormField(
                      isExpanded: true,
                      value: dropdownvalue,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 1, 99, 97), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 3, 140, 143),
                              width: 2),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(99, 1, 108, 112),
                      ),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (newValue) {
                        category = newValue!;
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  //price ********************************************
                  TextFormField(
                    key: const ValueKey("price"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter price';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "price",
                      filled: true,
                      fillColor: const Color.fromARGB(99, 1, 108, 112),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.redAccent),
                      ),
                    ),
                    onSaved: ((newValue) {
                      price = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //description ********************************************
                  TextFormField(
                    key: const ValueKey("description"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "description",
                      filled: true,
                      fillColor: const Color.fromARGB(99, 1, 108, 112),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.redAccent),
                      ),
                    ),
                    onSaved: ((newValue) {
                      description = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //tlegram address ********************************************
                  TextFormField(
                    key: const ValueKey("telegram address"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a tlegram address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "telegram address",
                      filled: true,
                      fillColor: const Color.fromARGB(99, 1, 108, 112),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.redAccent),
                      ),
                    ),
                    onSaved: ((newValue) {
                      telegramAdress = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //phone ********************************************
                  TextFormField(
                    key: const ValueKey("phone"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "phone",
                      filled: true,
                      fillColor: Color.fromARGB(99, 1, 108, 112),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.redAccent),
                      ),
                    ),
                    onSaved: ((newValue) {
                      phoneNumber = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: _trySubmit,
                      child: const Text("Add Post"))
                ],
              )),
        ),
      ),
    )));
  }

  Widget buildProgess() => StreamBuilder(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 20,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      });
}
