import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/screens/add_campaign.dart';
import 'package:flutter/material.dart';
import '../screens/add_activity.dart';
import 'package:provider/provider.dart';
import '../providers/campaigns.dart';

class CampaignItem extends StatefulWidget {
  final String name;
  final String id;
  final String image;
  CampaignItem(this.name, this.id, this.image);

  @override
  _CampaignItemState createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {
  String orgId = '';
  var _isInit = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
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
//    final scaffold = Scaffold.of(context);
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
                Navigator.of(context).pushNamed(
                  AddCampaign.routeName,
                  arguments: widget.id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Campaigns>(context, listen: false)
                    .deleteCampaign(widget.id, orgId);
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
      leading: FittedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Image.network(widget.image),
          ),
        ),
      ),
    );
  }
}
