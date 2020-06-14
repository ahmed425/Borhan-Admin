import 'package:BorhanAdmin/providers/organizations_provider.dart';
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
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
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
    var donationsData = Provider.of<DonationRequests>(context);

    print("------------ requests list length is : " +
        donationsData.donationRequests.length.toString());
    setState(() {
      opacityLevel = 1.0;
    });

    return Container(
      color: Colors.teal[100],
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : donationsData.donationRequests.length != 0
              ? ListView.builder(
                  itemCount: donationsData.donationRequests.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      child: DonationRequestItem(
                        id: donationsData.donationRequests[index].id,
                        donatorName:
                            donationsData.donationRequests[index].donatorName,
                        donationDate:
                            donationsData.donationRequests[index].donationDate,
                        donationType:
                            donationsData.donationRequests[index].donationType,
                        donatorMobileNo: donationsData
                            .donationRequests[index].donatorMobileNo,
                        donationAmount: donationsData
                            .donationRequests[index].donationAmount,
                        donationItems:
                            donationsData.donationRequests[index].donationItems,
                        donatorAddress: donationsData
                            .donationRequests[index].donatorAddress,
                        orgName: donationsData.donationRequests[index].orgName,
                        actName: donationsData.donationRequests[index].actName,
                        availableOn:
                            donationsData.donationRequests[index].availableOn,
                        image: donationsData.donationRequests[index].image,
                        status: donationsData.donationRequests[index].status,
                        userId: donationsData.donationRequests[index].userId,
                        orgLocalId: widget.orgLocalId,
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  "لا يوجد تبرعات حالية",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
    );
  }
}
