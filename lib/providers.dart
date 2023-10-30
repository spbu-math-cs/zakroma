import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/diet_day.dart';

// TODO: доделать

class DietList extends AsyncNotifier<List<Diet>> {
  @override
  List<Diet> build() => [];

  void add(
      {required String id, required String name, required List<DietDay> days}) {
    state.whenData((value) => value.add(Diet(id: id, name: name, days: days)));
  }

  void setName({required String id, required String newName}) {

  }

  void setDays({required String id, required List<DietDay> newDays}) {

  }

  void remove({required String id}) {
  }
}
