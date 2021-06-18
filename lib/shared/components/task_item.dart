import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/shared/cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  final task;
  TaskItem(this.task);

  @override
  Widget build(BuildContext context) {
    return Dismissible(key: ValueKey(key),
      onDismissed: (direction){
      AppCubit.get(context).deleteTaskFromDatabase(task['id'],task['status']);

      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(radius: 40.0,child: Text(task['time']),),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(task['date'],style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
            IconButton(onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'done', id: task['id']);
            }, icon: Icon(Icons.done_outline,color: Colors.green,)),
            IconButton(onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'archived', id: task['id']);
            }, icon: Icon(Icons.archive,color: Colors.black38,)),
          ],
        ),
      ),
    );
  }
}
