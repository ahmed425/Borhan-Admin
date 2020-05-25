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
          return activitiesData.donationRequests.length != 0
              ? Container(
                  child: DonationRequestItem(
                      activitiesData.donationRequests[index].id,
                      activitiesData.donationRequests[index].donatorName,
                      activitiesData.donationRequests[index].donationDate,
                      activitiesData.donationRequests[index].donationType,
                      activitiesData.donationRequests[index].donatorMobileNo),
                )
              : Container();
        },
        itemCount: activitiesData.donationRequests.length,
      ),
    );
  }
}

//import 'package:BorhanAdmin/models/donation_request.dart';
//
//import '../providers/donation_requests.dart';
////import '../widgets/donation_request_item.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//import 'donation_request_details.dart';
//
//class DonationRequestsScreen extends StatefulWidget {
//  @override
//  _DonationRequestsScreenState createState() => _DonationRequestsScreenState();
//}
//
//class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
//  var _isLoading = false;
//  var _isInit = true;
//
//  @override
//  void didChangeDependencies() {
//    if (_isInit) {
//      setState(() {
//        _isLoading = true;
//      });
//      Provider.of<DonationRequests>(context).fetchAndSetProducts().then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//      });
//    }
//    _isInit = false;
//    super.didChangeDependencies();
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    final Provider.of<DonationRequests>(context) = Provider.of<DonationRequests>(context);
//
//    return Container(
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
//      child: ListView.builder(
//        itemBuilder: (ctx, index) {
//          return Container(
//            child: ListTile(
//              onTap: () => Navigator.of(context).pushNamed(
//                DonationRequestDetailsScreen.routeName,
//                arguments: Provider.of<DonationRequests>(context).donationRequests[index].id,
//              ),
//              title: Container(
//                child: Card(
//                  child: Row(
//                    children: <Widget>[
//                      Container(
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
//                        padding: EdgeInsets.all(5),
//                        child: Text(
//                          '${Provider.of<DonationRequests>(context).donationRequests[index].donationType}',
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 20,
////                    color: Colors.purple,
//                            color: Theme.of(context).primaryColor,
////                    textColor:
////                    Theme.of(context).primaryTextTheme.button.color,
//                          ),
//                        ),
//                      ),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Container(
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                color: Colors.purple,
//                                width: 2,
//                              ),
//                            ),
//                            child: Text(
//                                '${Provider.of<DonationRequests>(context).donationRequests[index].donatorName}',
//                                style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 20,
//                                  color: Colors.purple,
//                                )),
//                          ),
//                          Text(
//                            '${Provider.of<DonationRequests>(context).donationRequests[index].donationDate}',
//                            style: TextStyle(
//                              color: Colors.grey,
//                            ),
//                          ),
//                        ],
//                      ),
//                      Container(
//                        margin: EdgeInsets.all(20),
//                        child: SizedBox(
//                          width: 100,
//                          child: RaisedButton(
//                            onPressed: () {
//                              Provider.of<DonationRequests>(context)
//                                  .addCampaign(DonationRequest(
//                                      id: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index].id,
//                                      availableOn: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index].availableOn,
//                                      image: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index].image,
//                                      donatorName: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index].donatorName,
//                                      donationItems: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index]
//                                          .donationItems,
//                                      donationAmount: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index]
//                                          .donationAmount,
//                                      donatorMobileNo: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index]
//                                          .donatorMobileNo,
//                                      donationDate: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index].donationDate,
//                                      donatorAddress: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index]
//                                          .donatorAddress,
//                                      donationType: Provider.of<DonationRequests>(context)
//                                          .donationRequests[index]
//                                          .donationType));
//                              Provider.of<DonationRequests>(context)
//                                  .deleteRequest(Provider.of<DonationRequests>(context)
//                                      .donationRequests[index].id);
//                            },
//                            child: Text(
//                              'تم التبرع  ',
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 15.0,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(10),
//                            ),
//                            color: Theme.of(context).primaryColor,
//                            textColor:
//                                Theme.of(context).primaryTextTheme.button.color,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          );
//        },
//        itemCount: Provider.of<DonationRequests>(context).donationRequests.length,
//      ),
//    );
////    );
//
////            DonationRequestItem(
////                Provider.of<DonationRequests>(context).donationRequests[index].id,
////                Provider.of<DonationRequests>(context).donationRequests[index].donationType,
////                Provider.of<DonationRequests>(context).donationRequests[index].donatorName,
////                Provider.of<DonationRequests>(context).donationRequests[index].donatorMobileNo,
////                Provider.of<DonationRequests>(context).donationRequests[index].donatorAddress,
////                Provider.of<DonationRequests>(context).donationRequests[index].donationItems,
////                Provider.of<DonationRequests>(context).donationRequests[index].donationAmount,
////                Provider.of<DonationRequests>(context).donationRequests[index].donationDate,
////                Provider.of<DonationRequests>(context).donationRequests[index].availableOn,
////                Provider.of<DonationRequests>(context).donationRequests[index].image),
////          );
////        },
////        itemCount: Provider.of<DonationRequests>(context).donationRequests.length,
////      ),
//  }
//
////  void selectRequest(BuildContext context) {
////
////  }
//}
