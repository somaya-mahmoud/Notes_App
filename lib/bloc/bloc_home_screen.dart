import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_project/bloc/tasks_cubit.dart';
import 'package:iti_project/reusable_component.dart';

class BlocHomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocProvider(
      create: (context) => TasksCubit(InitTasksState())..openMyDatabase(),
      child: BlocConsumer<TasksCubit, TasksStates>(listener: (context, state) {
        print(state);
        print(state is BottomNavigationChangeState);
        if (state is BottomSheetChangeState) {
        } else if (state is InsertTaskState) {
        } else if (state is DeleteTaskState) {}
      }, builder: (context, state) {
        TasksCubit cubit = TasksCubit.get(context);
        return Form(
          key: formKey,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.bottomNavigationIndex]),
            ),
            floatingActionButton: Visibility(
              visible: (cubit.bottomNavigationIndex == 0),
              child: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetExpanded) {
                    if (formKey.currentState!.validate()) {
                      String title = titleController.text;
                      String date = dateController.text;
                      String time = timeController.text;

                      cubit.insertTask(title: title, date: date, time: time);

                      cubit.isBottomSheetExpanded = false;
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) => buildBottomSheet())
                        .closed
                        .then((value) {
                      titleController.text = "";
                      dateController.text = "";
                      timeController.text = "";
                      cubit.changeBottomSheetState(false);
                    });

                    cubit.changeBottomSheetState(true);
                  }
                },
                child: cubit.isBottomSheetExpanded
                    ? Icon(Icons.add)
                    : Icon(Icons.edit),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              onTap: (value) {
                // print(value);
                cubit.changeBottomNavigationState(value);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: "Active"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_all), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archive"),
              ],
              currentIndex: cubit.bottomNavigationIndex,
            ),
            body: cubit.screens[cubit.bottomNavigationIndex],
          ),
        );
      }),
    );
  }

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          myTextFormField(
            controller: titleController,
            validator: (value) => validator(value!),
            prefixIcon: Icons.title,
            label: "Title",
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormField(
            controller: dateController,
            validator: (value) => validator(value!),
            prefixIcon: Icons.date_range,
            label: "Date",
            textInputType: TextInputType.none,
            onTap: () {
              print('Date tapped');
              if (dateController.text == "") {
                print('please enter the date');
              }
              _pickDateDialog();
            },
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormField(
            controller: timeController,
            validator: (value) => validator(value!),
            prefixIcon: Icons.timer_outlined,
            label: "Time",
            textInputType: TextInputType.none,
            onTap: () {
              print('Time tapped');
              if (timeController.text == "") {
                print('please enter the time');
              }
              _pickTimeDialog();
            },
          ),
        ],
      ),
    );
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "Required";
    }
    return null;
  }

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2000),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2025)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      print('date picker dialog');
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      print(pickedDate.toString().split(" ")[0]);
      dateController.text = pickedDate.toString().split(" ")[0];
    });

    print('end date picker dialog');
  }

  void _pickTimeDialog() async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
    );
    print('time picker');
    String realHour = (pickedTime!.hour > 12)
        ? "${pickedTime.hour - 12}:${pickedTime.minute} PM"
        : "${pickedTime.hour}:${pickedTime.minute} AM";

    String time = "${realHour}";
    timeController.text = time;
  }
}
