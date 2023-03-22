import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/dataAllDao.dart';
import 'mode/data_all.dart';

part 'appDatabase.g.dart';
//create: flutter packages pub run build_runner build
//clear: flutter packages pub run build_runner watch

//參考: https://www.jianshu.com/p/dbf5e2115fe5
@Database(version: 1, entities: [DataAll])
abstract class AppDatabase extends FloorDatabase {
  DataAllDao get dataAllDao;
}
