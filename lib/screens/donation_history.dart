import 'package:BorhanAdmin/providers/history_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/history_item.dart';
import '../models/donation_history.dart';
import 'package:provider/provider.dart';

class DonationHistory extends StatefulWidget {

  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<HistoryProvider>(context).fetchAndSetActivities().then((_) {
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
    final historyData = Provider.of<HistoryProvider>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: historyData.items.length,
            itemBuilder: (_, i) {
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: FittedBox(
                      child: Material(
//                        color: Colors.white,
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(24.0),
                        shadowColor: Color(0x802196F3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(24.0),
                                child: historyData.items[i].donationImage !=
                                            '' &&
                                        historyData.items[i].donationImage !=
                                            null
                                    ? Image(
                                        fit: BoxFit.fill,
                                        alignment: Alignment.topLeft,
                                        image: NetworkImage(
                                          historyData.items[i].donationImage,
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
                                padding: const EdgeInsets.only(left: 16.0),
                                child: HistoryItem(
                                  donatorName: historyData.items[i].donatorName,
                                  donatorMobile:
                                      historyData.items[i].donatorMobile,
                                  donatorAddress:
                                      historyData.items[i].donatorAddress,
                                  donationType:
                                      historyData.items[i].donationType,
                                  donationItems:
                                      historyData.items[i].donationItems,
                                  donationDate:
                                      historyData.items[i].donationDate,
                                  donationAmount:
                                      historyData.items[i].donationAmount,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );

//    return Scaffold(
//      appBar: AppBar(
//        title: Text('History'),
//      ),
//      body: Container(
//        child: _isLoading
//            ? Center(
//                child: CircularProgressIndicator(),
//              )
//            : ListView.separated(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//                padding: const EdgeInsets.all(10),
//                itemCount: historyData.items.length,
//                itemBuilder: (_, i) => HistoryItem(
//                  donatorName: historyData.items[i].donatorName,
//                  donatorMobile: historyData.items[i].donatorMobile,
//                  donatorAddress: historyData.items[i].donatorAddress,
//                  donationType: historyData.items[i].donationType,
//                  donationItems: historyData.items[i].donationItems,
//                  donationDate: historyData.items[i].donationDate,
//                  donationAmount: historyData.items[i].donationAmount,
//                  donationImage: historyData.items[i].donationImage,
//                ),
//                separatorBuilder: (BuildContext context, int index) =>
//                    const Divider(),
//              ),
//      ),
//    );
  }
}
