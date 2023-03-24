import 'package:Movie_Night/src/pages/UI/Tvshow_page.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:flutter/material.dart';

class Typeswitch extends StatefulWidget {
  const Typeswitch({super.key});

  @override
  State<Typeswitch> createState() => _TypeswitchState();
}

class _TypeswitchState extends State<Typeswitch> {
  bool movie = true;
  bool tvshow = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                tvshow = true;
                movie = false;
              });
            },
            child: Text(
              "TV Shows",
              style: TextStyle(
                  color: tvshow ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text("   |   ",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              setState(() {
                movie = true;
                tvshow = false;
              });
            },
            child: Text("Movies",
                style: TextStyle(
                    fontSize: 18,
                    color: movie ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
