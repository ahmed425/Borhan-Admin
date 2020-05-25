import 'package:BorhanAdmin/providers/donation_requests.dart';
import 'package:BorhanAdmin/screens/donation_request_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestItem extends StatelessWidget {
  final String donatorName;
  final String donatorMobileNo;
  final String donationType;
  final String donationDate;
  final String id;

  DonationRequestItem(this.id, this.donatorName, this.donatorMobileNo,
      this.donationType, this.donationDate);

  @override
  Widget build(BuildContext context) {
//    final scaffold = Scaffold.of(context);
    return ListTile(
      onTap: () => selectRequest(context),
      title: Container(
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
//                margin: EdgeInsets.symmetric(
//                  vertical: 10,
//                  horizontal: 15,

//                decoration: BoxDecoration(
//                  border: Border.all(
//                    color: Colors.purple,
//                    width: 2,
//                  ),
//                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  "$donationType",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
//                    color: Colors.purple,
                    color: Theme.of(context).primaryColor,
//                    textColor:
//                    Theme.of(context).primaryTextTheme.button.color,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                    child: Text(donatorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple,
                        )),
                  ),
                  Text(
                    donationDate,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  width: 100,
                  child: RaisedButton(
                    onPressed: () {
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donationDate);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donationType);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donationItems);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donationAmount);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donatorAddress);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donatorMobileNo);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .donatorName);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .id);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .image);
                      print(Provider.of<DonationRequests>(context)
                          .findById(id)
                          .availableOn);

                      Provider.of<DonationRequests>(context).addCampaign(
                          Provider.of<DonationRequests>(context).findById(id));

                      Provider.of<DonationRequests>(context).deleteRequest(id);
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
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectRequest(BuildContext context) {
    Navigator.of(context).pushNamed(
      DonationRequestDetailsScreen.routeName,
      arguments: id,
    );
  }
}

//
//SizedBox(
//width: 100,
//child: RaisedButton(
//onPressed: () {
//print(Provider.of<DonationRequests>(context).findById(id).donationDate);
//print(Provider.of<DonationRequests>(context).findById(id).donationType);
//print(Provider.of<DonationRequests>(context).findById(id).donationItems);
//print(Provider.of<DonationRequests>(context).findById(id).donationAmount);
//print(Provider.of<DonationRequests>(context).findById(id).donatorAddress);
//print(Provider.of<DonationRequests>(context).findById(id).donatorMobileNo);
//print(Provider.of<DonationRequests>(context).findById(id).donatorName);
//print(Provider.of<DonationRequests>(context).findById(id).id);
//print(Provider.of<DonationRequests>(context).findById(id).image);
//print(Provider.of<DonationRequests>(context).findById(id).availableOn);
//
//Provider.of<DonationRequests>(context)
//    .addCampaign(Provider.of<DonationRequests>(context).findById(id));
//},
//child: Text(
//'نقل للتبرعات السابقة  ',
//style: TextStyle(
//color: Colors.white,
//fontSize: 15.0,
//fontWeight: FontWeight.bold),
//),
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(10),
//),
//color: Theme.of(context).primaryColor,
//textColor:
//Theme.of(context).primaryTextTheme.button.color,
//),
//),

