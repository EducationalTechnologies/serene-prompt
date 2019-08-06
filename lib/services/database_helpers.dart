import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

    // database table and column names
    final String tableWords = 'implementationIntentions';
    final String columnId = '_id';
    final String columnGoal = 'goal';
    final String columnHindrance = 'hindrance';

    //TODO: Continue here https://pusher.com/tutorials/local-data-flutter