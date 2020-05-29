import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import '../screens/add_activity.dart';
import 'package:provider/provider.dart';
import '../providers/activities.dart';

class ActivityItem extends StatefulWidget {
  final String name;
  final String id;

  ActivityItem(this.name, this.id);

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  String orgId = '';
  var _isInit = true;
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
  if(_isInit){
    final data = Provider.of<Auth>(context);
    Provider.of<Organizations>(context).fetchAndSetOrg(data.adminData.id).then((value) => {
      orgId = value.id,
      print(orgId),
    });
  }
  _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
//    final scaffold = Scaffold.of(context);
    return ListTile(
        title: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddActivity.routeName,
                    arguments: widget.id,
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                    Provider.of<Activities>(context, listen: false)
                        .deleteActivity(widget.id,orgId);
//                  } catch (error) {
//                    scaffold.showSnackBar(
//                      SnackBar(
//                        content: Text('فشل الحذف!', textAlign: TextAlign.center,),
//                      ),
//                    );
//                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
        trailing: Text(widget.name));
  }
}
