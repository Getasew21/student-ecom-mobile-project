import 'dart:io';

import 'package:bouncy_widget/bouncy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isPermit = true;
  var db = FirebaseFirestore.instance;
  int postNumber = 0;
  // functions
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

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: StreamBuilder(
                  stream: uploadTask?.snapshotEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      double progress = data.bytesTransferred / data.totalBytes;
                      double percent = progress.round() * 100;
                      return Container(
                        height: 100,
                        width: 200,
                        color: Color.fromARGB(176, 0, 0, 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Uploading data...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${percent} %',
                              style: const TextStyle(
                                  color: Color.fromARGB(169, 255, 255, 255),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                          child: Container(
                        height: 100,
                        width: 200,
                        color: const Color.fromARGB(146, 0, 0, 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            LinearProgressIndicator(
                              minHeight: 10,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Loading File...",
                              style: TextStyle(
                                  color: Color.fromARGB(169, 255, 255, 255),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ));
                    }
                  }),
            );
          },
        );

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

        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"totalpost": FieldValue.increment(1)});

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("post complated")));
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text("Please choose photo"),
          )));
      return;
    }
  }

  void checkUserStatus() async {
    var permission = await FirebaseFirestore.instance
        .collection("users")
        .where("ispermit", isEqualTo: true)
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    var postNum = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    if (mounted) {
      setState(() {
        isPermit = permission.docs.isNotEmpty;
        postNumber = postNum.docs.first["totalpost"];
      });
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
    checkUserStatus();
    print(postNumber);
    return Scaffold(
        body: Center(
            child: Container(
      alignment: Alignment.center,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            postNumber < 1 || isPermit
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            image != null
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 18),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: 200,
                                                width: 260,
                                                child: Image.file(
                                                  image!,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ))
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: FloatingActionButton(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              setState(() {
                                                image = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.close,
                                            ),
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
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: getImageCamera,
                                    child:
                                        const Icon(Icons.add_a_photo_outlined)),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: getImageGallery,
                                    child: const Icon(Icons.photo)),
                              ],
                            ),

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
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: "item name",
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(99, 1, 108, 112),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
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
                                        color: Color.fromARGB(255, 1, 99, 97),
                                        width: 1),
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
                                  return 'please valid price';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "price",
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(99, 1, 108, 112),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
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
                                if (value.length < 10) {
                                  return 'at least 10 character';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "description",
                                filled: true,
                                fillColor: Color.fromARGB(99, 1, 108, 112),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
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
                              key: const ValueKey("@telegrame username"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a tlegram address';
                                }
                                if (!value.startsWith("@")) {
                                  return "telegram address start with @ ";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "@telegram username",
                                filled: true,
                                fillColor: Color.fromARGB(99, 1, 108, 112),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
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
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a phone number';
                                }
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                hintText: "phone",
                                filled: true,
                                fillColor: Color.fromARGB(99, 1, 108, 112),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
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
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                onPressed: _trySubmit,
                                child: const Text("Add Post"))
                          ],
                        )),
                  )
                : Column(
                    children: [
                      Bouncy(
                          ratio: 0.5,
                          lift: 30,
                          child: const Icon(
                            Icons.question_mark_outlined,
                            size: 50,
                          )),
                      const Text("You Have Already Created One Post "),
                      const Text("To access this page you must Buy Package"),
                      const Text("Get package for 100 BIRR"),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text("Please Contact Us "),
                      const SizedBox(
                        height: 10,
                      ),

                      //contact us
                      Column(
                        children: [
                          //contact us with email
                          InkWell(
                            onTap: () {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'getasewadane9@gmail.com',
                              );

                              launchUrl(emailLaunchUri);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(255, 3, 88, 74),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.email),
                                  Center(
                                    child: Text(
                                      "With Email",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 3, 88, 74),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // with phone number
                          InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: "+251945557122",
                              );
                              await launchUrl(launchUri);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(255, 3, 88, 74),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.phone),
                                  Center(
                                    child: Text(
                                      "With Phone",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 3, 88, 74),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // with phone telegrame
                          InkWell(
                            onTap: () async {
                              await launch(
                                "https://t.me/Gechoadane",
                                forceSafariVC: false,
                                forceWebView: false,
                                headers: <String, String>{
                                  'my_header_key': 'my_header_value'
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(255, 3, 88, 74),
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.telegram),
                                  Center(
                                    child: Text(
                                      "With Phone",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 3, 88, 74),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
          ],
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
