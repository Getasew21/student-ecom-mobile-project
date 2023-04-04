import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  Post(this.imageUrl, this.title, this.price, this.email);
  String imageUrl = "", title = "", price = "", email = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.network(
                imageUrl,
                height: 160,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30),
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "SHARE",
                          style: TextStyle(color: Colors.amber),
                        ),
                        onPressed: () {},
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "EXPLORE",
                          style: TextStyle(color: Colors.amber),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),
          ],
        ),
      ),
    );
  }
}
