import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/screens/add_campaign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/campaigns.dart';
import 'dart:io' show Platform;

class CampaignItem extends StatefulWidget {
  final String name;
  final String id;
  final String image;
  final orgLocalId;

  CampaignItem(this.name, this.id, this.image, this.orgLocalId);

  @override
  _CampaignItemState createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {
  String orgId = '';
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print(orgId),
              });
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
                      builder: (context) => AddCampaign(
                        orgLocalId: widget.orgLocalId,
                        campId: widget.id,
                      ),
                    ));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDialog();
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
      leading: widget.image != null
          ? CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.image),
            )
          : Container(),
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: Text('حذف نشاط'),
              content: Text('هل تريد حذف النشاط؟'),
              actions: <Widget>[
                FlatButton(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'نعم',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Campaigns>(context, listen: false)
                        .deleteAdminCampaign(widget.id, orgId);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text('حذف نشاط'),
              content: Text('هل تريد حذف النشاط؟'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'نعم',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Campaigns>(context, listen: false)
                        .deleteAdminCampaign(widget.id, orgId);
                    Navigator.of(ctx).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('الغاء'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
    );
  }
}
