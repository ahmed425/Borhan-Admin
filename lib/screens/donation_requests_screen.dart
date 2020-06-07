import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:intl/intl.dart';

import '../providers/donation_requests.dart';
import '../widgets/donation_request_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestsScreen extends StatefulWidget {
  final orgLocalId;

  DonationRequestsScreen({this.orgLocalId});

  @override
  _DonationRequestsScreenState createState() => _DonationRequestsScreenState();
}

class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
  var _isLoading = false;
  double opacityLevel = 0.0;

  var _isInit = true;
  String orgId = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
//      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print('from donation req screen id   '),
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
    setState(() {
      opacityLevel = 1.0;
    });

    final donationsData = Provider.of<DonationRequests>(context);
    print('from build in req donation' + donationsData.toString());
    return Container(
      color: Colors.teal[100],
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: donationsData.donationRequests.length,
              itemBuilder: (ctx, index) {
                return donationsData.donationRequests.length != 0
                    ? Container(
                        child: DonationRequestItem(
                          id: donationsData.donationRequests[index].id,
                          donatorName:
                              donationsData.donationRequests[index].donatorName,
                          donationDate: donationsData
                              .donationRequests[index].donationDate,
                          donationType: donationsData
                              .donationRequests[index].donationType,
                          donatorMobileNo: donationsData
                              .donationRequests[index].donatorMobileNo,
                          donationAmount: donationsData
                              .donationRequests[index].donationAmount,
                          donationItems: donationsData
                              .donationRequests[index].donationItems,
                          donatorAddress: donationsData
                              .donationRequests[index].donatorAddress,
                          orgName:
                              donationsData.donationRequests[index].orgName,
                          actName:
                              donationsData.donationRequests[index].actName,
                          availableOn:
                              donationsData.donationRequests[index].availableOn,
                          image: donationsData.donationRequests[index].image,
                          status: donationsData.donationRequests[index].status,
                          userId: donationsData.donationRequests[index].userId,
                          orgLocalId: widget.orgLocalId,
                        ),
                      )
                    : Container();
              },
            ),
    );
  }
}
