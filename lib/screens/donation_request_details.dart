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
        child: Center(
//          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("اسم المتبرع", style: TextStyle(fontSize: 20))),
                Text(currentRequest.donatorName,
                    style: TextStyle(fontSize: 20)),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Text("عنوان المتبرع", style: TextStyle(fontSize: 20))),
                Container(
                    child: Text(currentRequest.donatorAddress,
                        style: TextStyle(fontSize: 20))),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Text(" رقم الموبايل", style: TextStyle(fontSize: 20))),
                Text(currentRequest.donatorMobileNo,
                    style: TextStyle(fontSize: 20)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("الأشياء التي يرغب التبرع بها ",
                      style: TextStyle(fontSize: 20)),
                ),
                Text(currentRequest.donationItems,
                    style: TextStyle(fontSize: 20)),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("المواعيد المتاحة",
                        style: TextStyle(fontSize: 20))),
                Text(currentRequest.availableOn,
                    style: TextStyle(fontSize: 20)),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(" صورة للتبرع إن وجدت",
                        style: TextStyle(fontSize: 20))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: FittedBox(
//                        Image.network(_downloadUrl)
                        child: Image.network(currentRequest.image),
//                          fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
