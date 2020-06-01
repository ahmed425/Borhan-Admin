import 'package:BorhanAdmin/models/organization.dart';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/providers/user_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/campaigns.dart';
import './add_campaign.dart';
import '../widgets/campaign_item.dart';

class CampaignScreen extends StatefulWidget {
  static const routeName = '/Campaigns';

  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  String orgId = '';
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    final data = Provider.of<Auth>(context);

    if (_isInit) {
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id).then((value) => {orgId = value.id,
                print(orgId),
                Provider.of<Campaigns>(context).fetchAndSetProducts(orgId).then((_) {
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

//  in body : _isLoading? Center(child:CircularProgressIndicator(),) :
  @override
  Widget build(BuildContext context) {
    final campaignsData = Provider.of<Campaigns>(context);
    print("from campagn " + campaignsData.campaigns.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحملات'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.teal[100],
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: campaignsData.campaigns.length,
                itemBuilder: (_, i) => CampaignItem(
                  campaignsData.campaigns[i].campaignName,
                  campaignsData.campaigns[i].id,
                  campaignsData.campaigns[i].imagesUrl,
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCampaign(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
