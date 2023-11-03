import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/bloc/bloc_archive_tasks_screen.dart';
import 'package:iti_project/bloc/bloc_done_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'bloc_active_tasks_screen.dart';

class TasksStates {}

class InitTasksState extends TasksStates {}

class InsertTaskState extends TasksStates {}

class GetTasksState extends TasksStates {}

class BottomNavigationChangeState extends TasksStates {}

class BottomSheetChangeState extends TasksStates {}

class DeleteTaskState extends TasksStates {}

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit(initialState) : super(initialState);

  static TasksCubit get(context) => BlocProvider.of(context);
  int bottomNavigationIndex = 0;
  List<String> titles = ["Active", "Done", "Archive"];
  List<Widget> screens = [
    BlocActiveTasksScreen(),
    BlocDoneTasksScreen(),
    BlocArchiveTasksScreen(),
  ];

  bool isBottomSheetExpanded = false;

  void changeBottomNavigationState(int value) {
    bottomNavigationIndex = value;
    emit(BottomNavigationChangeState());
  }

  void changeBottomSheetState(bool value) {
    isBottomSheetExpanded = value;
    emit(BottomSheetChangeState());
  }

  late Database database;
  void openMyDatabase() async {
    database = await openDatabase(
      "tasksDatabase",
      version: 1,
      onCreate: (db, version) async {
        print('onCreate Run');
        await db.execute(
            "CREATE Table Tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)");
      },
      onOpen: (db) {
        print('onOpen Run');
        database = db;
        getTasks();
      },
    );
  }

  void insertTask({String? title, String? date, String? time}) async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "active")');
      print('RAW INSERT ID => $id');
      getTasks();
    });
  }

  List<Map> activeTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void getTasks() async {
    activeTasks =
        await database.rawQuery('SELECT * FROM Tasks WHERE status = "active"');
    doneTasks =
        await database.rawQuery('SELECT * FROM Tasks WHERE status = "done"');
    archiveTasks =
        await database.rawQuery('SELECT * FROM Tasks WHERE status = "archive"');
    emit(GetTasksState());
  }

  void deleteTask({int? taskId}) async {
    await database.rawDelete('DELETE FROM Tasks WHERE id = ?', [taskId]);
    emit(DeleteTaskState());
    getTasks();
  }

  void updateTask({String? status, int? taskId}) async {
    await database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', ['$status', taskId]);
    getTasks();
  }
}
