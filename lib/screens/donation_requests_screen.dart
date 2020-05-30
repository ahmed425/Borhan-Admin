import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';

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
  String orgId = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgId = value.id,
                print(orgId),
                Provider.of<DonationRequests>(context)
                    .fetchAndSetProducts(orgId)
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
    final donationsData = Provider.of<DonationRequests>(context);
    print('from build in req donation' + donationsData.toString());
    return Container(
      color: Colors.teal[100],
//      decoration: BoxDecoration(
//        gradient: LinearGradient(
//          colors: [
//            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//          ],
//          begin: Alignment.topLeft,
//          end: Alignment.bottomRight,
//          stops: [0, 1],
//        ),
//      ),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return donationsData.donationRequests.length != 0
              ? Container(
                  child: DonationRequestItem(
                    id: donationsData.donationRequests[index].id,
                    donatorName:
                        donationsData.donationRequests[index].donatorName,
                    donationDate:
                        donationsData.donationRequests[index].donationDate,
                    donationType:
                        donationsData.donationRequests[index].donationType,
                    donatorMobileNo:
                        donationsData.donationRequests[index].donatorMobileNo,
                    donationAmount:
                        donationsData.donationRequests[index].donationAmount,
                    donationItems:
                        donationsData.donationRequests[index].donationItems,
                    donatorAddress:
                        donationsData.donationRequests[index].donatorAddress,
                    orgName: donationsData.donationRequests[index].orgName,
                    actName: donationsData.donationRequests[index].actName,
                    availableOn:
                        donationsData.donationRequests[index].availableOn,
                    image: donationsData.donationRequests[index].image,
                    status: donationsData.donationRequests[index].status,
                    userId: donationsData.donationRequests[index].userId,
                  ),
                )
              : Container();
        },
        itemCount: donationsData.donationRequests.length,
      ),
    );
  }
}
