import 'package:flutter/material.dart';

Widget buildAvatar(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl));
  } else {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.transparent,
      child: Icon(Icons.account_circle, size: 100, color: Colors.grey),
    );
  }
}
