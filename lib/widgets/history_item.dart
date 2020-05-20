import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryItem extends StatelessWidget {
  String donationAmount;
  String donationDate;
  String donationItems;
  String donationType;
  String donatorAddress;
  String donatorMobile;
  String donatorName;

  HistoryItem({
    this.donationAmount,
    this.donationType,
    this.donationItems,
    this.donationDate,
    this.donatorAddress,
    this.donatorMobile,
    this.donatorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(

              child: donatorName != '' && donatorName != null
                  ? Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Text(' : اسم المتبرع',style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),),
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
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : رقم التليفون',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),),
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
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : العنوان',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),),
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
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : التاريخ',
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
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : وصف التبرع',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),),
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

            child: donationType != '' && donationType != null
                ? Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : نوع التبرع',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),),
                Text(
                  donationType,
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
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Text(' : المبلغ',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),),
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
      ],
    );

    /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////
//    return Card(
//      clipBehavior: Clip.antiAlias,
//      child: Column(
//        children: <Widget>[
//          donatorName != '' && donatorName != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : اسم المتبرع'),
//                    Text(donatorName),
//                  ],
//                )
//              : Container(),
//          donatorMobile != '' && donatorMobile != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : رقم التليفون'),
//                    Text(donatorMobile),
//                  ],
//                )
//              : Container(),
//          donatorAddress != '' && donatorAddress != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : العنوان'),
//                    Text(donatorAddress),
//                  ],
//                )
//              : Container(),
//          donationDate != '' && donationDate != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : تاريخ التبرع'),
//                    Text(donationDate),
//                  ],
//                )
//              : Container(),
//          donationItems != '' && donationItems != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : وصف التبرع'),
//                    Text(donationItems),
//                  ],
//                )
//              : Container(),
//          donationType != '' && donationType != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : نوع التبرع'),
//                    Text(donationType),
//                  ],
//                )
//              : Container(),
//          donationAmount != '' && donationAmount != null
//              ? Row(
//                  textDirection: TextDirection.rtl,
//                  children: <Widget>[
//                    Text(' : المبلغ'),
//                    Text(donationAmount),
//                  ],
//                )
//              : Container(),
//          donationImage != '' && donationImage != null
//              ? Image.network(donationImage)
//              : Container(),
//        ],
//      ),
//    );

  ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////

//    return ListView(
//      scrollDirection: Axis.vertical,
//      shrinkWrap: true,
//      children: <Widget>[
//        Column(
//          children: <Widget>[
//            donatorName != '' && donatorName != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : اسم المتبرع'),
//                      Text(donatorName),
//                    ],
//                  )
//                : Container(),
//            donatorMobile != '' && donatorMobile != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : رقم التليفون'),
//                      Text(donatorMobile),
//                    ],
//                  )
//                : Container(),
//            donatorAddress != '' && donatorAddress != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : العنوان'),
//                      Text(donatorAddress),
//                    ],
//                  )
//                : Container(),
//            donationDate != '' && donationDate != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : تاريخ التبرع'),
//                      Text(donationDate),
//                    ],
//                  )
//                : Container(),
//            donationItems != '' && donationItems != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : وصف التبرع'),
//                      Text(donationItems),
//                    ],
//                  )
//                : Container(),
//            donationType != '' && donationType != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : نوع التبرع'),
//                      Text(donationType),
//                    ],
//                  )
//                : Container(),
//            donationAmount != '' && donationAmount != null
//                ? Row(
//                    textDirection: TextDirection.rtl,
//                    children: <Widget>[
//                      Text(' : المبلغ'),
//                      Text(donationAmount),
//                    ],
//                  )
//                : Container(),
//            donationImage != '' && donationImage != null
//                ? Image.network(donationImage)
//                : Container(),
//          ],
//        ),
//      ],
//    );

  }
}
