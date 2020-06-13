import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activities.dart';
import './add_activity.dart';
import '../widgets/activity_item.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = '/activities';

  final orgLocalId;
  ActivityScreen({this.orgLocalId});

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
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
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
          : Container(
              color: Colors.teal[100],
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: activitiesData.items.length,
                itemBuilder: (_, i) => ActivityItem(
                    name: activitiesData.items[i].activityName,
                    id: activitiesData.items[i].id,
                    image: activitiesData.items[i].imagesUrl,
                    orgLocalId: widget.orgLocalId),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddActivity(
                orgLocalId: widget.orgLocalId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
