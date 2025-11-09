import 'dart:convert';

class UserScriptModel {
  final String id;
  final String name;
  final String matchPattern;
  final String css;
  final String js;

  UserScriptModel({
    required this.id,
    required this.name,
    required this.matchPattern,
    required this.css,
    required this.js,
  });

  factory UserScriptModel.fromStorage(String storage) {
    try {
      final map = jsonDecode(storage);
      return UserScriptModel(
        id: map['id'],
        name: map['name'],
        matchPattern: map['matchPattern'],
        css: map['css'],
        js: map['js'],
      );
    } catch (e) {
      // Return a default/empty model if decoding fails
      return UserScriptModel(
        id: '',
        name: 'Error',
        matchPattern: '',
        css: '',
        js: '',
      );
    }
  }

  String toStorage() {
    return jsonEncode({
      'id': id,
      'name': name,
      'matchPattern': matchPattern,
      'css': css,
      'js': js,
    });
  }
}
