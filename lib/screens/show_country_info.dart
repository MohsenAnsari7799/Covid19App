import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_date/persian_date.dart';

// ignore: must_be_immutable
class ShowCountryInfo extends StatefulWidget {
  var country;
  ShowCountryInfo(this.country);

  @override
  _ShowCountryInfoState createState() => _ShowCountryInfoState();
}

class _ShowCountryInfoState extends State<ShowCountryInfo> {
  List items = [];
  bool loading = true;

  PersianDate persianDate = PersianDate();

  var from;
  var to;
  var date = DateTime.now();

  @override
  void initState() {
    from = DateTime(date.year, date.month - 1, date.day - 2)
        .toString()
        .split(" ")[0];
    to = date.toString().split(" ")[0];
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  centerTitle: true,
                  title: Text(
                    "${widget.country['Country']}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "DanaLight",
                    ),
                  ),
                  backgroundColor: Colors.green,
                  actions: [
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Image.asset(
                        'assets/flags/${widget.country['ISO2'].toString().toLowerCase()}.png',
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                  ],
                ),
              ];
            },
            body: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return SpinKitDoubleBounce(
        color: Colors.green,
        size: 50.0,
      );
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                var item = items[index];
                if (index == 0) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                  child: Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            color: Colors.orange[400],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.orange[400],
                                              width: 1.0,
                                            )),
                                        child: Text(
                                          "${items[index]['Confirmed'] - items[index - 1]['Confirmed']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontFamily: "DanaBlack",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            color: Colors.green[700],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.green[700],
                                              width: 1.0,
                                            )),
                                        child: Text(
                                          "${items[index]['Recovered'] - items[index - 1]['Recovered']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontFamily: "DanaBlack",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.0,
                                            )),
                                        child: Text(
                                          "${items[index]['Deaths'] - items[index - 1]['Deaths']}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontFamily: "DanaBlack",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "${persianDate.gregorianToJalali(item['Date'], "yyyy/mm/dd")}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontFamily: "DanaRegular",
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _setData() async {
    var url = Uri.parse(
        "https://api.covid19api.com/country/${widget.country['Slug']}?from=${from}T00:00:00Z&to=${to}T00:00:00Z");
    var responce = await http.get(url);
    if (responce.statusCode == 200) {
      var jsonResponce = convert.jsonDecode(responce.body);
      items.addAll(jsonResponce);

      setState(() {
        loading = false;
      });
    } else {
      print(responce.statusCode);
    }
  }
}
