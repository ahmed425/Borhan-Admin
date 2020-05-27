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
  String orgId = '-M7mQM4joEI2tdd06ykQ';
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Campaigns>(context).fetchAndSetProducts(orgId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

//  in body : _isLoading? Center(child:CircularProgressIndicator(),) :
  @override
  Widget build(BuildContext context) {
    final campaignsData = Provider.of<Campaigns>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحملات'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: campaignsData.campaigns.length,
              itemBuilder: (_, i) => CampaignItem(
                campaignsData.campaigns[i].campaignName,
                campaignsData.campaigns[i].id,
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
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
