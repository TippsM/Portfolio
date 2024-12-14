import 'package:flutter/material.dart';

Widget topContainer() {
  return Container(
      width: double.infinity,
      height: 180,
      padding: EdgeInsets.only(left: 16, bottom: 15, top: 20),
      color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          ),
          Spacer(),
          Text(
            'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Colors.grey,
            ),
          ),
        ],
      ));
}
