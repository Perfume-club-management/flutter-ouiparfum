import 'package:flutter/cupertino.dart';

class User{
  final int id;
  final String email;
  final String name;
  final String username;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.profileImage,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}