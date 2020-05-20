import '../providers/donation_requests.dart';
import '../widgets/donation_request_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestsScreen extends StatefulWidget {
  @override
  _DonationRequestsScreenState createState() => _DonationRequestsScreenState();
}

class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DonationRequests>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesData = Provider.of<DonationRequests>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        ),
      ),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Container(
            child: DonationRequestItem(
                activitiesData.donationRequests[index].id,
                activitiesData.donationRequests[index].donatorName,
                activitiesData.donationRequests[index].donationDate,
                activitiesData.donationRequests[index].donationType,
                activitiesData.donationRequests[index].donatorMobileNo),
          );
        },
        itemCount: activitiesData.donationRequests.length,
      ),
    );
  }
}
