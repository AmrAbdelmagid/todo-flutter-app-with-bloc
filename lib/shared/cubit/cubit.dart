import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_flutter/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app_flutter/modules/done_tasks/done_tasks.dart';
import 'package:todo_app_flutter/modules/new_tasks/new_tasks.dart';
import 'package:todo_app_flutter/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentBottomNavBarIndex = 0;
  final List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  final List<String> appbarTitles = [
    'Tasks Screen',
    'Done Screen',
    'Archived Screen',
  ];
  bool isLoading = true;

  isLoadingFlag(bool flag) {
    isLoading = flag;
    emit(IsLoadingState());
  }

  setIndex(int index) {
    currentBottomNavBarIndex = index;
    emit(BottomNavBarState());
  }

  Database? database;
  var newTasks = [];
  var doneTasks = [];
  var archivedTasks = [];
  bool isBottomSheetOpen = false;

  isBottomSheetOpenFlag(bool flag) {
    isBottomSheetOpen = flag;
    emit(BottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          log('db created');
          //emit(OpenDatabaseState());
        }).catchError((err) {
          print('db creation error ${err.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        //  print('db opened');
        log('db opened');
      },
    ).then((value) {
      database = value;
      // emit(OpenDatabaseState());
    }).whenComplete(() {
      isLoadingFlag(false);
    });
  }

  Future insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    return await database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        emit(InsertToDatabaseState());
      });
    });
  }

  updateDatabase({required String status, required int id}) {
    database!
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then((value) {
          getDataFromDatabase(database);
          emit(UpdateDatabaseState());
    });
  }

  deleteTaskFromDatabase(int id,String status){
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    if (status == 'new'){
      newTasks.removeWhere((element) => id == element['id']);
    } else if (status == 'done'){
      doneTasks.removeWhere((element) => id == element['id']);
    } else {
      archivedTasks.removeWhere((element) => id == element['id']);
    }
    getDataFromDatabase(database);
    emit(DeleteTaskDatabaseState());
  }

  Future getDataFromDatabase(

      Database? database) async {
    return await database!.rawQuery('SELECT * FROM tasks').then((value) {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];
      value.forEach((element) {
        if (element['status'] == 'new'){
          newTasks.add(element);
        }else if (element['status'] == 'done'){
          doneTasks.add(element);
        }else {
          archivedTasks.add(element);
        }
      });

      // tasks = value;
      // log(tasks[0].toString());
      // log(tasks[1].toString());
      // log(tasks[2].toString());
      emit(GetFromDatabaseState());
    });
  }
}
