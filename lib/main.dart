import 'dart:async';
import 'package:bloc_structure/my_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'data/tables/movie_table.dart';
import 'di/get_it.dart' as getIt;
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(MovieTableAdapter());
  unawaited(getIt.init());
  runApp(const MyMain());
}
