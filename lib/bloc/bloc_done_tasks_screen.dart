


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/bloc/tasks_cubit.dart';
import 'package:iti_project/reusable_component.dart';


class BlocDoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksStates>(listener: (context, state) {
    },
      builder: (context, state) {
       TasksCubit cubit =  TasksCubit.get(context);
        return tasksListView(cubit.doneTasks,cubit);
      },
    );
  }
}
