import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import '../screens/add_activity.dart';
import 'package:provider/provider.dart';
import '../providers/activities.dart';

class ActivityItem extends StatefulWidget {
  final String name;
  final String id;
  final String image;
  final orgLocalId ;

  ActivityItem({this.name, this.id, this.image, this.orgLocalId});

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  String orgId = '';
  var _isInit = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
//      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print(orgId),
              });
//      print('Image is : ${widget.image}');
      print('id is : ${widget.id}');
      print('OrgLocal from act item is : ${widget.orgLocalId}');
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddActivity(orgLocalId: widget.orgLocalId,actId: widget.id,)));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Activities>(context, listen: false)
                    .deleteActivity(widget.id, orgId);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),

      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(widget.image),
      ),
    );
  }
}
