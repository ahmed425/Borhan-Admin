import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activities.dart';
import './add_activity.dart';
import '../widgets/activity_item.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = '/activities';

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String orgId = '';
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgId = value.id,
                print('from activity screen org id = ' + orgId),
                Provider.of<Activities>(context)
                    .fetchAndSetActivities(orgId)
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                }),
              });
      setState(() {
        _isLoading = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesData = Provider.of<Activities>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأنشطة'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: activitiesData.items.length,
              itemBuilder: (_, i) => ActivityItem(
                activitiesData.items[i].activityName,
                activitiesData.items[i].id,
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
