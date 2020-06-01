import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryItem extends StatelessWidget {
  String donationAmount;
  String donationDate;
  String donationItems;
  String donatorAddress;
  String donatorMobile;
  String donatorName;
  String actName;
  String status;

  HistoryItem({
    this.donationAmount,
    this.donationItems,
    this.donationDate,
    this.donatorAddress,
    this.donatorMobile,
    this.donatorName,
    this.actName,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donatorName != '' && donatorName != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        'اسم المتبرع : ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donatorName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donatorMobile != '' && donatorMobile != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        'رقم الهاتف المحمول:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donatorMobile,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donatorAddress != '' && donatorAddress != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        ' العنوان:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donatorAddress,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donationDate != '' && donationDate != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        'التاريخ :',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donationDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donationItems != '' && donationItems != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        ' وصف التبرع :',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donationItems,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: actName != '' && actName != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        'اسم النشاط:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        actName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            child: donationAmount != '' && donationAmount != null
                ? Row(
//                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        'المبلغ:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donationAmount,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: status != '' && status != null ?
                status == 'done'?
                Material(
                  child: Text('تبرع مقبول',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ):Material(
                  child: Text('تبرع مرفوض',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ) : Container(),
          ),
        ),
      ],
    );
  }
}
