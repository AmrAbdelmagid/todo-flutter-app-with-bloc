import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/shared/components/task_item.dart';
import 'package:todo_app_flutter/shared/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/cubit/states.dart';

import 'no_tasks.dart';
// class ListsBlocConsumer extends StatelessWidget {
//   final List tasks;
//    ListsBlocConsumer(this.tasks);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit,AppStates>(
//       listener: (context,state) {} ,
//       builder: (context,state) {
//         return tasks.length == 0 ? NoTasks() :ListView.separated(
//             itemBuilder: (ctx, i) => TaskItem(tasks[i]),
//             separatorBuilder: (ctx, i) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Container(
//                 width: double.infinity,
//                 height: 1,
//                 color: Colors.grey[300],
//               ),
//             ),
//             itemCount: tasks.length);
//       },
//     );
//   }
// }

  Widget listsBlocConsumer (List tasks){
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {} ,
      builder: (context,state) {
        return tasks.length == 0 ? NoTasks() :ListView.separated(
            itemBuilder: (ctx, i) => TaskItem(tasks[i]),
            separatorBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length);
      },
    );
  }

