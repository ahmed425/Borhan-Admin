import 'package:BorhanAdmin/models/donation_request.dart';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/donation_requests.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/screens/donation_request_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestItem extends StatefulWidget {
  final String id;
  final String donationType;
  final String donatorName;
  final String donatorMobileNo;
  final String donatorAddress;
  final String donationItems;
  final String donationAmount;
  final String donationDate;
  final String availableOn;
  final String image;
  final String orgName;
  final String actName;
  final String userId;
  final String status;

  DonationRequestItem({
    this.id,
    this.donationType,
    this.donatorName,
    this.donatorMobileNo,
    this.donatorAddress,
    this.donationItems,
    this.donationAmount,
    this.donationDate,
    this.availableOn,
    this.image,
    this.orgName,
    this.actName,
    this.userId,
    this.status,
  });

  @override
  _DonationRequestItemState createState() => _DonationRequestItemState();
}

class _DonationRequestItemState extends State<DonationRequestItem> {
  String orgId = '';
  var _isInit = true;
  var _donationReq = DonationRequest(
    status: '',
    image: '',
    donationType: '',
    donationItems: '',
    donationDate: '',
    donationAmount: '',
    actName: '',
    orgName: '',
    id: '',
    userId: '',
    donatorName: '',
    donatorAddress: '',
    availableOn: '',
    donatorMobileNo: '',
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      _donationReq = DonationRequest(
        donatorMobileNo: widget.donatorMobileNo,
        availableOn: widget.availableOn,
        donatorAddress: widget.donatorAddress,
        donatorName: widget.donatorName,
        userId: widget.userId,
        id: widget.id,
        orgName: widget.orgName,
        actName: widget.actName,
        donationAmount: widget.donationAmount,
        donationDate: widget.donationDate,
        donationItems: widget.donationItems,
        donationType: widget.donationType,
        image: widget.image,
        status: widget.status,
      );
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () => selectRequest(context),
            title: Card(
              child: Material(
//                  color: Colors.teal,
                elevation: 2.0,
                borderRadius: BorderRadius.circular(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Text(
                      'عيني',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Expanded(
                      child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              widget.donatorName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            widget.donationDate,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  _donationReq = DonationRequest(
                                    donatorMobileNo: widget.donatorMobileNo,
                                    availableOn: widget.availableOn,
                                    donatorAddress: widget.donatorAddress,
                                    donatorName: widget.donatorName,
                                    userId: widget.userId,
                                    id: widget.id,
                                    orgName: widget.orgName,
                                    actName: widget.actName,
                                    donationAmount: widget.donationAmount,
                                    donationDate: widget.donationDate,
                                    donationItems: widget.donationItems,
                                    donationType: widget.donationType,
                                    image: widget.image,
                                    status: 'done',
                                  );
                                  Provider.of<DonationRequests>(context)
                                      .updateDonationReq(_donationReq, orgId)
                                      .then((value) => {
                                            print('from .then ' +
                                                orgId +
                                                '\n' +
                                                _donationReq.userId),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .updateInMyDonation(
                                                    _donationReq.userId,
                                                    _donationReq),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .addDonationReq(
                                                    Provider.of<DonationRequests>(
                                                            context)
                                                        .findById(widget.id),
                                                    orgId),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .deleteRequest(
                                                    widget.id, orgId),
                                          });
                                },
                                child: Text(
                                  '  تم التبرع ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  _donationReq = DonationRequest(
                                    donatorMobileNo: widget.donatorMobileNo,
                                    availableOn: widget.availableOn,
                                    donatorAddress: widget.donatorAddress,
                                    donatorName: widget.donatorName,
                                    userId: widget.userId,
                                    id: widget.id,
                                    orgName: widget.orgName,
                                    actName: widget.actName,
                                    donationAmount: widget.donationAmount,
                                    donationDate: widget.donationDate,
                                    donationItems: widget.donationItems,
                                    donationType: widget.donationType,
                                    image: widget.image,
                                    status: 'cancel',
                                  );
                                  Provider.of<DonationRequests>(context)
                                      .updateDonationReq(_donationReq, orgId)
                                      .then((value) => {
                                            print('from .then ' +
                                                orgId +
                                                '\n' +
                                                _donationReq.userId),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .updateInMyDonation(
                                                    _donationReq.userId,
                                                    _donationReq),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .addDonationReq(
                                                    Provider.of<DonationRequests>(
                                                            context)
                                                        .findById(widget.id),
                                                    orgId),
                                            Provider.of<DonationRequests>(
                                                    context)
                                                .deleteRequest(
                                                    widget.id, orgId),
                                          });
                                },
                                child: Text(
                                  '  إلغاء التبرع ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                              ),
                            ],
                          ),
                        ),
//                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectRequest(BuildContext context) {
    Navigator.of(context).pushNamed(
      DonationRequestDetailsScreen.routeName,
      arguments: widget.id,
    );
  }
}

/*
*                         Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FittedBox(
                                child: Text(
                                  "${widget.donationType}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
*/
