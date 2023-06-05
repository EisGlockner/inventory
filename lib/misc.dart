import 'package:flutter/material.dart';

double scrW(BuildContext context, num value) {
  return MediaQuery.of(context).size.width * value;
}

double scrH(BuildContext context, num value) {
  return MediaQuery.of(context).size.height * value;
}