import 'package:flutter/material.dart';

class NoTasks extends StatelessWidget {
  const NoTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 200,color: Colors.black26,),
          Text('Start Adding Tasks!',style: TextStyle(fontSize: 25.0,color: Colors.black38,fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }
}
