import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/shared/components/lists_bloc_consumer.dart';
import 'package:todo_app_flutter/shared/components/no_tasks.dart';
import 'package:todo_app_flutter/shared/components/task_item.dart';
import 'package:todo_app_flutter/shared/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {} ,
      builder: (context,state) {
        return AppCubit.get(context).doneTasks.length == 0 ? NoTasks() :ListView.separated(
            itemBuilder: (ctx, i) => TaskItem(AppCubit.get(context).doneTasks[i]),
            separatorBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            itemCount: AppCubit.get(context).doneTasks.length);
      },
    );
  }
}
