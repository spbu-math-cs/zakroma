import 'package:flutter/cupertino.dart';

class Group {
  final int id;
  final String hash;
  final String name;

  const Group({required this.id, required this.hash, required this.name});

  factory Group.fromJson(Map<String, dynamic> map) {
    switch (map) {
      case {
          'id': int id,
          'hash': String hash,
          'name': String name,
        }:
        return Group(id: id, hash: hash, name: name);
      case _:
        debugPrint('DEBUG: $map');
        throw UnimplementedError();
    }
  }
}
