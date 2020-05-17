import 'package:BorhanAdmin/screens/add_campaign.dart';
import 'package:flutter/material.dart';
import '../screens/add_activity.dart';
import 'package:provider/provider.dart';
import '../providers/campaigns.dart';

class CampaignItem extends StatelessWidget {
  final String name;
  final String id;

  CampaignItem(this.name, this.id);

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
                    AddCampaign.routeName,
                    arguments: id,
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<Campaigns>(context, listen: false)
                      .deleteCampaign(id);
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
        trailing: Text(name));
  }
}
