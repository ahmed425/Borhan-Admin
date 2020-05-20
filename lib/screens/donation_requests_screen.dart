import 'package:BorhanAdmin/providers/donation_requests.dart';
import 'package:BorhanAdmin/widgets/donation_request_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestsScreen extends StatefulWidget {
//  static const routeName = '/activities';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("لتبرعات"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return DonationRequestItem(
              activitiesData.donationRequests[index].id,
              activitiesData.donationRequests[index].donatorName,
              activitiesData.donationRequests[index].donationDate,
              activitiesData.donationRequests[index].donationType,
              activitiesData.donationRequests[index].donatorMobileNo

//            this.id, this.donatorName, this.donatorMobileNo,
//            this.donationType, this.donationItems
//            id: categoryMeals[index].id,
//            title: categoryMeals[index].title,
//            imageUrl: categoryMeals[index].imageUrl,
//            duration: categoryMeals[index].duration,
//            affordability: categoryMeals[index].affordability,
//            complexity: categoryMeals[index].complexity,
              );
        },
        itemCount: activitiesData.donationRequests.length,
      ),
    );
  }
}

//import 'package:BorhanAdmin/models/donation_request.dart';
//import 'package:BorhanAdmin/providers/donation_requests.dart';
//import 'package:BorhanAdmin/screens/donation_request_details.dart';
//import '../widgets/donation_request_item.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
////import '../providers/activities.dart';
////import './add_activity.dart';
////import '../widgets/activity_item.dart';
//
//class DonationRequestsScreen extends StatefulWidget {
////  static const routeName = '/donationRequests';
//
//
//  @override
//  _DonationRequestsScreenState createState() => _DonationRequestsScreenState();
//}
//
//class _DonationRequestsScreenState extends State<DonationRequestsScreen> {
//  var _isLoading = false;
//  final String id;
//  _DonationRequestsScreenState(this.id);
//  var _isInit = true;
//  List<DonationRequest> hi = [];
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
//    final donationRequestsData = Provider.of<DonationRequests>(context);
//    final List<DonationRequest> requests =
//        donationRequestsData.donationRequests;
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("التبرعات"),
//        backgroundColor: Colors.pink,
//      ),
//      body:
////      height: 300,
//          ListView.builder(
//        itemBuilder: (ctx, index) {
//          return Card(
//            child: Row(
//              children: <Widget>[
//                Container(
//                  margin: EdgeInsets.symmetric(
//                    vertical: 10,
//                    horizontal: 15,
//                  ),
//                  decoration: BoxDecoration(
//                    border: Border.all(
//                      color: Colors.purple,
//                      width: 2,
//                    ),
//                  ),
//                  padding: EdgeInsets.all(10),
//                  child: Text(
//                    requests[index].donationType,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: 20,
//                      color: Colors.purple,
//                    ),
//                  ),
//                ),
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      requests[index].donatorName,
//                      style: TextStyle(
//                        fontSize: 16,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    Text(
//                      requests[index].donationDate,
//                      style: TextStyle(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          );
//        },
//        itemCount: requests.length,
//      ),
//      onTap: () {
//
//        Navigator.of(context).pushNamed(
//            DonationDetails.routeName,
//            arguments: id,
//      }
//    );
//
//  }
//}
//
////      body: Text("${hi[0].donationDate}"),
////    );
////  }
////}
//
////      body: ListView.separated(
//////        padding: const EdgeInsets.all(10),
////        itemCount: donationRequestsData.donationRequests.length,
////        itemBuilder: (_, i) => DonationRequestItem(
////          donationRequestsData.donationRequests[i].donatorName,
////          donationRequestsData.donationRequests[i].donationType,
////          donationRequestsData.donationRequests[i].donatorMobileNo,
////          donationRequestsData.donationRequests[i].donationDate,
////        ),
////        separatorBuilder: (BuildContext context, int index) => const Divider(),
////      ),
////    );
////  }
////}
//
////      body: Container(
//////    height: 300,
////        child: ListView.builder(
////          padding: const EdgeInsets.all(10),
////          itemCount: donationRequestsData.donationRequests.length,
////          itemBuilder: (_, int index) => ListTile(
////            title:
////                Text(donationRequestsData.donationRequests[index].donatorName,
////                    maxLines: 1,
////                    overflow: TextOverflow.ellipsis,
////                    style: TextStyle(
////                      fontWeight: FontWeight.w500,
////                      fontSize: 20,
////                      color: Colors.white,
////                    )),
////            subtitle: Text(
////              donationRequestsData.donationRequests[index].donationItems,
////              maxLines: 2,
////              overflow: TextOverflow.ellipsis,
////              style: TextStyle(
////                color: Colors.white,
////              ),
////            ),
////            trailing: Text(
////              'نوع التبرع' +
////                  '\n' +
////                  '${donationRequestsData.donationRequests[index].donationType}',
////              style: TextStyle(
////                color: Colors.white,
////              ),
////            ),
//////          leading: ClipRRect(
//////            borderRadius: BorderRadius.circular(8.0),
//////            child: Image.network(
//////                donationRequestsData.donationRequests[index].image),
//////          ),
////          ),
////        ),
////      ),
////    );
////  }
////}
////
//////              onTap: () {
//////                Navigator.push(
//////                    context,
//////                    MaterialPageRoute(
//////                        builder: (context) =>
//////                            MovieDetails('${movies.moviesList[index].id}')));
//////              },
//////),
//////),
//////              itemBuilder: (_, int index) => DonationRequestItem(
//////                  donationRequestsData.donationRequests[index].donatorName,
//////                  donationRequestsData.donationRequests[index].donatorMobileNo,
//////                  donationRequestsData.donationRequests[index].donationType,
//////                  donationRequestsData.donationRequests[index].donationItems),
//////          title: Text(),
//////              maxLines: 2,
//////              overflow: TextOverflow.ellipsis,
//////              style: TextStyle(
//////                fontWeight: FontWeight.w500,
//////                fontSize: 20,
//////                color: Colors.white,
//////              )),
//////          subtitle: Text(
//////            movies.moviesList[index].overview,
//////            maxLines: 2,
//////            overflow: TextOverflow.ellipsis,
//////            style: TextStyle(
//////              color: Colors.white,
//////            ),
//////          ),
//////          trailing: Text(
//////            'Release Date' +
//////                '\n' +
//////                '${movies.moviesList[index].releaseDate.year}' +
//////                '-' '${movies.moviesList[index].releaseDate.month}' +
//////                '-' +
//////                '${movies.moviesList[index].releaseDate.day}',
//////            style: TextStyle(
//////              color: Colors.white,
//////            ),
//////          ),
//////          leading: ClipRRect(
//////            borderRadius: BorderRadius.circular(8.0),
//////            child: Image.network("https://image.tmdb.org/t/p/w185" +
//////                movies.moviesList[index].posterPath),
//////          ),
//////
//////        body: Center(
//////          child: CircularProgressIndicator(),
//////        )
//////          :
//////          : ListView.separated(
//////              padding: const EdgeInsets.all(10),
//////              itemCount: donationRequestsData.items.length,
//////              itemBuilder: (_, i) => ActivityItem(
//////                donationRequestsData.items[i].activityName,
//////                donationRequestsData.items[i].id,
//////              ),
//////              separatorBuilder: (BuildContext context, int index) =>
//////                  const Divider(),
//////            ),
//////          ListView.builder(
//////              padding: const EdgeInsets.all(10),
//////              itemCount: donationRequestsData.donationRequests.length,
//////              itemBuilder: (_, int index) => ListTile(
//////                title: Text(
//////                    donationRequestsData.donationRequests[index].donatorName,
//////                    maxLines: 1,
//////                    overflow: TextOverflow.ellipsis,
//////                    style: TextStyle(
//////                      fontWeight: FontWeight.w500,
//////                      fontSize: 20,
//////                      color: Colors.white,
//////                    )),
//////                subtitle: Text(
//////                  donationRequestsData.donationRequests[index].donationItems,
//////                  maxLines: 2,
//////                  overflow: TextOverflow.ellipsis,
//////                  style: TextStyle(
//////                    color: Colors.white,
//////                  ),
//////                ),
//////                trailing: Text(
//////                  'نوع التبرع' +
//////                      '\n' +
//////                      '${donationRequestsData.donationRequests[index].donationType}',
//////                  style: TextStyle(
//////                    color: Colors.white,
//////                  ),
//////                ),
//////                leading: ClipRRect(
//////                  borderRadius: BorderRadius.circular(8.0),
//////                  child: Image.network(
//////                      donationRequestsData.donationRequests[index].image),
//////                ),
////////              onTap: () {
////////                Navigator.push(
////////                    context,
////////                    MaterialPageRoute(
////////                        builder: (context) =>
////////                            MovieDetails('${movies.moviesList[index].id}')));
////////              },
//////              ),
//////            ),
//////              itemBuilder: (_, int index) => DonationRequestItem(
//////                  donationRequestsData.donationRequests[index].donatorName,
//////                  donationRequestsData.donationRequests[index].donatorMobileNo,
//////                  donationRequestsData.donationRequests[index].donationType,
//////                  donationRequestsData.donationRequests[index].donationItems),
//////          title: Text(),
//////              maxLines: 2,
//////              overflow: TextOverflow.ellipsis,
//////              style: TextStyle(
//////                fontWeight: FontWeight.w500,
//////                fontSize: 20,
//////                color: Colors.white,
//////              )),
//////          subtitle: Text(
//////            movies.moviesList[index].overview,
//////            maxLines: 2,
//////            overflow: TextOverflow.ellipsis,
//////            style: TextStyle(
//////              color: Colors.white,
//////            ),
//////          ),
//////          trailing: Text(
//////            'Release Date' +
//////                '\n' +
//////                '${movies.moviesList[index].releaseDate.year}' +
//////                '-' '${movies.moviesList[index].releaseDate.month}' +
//////                '-' +
//////                '${movies.moviesList[index].releaseDate.day}',
//////            style: TextStyle(
//////              color: Colors.white,
//////            ),
//////          ),
//////          leading: ClipRRect(
//////            borderRadius: BorderRadius.circular(8.0),
//////            child: Image.network("https://image.tmdb.org/t/p/w185" +
//////                movies.moviesList[index].posterPath),
//////          ),
//////          onTap: () {
//////            Navigator.push(
//////                context,
//////                MaterialPageRoute(
//////                    builder: (context) =>
//////                        MovieDetails('${movies.moviesList[index].id}')));
//////          },
//////            )
//////        itemCount: movies.moviesList.length,
////
//////      floatingActionButton: FloatingActionButton(
//////        onPressed: () {
//////          Navigator.push(
//////            context,
//////            MaterialPageRoute(
//////              builder: (context) => AddActivity(),
//////            ),
//////          );
//////        },
//////        child: const Icon(Icons.add),
//////        backgroundColor: Colors.lightBlueAccent,
//////      ),
//////);
