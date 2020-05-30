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
    var myRequests =
        Provider.of<DonationRequests>(context, listen: false).donationRequests;
    var myProvider = Provider.of<DonationRequests>(context, listen: false);

    final requestId = ModalRoute.of(context).settings.arguments as String;
    var currentRequest = Provider.of<DonationRequests>(context, listen: false)
        .findById(requestId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentRequest.donationType}'),
      ),
      body: Container(
        color: Colors.teal[100],
        padding: EdgeInsets.all(10),
        child:
//          padding: const EdgeInsets.all(16.0),
            SingleChildScrollView(
          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("اسم النشاط",
                      style: TextStyle(
                        fontSize: 20,
                      ))),
//              SizedBox(child: Text('Hello'),,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(currentRequest.actName,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("اسم المتبرع", style: TextStyle(fontSize: 20))),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(currentRequest.donatorName,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("عنوان المتبرع",
                      style: TextStyle(
                        fontSize: 20,
                      ))),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Text(currentRequest.donatorAddress,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text(" رقم الموبايل", style: TextStyle(fontSize: 20))),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(currentRequest.donatorMobileNo,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text("الأشياء التي يرغب التبرع بها ",
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(currentRequest.donationItems,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("المواعيد المتاحة",
                      style: TextStyle(
                        fontSize: 20,
                      ))),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(currentRequest.availableOn,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    " صورة للتبرع إن وجدت",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
//                    padding: EdgeInsets.all(10),
//                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height,
//                    margin: EdgeInsets.all(8),

//                        Image.network(_downloadUrl)

                    child: SizedBox(
//                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl: currentRequest.image,
                      ),
                    ),
//                          fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
