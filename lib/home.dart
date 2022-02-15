import 'dart:developer';
import 'dart:math';

import 'package:location/location.dart';
import 'package:witherapp/my_location.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScrean extends StatefulWidget {
  const HomeScrean({Key? key}) : super(key: key);

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  //
  var temp;
  String description = "";
  var currently;
  var humidity;
  var windSpeed;
  String asset = "assets/imeges/sun.jpg";
  final _APIKEY = "7e2fa67a5584eda8299f635a98c41731";
  String _lat = "";
  String _lon = "";
  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: Text(
                    "Tiji",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "${temp}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    "$description",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(
              20.0,
            ),
            child: ListView(children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                title: Text("Tempareture"),
                trailing: Text("$temp"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.cloud),
                title: Text("weather"),
                trailing: Text("$description"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.sun),
                title: Text("Humedity"),
                trailing: Text("$humidity"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.wind),
                title: Text("wind"),
                trailing: Text("$windSpeed"),
              )
            ]),
          ))
        ],
      ),
    );
  }

  Future getWeather() async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${this._lat}&lon=${this._lon}&units=metric&appid=$_APIKEY");
    print(this._lat);
    http.Response response = await http.get(url);
    print(response.statusCode);
    var Results = jsonDecode(response.body);
    setState(() {
      this.temp = Results["main"]["temp"];
      this.description = Results["weather"][0]["description"];
      this.currently = Results["weather"][0]["main"];
      this.humidity = Results["main"]["humidity"];
      this.windSpeed = Results["wind"]["speed"];
    });
    if (description.contains("cloud")) {
      asset = "assets/imeges/cloudy.jpg";
    } else if (description.contains("rain")) {
      asset = asset = "assets/imeges/rain.jpg";
    }
  }

  void getlocation() async {
    final service = MyLocation();
    final locationData = await service.getlocation();
    //
    //
    if (locationData != null) {
      setState(() {
        this._lat = locationData.latitude!.toStringAsFixed(2);
        this._lon = locationData.longitude!.toStringAsFixed(2);
      });
      getWeather();
    }
  }
}
