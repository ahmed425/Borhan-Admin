import 'package:BorhanAdmin/providers/history_provider.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/history_item.dart';
import 'package:provider/provider.dart';

class DonationHistory extends StatefulWidget {
  final orgLocalId;

  DonationHistory({this.orgLocalId});

  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  var _isLoading = false;
  var _isInit = true;
  String orgId = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print(orgId),
                Provider.of<HistoryProvider>(context)
                    .fetchAndSetActivities(orgId)
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                }),
              });
      setState(() {
        _isLoading = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final historyData = Provider.of<HistoryProvider>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : historyData.items.length != 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: historyData.items.length,
                itemBuilder: (_, i) {
                  return Container(
                    color: Colors.teal[50],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: FittedBox(
                          child: Row(
                            children: <Widget>[
                              Material(
                                color: Colors.teal,
                                elevation: 14.0,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        width: 150,
                                        height: 150,
                                        padding: EdgeInsets.only(right: 3.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(24.0),
                                          child: historyData.items[i]
                                                          .donationImage !=
                                                      '' &&
                                                  historyData.items[i]
                                                          .donationImage !=
                                                      null
                                              ? Image(
                                                  fit: BoxFit.fill,
                                                  alignment: Alignment.topLeft,
                                                  image: NetworkImage(
                                                    historyData
                                                        .items[i].donationImage,
                                                  ),
                                                )
                                              : Image(
                                                  fit: BoxFit.fill,
                                                  alignment: Alignment.topLeft,
                                                  image: NetworkImage(
                                                    "https://cutt.ly/zyTkoxi",
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              right: 10.0,
                                              left: 10.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                  ),
                                                  historyData.items[i]
                                                                  .donationType !=
                                                              '' &&
                                                          historyData.items[i]
                                                                  .donationType !=
                                                              null
                                                      ? Material(
                                                          elevation: 2.0,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'نوع التبرع : ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .teal,
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                historyData
                                                                    .items[i]
                                                                    .donationType,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .teal,
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  HistoryItem(
                                                    donatorName: historyData
                                                        .items[i].donatorName,
                                                    donatorMobile: historyData
                                                        .items[i].donatorMobile,
                                                    donatorAddress: historyData
                                                        .items[i]
                                                        .donatorAddress,
                                                    actName: historyData
                                                        .items[i].actName,
                                                    donationItems: historyData
                                                        .items[i].donationItems,
                                                    donationDate: historyData
                                                        .items[i].donationDate,
                                                    donationAmount: historyData
                                                        .items[i]
                                                        .donationAmount,
                                                    status: historyData
                                                        .items[i].status,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                "لا يوجد تبرعات سابقة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ));
  }
}
