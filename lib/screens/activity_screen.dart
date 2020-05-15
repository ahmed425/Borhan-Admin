import 'package:flutter/material.dart';
import './add_activity.dart';
class ActivityScreen extends StatelessWidget {
  static const routeName = '/activities';

  final List<String> activities = ['كفالة اليتيم','اطعام','كساء'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأنشطة'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.lightBlueAccent,
            child: Center(child: Text('${activities[index]}')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddActivity(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
