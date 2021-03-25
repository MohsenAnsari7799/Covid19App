import 'package:covid19/screens/show_country_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCountries extends StatefulWidget {
  ShowCountries({Key key}) : super(key: key);

  @override
  _ShowCountriesState createState() => _ShowCountriesState();
}

class _ShowCountriesState extends State<ShowCountries> {
  List countries = [];
  List items = [];
  bool loading = true;

  @override
  void initState() {
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
                  centerTitle: true,
                  title: Text(
                    "لیست کشورها",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontFamily: "DanaMedium",
                    ),
                  ),
                  backgroundColor: Colors.green,
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: TextField(
              onChanged: (value) {
                items.clear();
                if (value.isEmpty) {
                  items.addAll(countries);
                } else {
                  countries.forEach((element) {
                    if (element['Country']
                        .toString()
                        .toLowerCase()
                        .contains(value)) {
                      items.add(element);
                    }
                  });
                }
                setState(() {});
              },
              textAlign: TextAlign.right,
              autofocus: false,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontFamily: "DanaRegular"),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'کشور مورد نظر را وارد کنید',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12.7),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                var country = items[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ShowCountryInfo(country);
                      }));
                    },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${country['Country']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: "DanaMedium",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/flags/${country['ISO2'].toString().toLowerCase()}.png',
                              width: 60.0,
                              height: 60.0,
                            ),
                          ],
                        ),
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
    var url = Uri.parse('https://api.covid19api.com/countries');
    var responce = await http.get(url);
    if (responce.statusCode == 200) {
      var jsonResponce = convert.jsonDecode(responce.body);
      countries = jsonResponce;
      items.addAll(jsonResponce);

      setState(() {
        loading = false;
      });
    } else {
      print(responce.statusCode);
    }
  }
}
