import 'package:flutter/material.dart';

var colors = {
  "red": Color(0xffDA4235),
  "grey": Color(0xff666666),
  "light-grey": Color(0xffF1F3F7),
  "white": Color(0xffFFFFFF),
  "black": Colors.black,
};

// var endpoint = 'http://hridaya.duckdns.org:8000';
var endpoint = 'http://192.168.1.7:8000';
var urlPOST = Uri.parse('$endpoint/api/v1/prediction');
