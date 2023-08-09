import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Note welcomeFromJson(String str) => Note.fromJson(json.decode(str));

String welcomeToJson(Note data) => json.encode(data.toJson());

class Note {
  final String title;
  final String body;

  Note({
    required this.title,
    required this.body,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json["title"],
        body: json["body"],
      );

  factory Note.fromStream(QueryDocumentSnapshot<Object?> json) => Note(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
