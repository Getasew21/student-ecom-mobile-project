import 'dart:io';

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
  var category = "Mobile";
  bool isLogin = true;
  var email = '';
  var title = '';
  var price = '';
  File? image;

  Future _trySubmit() async {
    setState(() {
      isLogin = false;
    });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("post_images/${Timestamp.now()}");
      final uploadtask = ref.putFile(image!);
      final snapshot = await uploadtask.whenComplete(() => {});
      final urlLink = await snapshot.ref.getDownloadURL();
      _formKey.currentState?.save();

      //print(await FirebaseMessaging.instance.getToken());
      await FirebaseFirestore.instance.collection("posts").add({
        "title": title,
        "category": category,
        "price": price,
        "image_url": urlLink,
        "email": _auth.currentUser!.email
      });
    }

    setState(() {
      isLogin = true;
    });
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
                                  child: ElevatedButton(
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
                            onPressed: getImageCamera,
                            child: const Icon(Icons.add_a_photo_outlined)),
                        ElevatedButton(
                            onPressed: getImageGallery,
                            child: const Icon(Icons.photo)),
                      ],
                    ),
                    TextFormField(
                      key: const ValueKey("title"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: "Item name"),
                      onSaved: ((newValue) {
                        title = newValue!;
                      }),
                    ),
                    DropdownButton(
                        isExpanded: true,
                        value: dropdownvalue,
                        alignment: AlignmentDirectional.centerStart,
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
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Price"),
                      onSaved: ((newValue) {
                        price = newValue!;
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: _trySubmit,
                        child: !isLogin
                            ? const CircularProgressIndicator(
                                backgroundColor: Colors.purple,
                              )
                            : const Text("Add Post")),
                  ],
                )),
          ),
        ),
      )),
    );
  }
}
