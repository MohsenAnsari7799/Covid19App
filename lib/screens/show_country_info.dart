import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
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
  String selectedUserDate;

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
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "${widget.country['persianName']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: "DanaMedium",
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
            body: _buildBody()));
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              height: 240.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  )),
              child: Column(
                children: [
                  TotalInfo(Colors.orange[400], "تعداد بیماران در بازه انتخابی",
                      items.last['Confirmed']),
                  TotalInfo(Colors.red, "تعداد مرگ و میر در بازه انتخابی",
                      items.last['Deaths']),
                  TotalInfo(
                      Colors.green[700],
                      "تعداد بهبود یافتگان در بازه انتخابی",
                      items.last['Recovered']),
                  TotalInfo(Colors.cyan, "تعداد بیماران فعال در بازه انتخابی",
                      items.last['Active']),
                  Container(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0),
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDateDialog('from');
                          },
                          child: Row(
                            children: [
                              Text(
                                'از  ${persianDate.gregorianToJalali("${from}T00:19:54.000Z", "d-m-yyyy")}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "DanaBold",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(Icons.arrow_drop_down_circle),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDateDialog('to');
                          },
                          child: Row(
                            children: [
                              Text(
                                'تا  ${persianDate.gregorianToJalali("${to}T00:19:54.000Z", "d-m-yyyy")}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "DanaBold",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(Icons.arrow_drop_down_circle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    setState(() {
      loading = true;
    });

    var url = Uri.parse(
        "https://api.covid19api.com/country/${widget.country['Slug']}?from=${from}T00:00:00Z&to=${to}T00:00:00Z");

    items.clear();

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

  void showDateDialog(String type) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              type == "from" ? 'از' : 'تا',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontFamily: "DanaRegular",
              ),
              overflow: TextOverflow.ellipsis,
            ),
            content: Container(
              margin: EdgeInsets.only(top: 5.0),
              child: LinearDatePicker(
                  startDate: "1398/11/15", //yyyy/mm/dd
                  endDate:
                      "${persianDate.gregorianToJalali(DateTime.now().toString(), "yyyy/mm/dd")}",
                  initialDate: persianDate.gregorianToJalali(
                      type == "from" ? from : to, "yyyy/mm/dd"),
                  dateChangeListener: (String selectedDate) {
                    selectedUserDate = selectedDate;
                  },
                  showDay: true, //false -> only select year & month
                  fontFamily: 'DanaMedium',
                  showLabels:
                      true, // to show column captions, eg. year, month, etc.
                  textColor: Colors.black,
                  selectedColor: Colors.green[700],
                  unselectedColor: Colors.blueGrey,
                  yearText: "سال",
                  monthText: "ماه",
                  dayText: "روز",
                  columnWidth: 60.0,
                  isJalaali: true // false -> Gregorian
                  ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'لغو',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: "DanaBold",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FlatButton(
                onPressed: () {
                  int year = int.parse(selectedUserDate.split("/")[0]);
                  int month = int.parse(selectedUserDate.split("/")[1]);
                  int day = int.parse(selectedUserDate.split("/")[2]);

                  if (type == "from") {
                    from = persianDate
                        .jalaliToGregorian(
                            DateTime(year, month, day).toString())
                        .toString()
                        .split(" ")[0];
                  } else {
                    to = persianDate
                        .jalaliToGregorian(
                            DateTime(year, month, day).toString())
                        .toString()
                        .split(" ")[0];
                  }
                  _setData();
                  Navigator.pop(context);
                },
                child: Text(
                  'تائید',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: "DanaBold",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
        });
  }
}

// ignore: must_be_immutable
class TotalInfo extends StatelessWidget {
  final Color color;
  String str;
  var number;

  TotalInfo(this.color, this.str, this.number);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Text(
                "$str",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: "DanaMedium",
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "$number",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: "DanaBold",
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
