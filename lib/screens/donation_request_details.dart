import 'package:cached_network_image/cached_network_image.dart';
import '../providers/donation_requests.dart';
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
    Provider.of<DonationRequests>(context, listen: false).donationRequests;
    final requestId = ModalRoute.of(context).settings.arguments as String;
    var currentRequest = Provider.of<DonationRequests>(context, listen: false)
        .findById(requestId);
    print('from details  amount =  ${currentRequest.donationAmount.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentRequest.donationType}'),
      ),
      body: Container(
        color: Colors.teal[100],
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              currentRequest.actName != null && currentRequest.actName != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "اسم النشاط",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Container(),
              currentRequest.actName != null && currentRequest.actName != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.actName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.donatorName != null &&
                      currentRequest.donatorName != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child:
                          Text("اسم المتبرع", style: TextStyle(fontSize: 20)))
                  : Container(),
              currentRequest.donatorName != null &&
                      currentRequest.donatorName != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.donatorName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.donatorAddress != null &&
                      currentRequest.donatorAddress != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text("عنوان المتبرع",
                          style: TextStyle(
                            fontSize: 20,
                          )))
                  : Container(),
              currentRequest.donatorAddress != null &&
                      currentRequest.donatorAddress != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(
                        currentRequest.donatorAddress,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              currentRequest.donatorMobileNo != null &&
                      currentRequest.donatorMobileNo != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child:
                          Text(" رقم الموبايل", style: TextStyle(fontSize: 20)))
                  : Container(),
              currentRequest.donatorMobileNo != null &&
                      currentRequest.donatorMobileNo != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.donatorMobileNo,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.donationAmount != null &&
                      currentRequest.donationAmount != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text("المبلغ",
                          style: TextStyle(
                            fontSize: 20,
                          )))
                  : Container(),
              currentRequest.donationAmount != null &&
                      currentRequest.donationAmount != ""
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.donationAmount,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.donationItems != null &&
                      currentRequest.donationItems != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text("الأشياء التي يرغب التبرع بها ",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    )
                  : Container(),
              currentRequest.donationItems != null &&
                      currentRequest.donationItems != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.donationItems,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.availableOn != null &&
                      currentRequest.availableOn != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text("المواعيد المتاحة",
                          style: TextStyle(
                            fontSize: 20,
                          )))
                  : Container(),
              currentRequest.availableOn != null &&
                      currentRequest.availableOn != ''
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(currentRequest.availableOn,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              currentRequest.image != null && currentRequest.image != ''
                  ? Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        " صورة للتبرع إن وجدت",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                  : Container(),
              currentRequest.image != null && currentRequest.image != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: currentRequest.image,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