//import 'package:BorhanAdmin/providers/donation_requests.dart';
//import 'package:BorhanAdmin/screens/donation_request_details.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//class DonationRequestItem extends StatelessWidget {
////    final String donatorName;
////  final String donatorMobileNo;
////  final String donationType;
////  final String donationDate;
////  final String id;
////  final String donationItems;
////  final String donationAmount;
////  final String donatorAddress;
////  final String availableOn;
////  final String image;
////
////  DonationRequestItem(
////      this.id,
////      this.donationType,
////      this.donatorName,
////      this.donatorMobileNo,
////      this.donatorAddress,
////      this.donationItems,
////      this.donationAmount,
////      this.donationDate,
////      this.availableOn,
////      this.image);
//  final String donatorName;
//  final String donatorMobileNo;
//  final String donationType;
//  final String donationDate;
//  final String id;
//
//  DonationRequestItem(this.id, this.donatorName, this.donatorMobileNo,
//      this.donationType, this.donationDate);
//
//  @override
//  Widget build(BuildContext context) {
////    final scaffold = Scaffold.of(context);
//    return ListTile(
//      onTap: () => selectRequest(context),
//      title: Container(
//        child: Card(
//          child: Row(
//            children: <Widget>[
//              Container(
////                margin: EdgeInsets.symmetric(
////                  vertical: 10,
////                  horizontal: 15,
//
////                decoration: BoxDecoration(
////                  border: Border.all(
////                    color: Colors.purple,
////                    width: 2,
////                  ),
////                ),
//                padding: EdgeInsets.all(5),
//                child: Text(
//                  "$donationType",
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 20,
////                    color: Colors.purple,
//                    color: Theme.of(context).primaryColor,
////                    textColor:
////                    Theme.of(context).primaryTextTheme.button.color,
//                  ),
//                ),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                        color: Colors.purple,
//                        width: 2,
//                      ),
//                    ),
//                    child: Text(donatorName,
//                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20,
//                          color: Colors.purple,
//                        )),
//                  ),
//                  Text(
//                    donationDate ?? 'default value',
//                    style: TextStyle(
//                      color: Colors.grey,
//                    ),
//                  ),
//                ],
//              ),
//              Container(
//                margin: EdgeInsets.all(20),
//                child: SizedBox(
//                  width: 100,
//                  child: RaisedButton(
//                    onPressed: () {
//                      Provider.of<DonationRequests>(context).addCampaign(
//                          Provider.of<DonationRequests>(context).findById(id));
//                      print('Donation date is $donationDate');
//                      print(
//                          "Request is ${Provider.of<DonationRequests>(context).findById(id).donationType}");
//                      Provider.of<DonationRequests>(context).deleteRequest(id);
//                    },
//                    child: Text(
//                      'تم التبرع  ',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.bold),
//                    ),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                    color: Theme.of(context).primaryColor,
//                    textColor: Theme.of(context).primaryTextTheme.button.color,
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void selectRequest(BuildContext context) {
//    Navigator.of(context).pushNamed(
//      DonationRequestDetailsScreen.routeName,
//      arguments: id,
//    );
//  }
//}

//Previous
//import 'package:BorhanAdmin/models/donation_request.dart';
//import 'package:BorhanAdmin/providers/donation_requests.dart';
//import 'package:BorhanAdmin/screens/donation_request_details.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//class DonationRequestItem extends StatelessWidget {
//  final String donatorName;
//  final String donatorMobileNo;
//  final String donationType;
//  final String donationDate;
//  final String id;
//  final String donationItems;
//  final String donationAmount;
//  final String donatorAddress;
//  final String availableOn;
//  final String image;
//
//  DonationRequestItem(
//      this.id,
//      this.donationType,
//      this.donatorName,
//      this.donatorMobileNo,
//      this.donatorAddress,
//      this.donationItems,
//      this.donationAmount,
//      this.donationDate,
//      this.availableOn,
//      this.image);
//
////final request = DonationRequestItem()
//  @override
//  Widget build(BuildContext context) {
////    final scaffold = Scaffold.of(context);
//    final donationRequestsData = Provider.of<DonationRequests>(context);
//
//    return ListTile(
//      onTap: () => selectRequest(context),
//      title: Container(
//        child: Card(
//          child: Row(
//            children: <Widget>[
//              Container(
////                margin: EdgeInsets.symmetric(
////                  vertical: 10,
////                  horizontal: 15,
//
////                decoration: BoxDecoration(
////                  border: Border.all(
////                    color: Colors.purple,
////                    width: 2,
////                  ),
////                ),
//                padding: EdgeInsets.all(5),
//                child: Text(
//                  "$donationType",
//                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 20,
////                    color: Colors.purple,
//                    color: Theme.of(context).primaryColor,
////                    textColor:
////                    Theme.of(context).primaryTextTheme.button.color,
//                  ),
//                ),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                        color: Colors.purple,
//                        width: 2,
//                      ),
//                    ),
//                    child: Text(donatorName,
//                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20,
//                          color: Colors.purple,
//                        )),
//                  ),
//                  Text(
//                    donationDate,
//                    style: TextStyle(
//                      color: Colors.grey,
//                    ),
//                  ),
//                ],
//              ),
//              Container(
//                margin: EdgeInsets.all(20),
//                child: SizedBox(
//                  width: 100,
//                  child: RaisedButton(
//                    onPressed: () {
//                      Provider.of<DonationRequests>(context)
//                          .addCampaign(DonationRequest(
////                              id: this.id,
//                              availableOn: this.availableOn,
//                              image: this.image,
//                              donatorName: this.donatorName,
//                              donationItems: this.donationItems,
//                              donationAmount: this.donationAmount,
//                              donatorMobileNo: this.donatorMobileNo,
//                              donationDate: this.donationDate,
//                              donatorAddress: this.donatorAddress,
//                              donationType: this.donationType));
//                      Provider.of<DonationRequests>(context)
//                          .deleteRequest(this.id);
//                    },
//                    child: Text(
//                      'تم التبرع  ',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.bold),
//                    ),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                    color: Theme.of(context).primaryColor,
//                    textColor: Theme.of(context).primaryTextTheme.button.color,
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void selectRequest(BuildContext context) {
//    Navigator.of(context).pushNamed(
//      DonationRequestDetailsScreen.routeName,
//      arguments: id,
//    );
//  }
//}
