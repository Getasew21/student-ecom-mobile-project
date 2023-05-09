import "package:flutter/material.dart";

class CardDescription extends StatelessWidget {
  CardDescription(this.data, this.cardIcon, {Key? key}) : super(key: key);
  String data = "";
  IconData cardIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: Icon(
            cardIcon,
            color: Theme.of(context).primaryColor,
            size: 40,
          ),
        ),
        Text(data)
      ]),
    );
  }
}
