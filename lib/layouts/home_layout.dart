import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/shared/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _scaffoldContext;
    return BlocProvider(create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state) {},
        builder: (context,state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.appbarTitles[cubit.currentBottomNavBarIndex]),
            ),
            body: Builder(
              builder: (context) {
                _scaffoldContext = context;
                return cubit.isLoading ? Center(child: CircularProgressIndicator()) : cubit.screens[cubit.currentBottomNavBarIndex];
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetOpen) {
                  if (_formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text)
                        .then((value) {
                      cubit.getDataFromDatabase(cubit.database!).then((value) {
                        Navigator.of(context).pop();
                        titleController.clear();
                        timeController.clear();
                        dateController.clear();
                      });
                      cubit.isLoadingFlag(true);
                        cubit.isBottomSheetOpenFlag(false);

                    }).whenComplete(() {cubit.isLoadingFlag(false);});
                  }
                } else {
                  Scaffold.of(_scaffoldContext)
                      .showBottomSheet<void>(
                        (context) => Form(
                      key: _formKey,
                      child: Container(
                        height: 300,
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter a Title';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: timeController,
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Pick a Time';
                                }
                                return null;
                              },
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value == null) {
                                    return;
                                  }
                                  timeController.text =
                                      value.format(context).toString();
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Time',
                              ),
                            ),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Pick a date';
                                }
                                return null;
                              },
                              onTap: () async {
                                final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2500));
                                dateController.text =
                                    DateFormat.yMMMd().format(date!);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0)),
                    ),
                    elevation: 50.0,
                  )
                      .closed
                      .then((value) {
                    cubit.isBottomSheetOpenFlag(false);
                  });
                  cubit.isBottomSheetOpenFlag(true);
                }
              },
              child: cubit.isBottomSheetOpen ? Icon(Icons.add) : Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
              ],
              currentIndex: cubit.currentBottomNavBarIndex,
              onTap: (indexValue) {

                  cubit.setIndex(indexValue);

              },
            ),
          );
        },
      ),
    );
  }


}
