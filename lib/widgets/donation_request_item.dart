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
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  donationType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.purple,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    donatorName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    donationDate,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<DonationRequests>(context, listen: false)
                          .deleteRequest(id);
//                  } catch (error) {
//                    scaffold.showSnackBar(
//                      SnackBar(
//                        content: Text('فشل الحذف!', textAlign: TextAlign.center,),
//                      ),
//                    );
//                  }
                    },
                    color: Theme.of(context).errorColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

//            ],
//          ),
//        ),
//        trailing: Text(donatorName));
  }

  void selectRequest(BuildContext context) {
    Navigator.of(context).pushNamed(
      DonationRequestDetailsScreen.routeName,
      arguments: id,
    );
  }
}
