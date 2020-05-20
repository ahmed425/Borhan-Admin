import 'package:BorhanAdmin/providers/donation_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestDetailsScreen extends StatefulWidget {
  static const routeName = '/request-details';

  @override
  _DonationRequestDetailsScreenState createState() =>
      _DonationRequestDetailsScreenState();
}

class _DonationRequestDetailsScreenState
    extends State<DonationRequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var myRequests =
        Provider.of<DonationRequests>(context, listen: false).donationRequests;
    var myProvider = Provider.of<DonationRequests>(context, listen: false);
    //         .then((val) {
//       _downloadUrl = val;
//       setState(() {
//         _isLoadImg = false;
//       });
//       print("value from upload" + _downloadUrl);
//     });
    final requestId = ModalRoute.of(context).settings.arguments as String;
    var currentRequest = Provider.of<DonationRequests>(context, listen: false)
        .findById(requestId);
    return Scaffold(
      appBar: AppBar(
        title: Text('$requestId'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("اسم المتبرع"),
              Text(currentRequest.donatorName),
            ],
          ),
          Row(
            children: <Widget>[
              Text("رقم الموبايل"),
              Text(currentRequest.donatorAddress),
            ],
          ),
          Row(
            children: <Widget>[
              Text("العنوان "),
              Text(currentRequest.donatorName),
            ],
          ),
          Row(
            children: <Widget>[
              Text(" المواعيد المتاحة"),
              Text(currentRequest.donatorName),
            ],
          ),
          Row(
            children: <Widget>[
              Text("الأشياء التي يرغب التبرع بها "),
              Text(currentRequest.donatorName),
            ],
          ),
          Row(
            children: <Widget>[
              Text("صورة للتبرع إن وجدت "),
              Text(currentRequest.donatorName),
            ],
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                //post request to donation history requests
                //delete from the current donationrequests collection
                onPressed: () {
                  Provider.of<DonationRequests>(context, listen: false)
                      .deleteRequest(requestId)
                      .then((val) {
                    Navigator.pop(context);
//    print("value from upload" + _downloadUrl);
                  });
                },

//                  Provider.of<DonationRequests>(context, listen: false)
//                      .addCampaign(currentRequest)
//                      .then((value) => Navigator.pop(context));
//
                child: Text("تم التبرع "),
              )
            ],
          ),
        ],
      ),
//      body: Center(
//        child: Text(Provider.of<DonationRequests>(context, listen: false)
//            .findById(requestId)
//            .id),
//      ),
    );
  }
}
