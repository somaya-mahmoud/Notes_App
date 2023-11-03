import 'package:flutter/material.dart';
import 'package:iti_project/bloc/tasks_cubit.dart';

Widget myTextFormField({
  required TextEditingController controller,
  TextInputType textInputType = TextInputType.text,
  required FormFieldValidator<String>? validator,
  bool passwordVisible = false,
  required IconData prefixIcon,
  Widget? suffixIcon,
  required String label,
  GestureTapCallback? onTap,
}) {
  return TextFormField(
    onTap: onTap,
    controller: controller,
    keyboardType: textInputType,
    obscureText: passwordVisible,
    validator: validator,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon),
  );
}

Widget tasksListView(List<Map<dynamic, dynamic>> list, TasksCubit cubit) {
  return ListView.builder(
    itemBuilder: (context, index) => Dismissible(
      key: Key(list[index]["id"].toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {}
        if (direction == DismissDirection.startToEnd) {}
        cubit.deleteTask(taskId: list[index]['id']);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${list[index]['title']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateTask(status: "done", taskId: list[index]["id"]);
                  },
                  icon: Icon(Icons.done),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateTask(
                        status: "archive", taskId: list[index]["id"]);
                  },
                  icon: Icon(Icons.archive),
                  color: Colors.blue,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "${list[index]['date']}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  "${list[index]['time']}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    itemCount: list.length,
  );
}
