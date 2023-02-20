import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'conical.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Query dbRef = FirebaseDatabase.instance.ref().child('quality');

  int whC = 30;
  var whS = "Mostly Cloudly";
  // String WIco = "";

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Future<void> getWeather() async {
    var cityName = "Chennai";
    var response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=e5f0de7f89494da8b3a90715232401&q=$cityName&aqi=yes'));

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      whC = jsonData['current']['temp_c'].toInt();
      whS = jsonData['current']["condition"]['text'];
    } else {
      whC = 28;
      whS = "Mostly Cloudly";
    }
    // WIco = "http:${jsonData['current']["condition"]['icon']}";
  }

  Widget Dashboard({required Map data}) {
    double scrW = MediaQuery.of(context).size.width;
    double scrH = MediaQuery.of(context).size.height;

    if (data['pH'] == null ||
        data['TDS'] == null ||
        data['Oxygen level'] == null ||
        data['Temperature'] == null) {
      return Container();
    }
    double tempP = data['Temperature'] / 50.0;
    double ph = data['pH'].toDouble();
    double temp = data['Temperature'].toDouble();
    double oxy = data['Oxygen level'].toDouble();
    String phI, tempI, oxyI;
    if (ph == 7) {
      phI = "Neutral";
    } else if (ph > 7 && ph <= 8.5) {
      phI = "Slightly basic";
    } else if (ph >= 5.5 && ph < 7) {
      phI = "Slightly acidic";
    } else if (ph <= 5.5) {
      phI = "Acidic";
    } else if (ph > 7) {
      phI = "Basic";
    } else {
      phI = "";
    }

    if (temp >= 24 && temp <= 26) {
      tempI = "Optimum";
    } else if (temp > 26) {
      tempI = "High";
    } else if (temp < 24) {
      tempI = "Low";
    } else {
      tempI = "";
    }

    if (oxy >= 5 && oxy <= 11) {
      oxyI = "Optimum";
    } else if (oxy > 11) {
      oxyI = "High";
    } else if (oxy < 5) {
      oxyI = "Low";
    } else {
      oxyI = "";
    }

    return Column(children: [
      Row(
        children: [
          Column(
            children: [
              Row(
                children: const [
                  SizedBox(
                    height: 30,
                    width: 30,
                  ),
                  Icon(
                    Icons.account_circle,
                    size: 24,
                  ),
                  SizedBox(
                    height: 20,
                    width: 5,
                  ),
                  Text(
                    "Hello Ruby",
                    style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AppDraw(),
            ],
          ),
          SizedBox(
            height: 20,
            width: scrW / 3.5,
          ),
          // AppDraw(),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Image(
                image: AssetImage("images/Cloud.png"),
                height: 55,
                width: 79,
              ),
              Text(
                "$whC°C",
                style: const TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 20,
                ),
              ),
              Text(
                whS,
                style: const TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: scrH / 25,
      ),
      Container(
        margin: EdgeInsets.fromLTRB(scrW / 50, 0, 0, 0),
        height: scrH / 5.5,
        width: scrW - 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "OXYGEN LEVEL",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${data['Oxygen level']} ppm",
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 37,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    oxyI,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontFamily: "SF-Pro",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -scrH / 35,
              right: 5,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, (scrW - 50) / 9, 0, 0),
                child: Flask(data['Oxygen level'].toDouble()),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Container(
        // alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(scrW / 50, 0, 0, 0),
        height: scrH / 5.5,
        width: scrW - 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "PH LEVEL",
                    style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${data['pH']}",
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w100,
                      fontSize: 37,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    phI,
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 10,
              child: Stack(children: [
                Container(
                  height: 110,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: data['pH'] >= 5 && data['pH'] <= 9
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Container(
                  height: 100,
                  width: 40,
                  margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Row(
                      children: [
                        PhInd(data['pH'].toDouble()),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Image(
                            image: AssetImage("images/ph_meter.png"),
                            height: 100,
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
          ],
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(scrW / 12, 8, 0, 0),
              height: scrH / 4,
              width: scrW / 2.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Stack(children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      "TEMPERATURE",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Stack(children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      height: 100,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xfffddeeff),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 90,
                      width: 30,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                      height: 65,
                      width: 10,
                      child: LiquidLinearProgressIndicator(
                        value: tempP,
                        direction: Axis.vertical,
                        backgroundColor: Colors.blue[200],
                        borderColor: Colors.blue[200],
                        borderWidth: 1.0,
                        borderRadius: 40,
                        valueColor: data['Temperature'] >= 24 &&
                                data['Temperature'] <= 28
                            ? const AlwaysStoppedAnimation(Colors.green)
                            : const AlwaysStoppedAnimation(Colors.red),
                      ),
                    ),
                  ),
                ]),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Text(
                    "${data['Temperature']}°C",
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  right: 7,
                  bottom: 10,
                  child: Text(
                    tempI,
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                )
              ]),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              height: scrH / 4,
              width: scrW / 2.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Stack(children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Text(
                      "SALINITY",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Color(0xffF7FBFD),
                            Color(0xff71A7CD),
                          ],
                        ),
                        shape: BoxShape.circle),
                    child: LiquidCircularProgressIndicator(
                      value: data['TDS'] / 100,
                      valueColor: data['TDS'] >= 40 && data['TDS'] <= 60
                          ? AlwaysStoppedAnimation(Colors.green)
                          : AlwaysStoppedAnimation(Colors.red),
                      borderWidth: 0,
                      backgroundColor: Color.fromARGB(113, 255, 255, 255),
                      borderColor: Colors.white,
                      direction: Axis.vertical,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Text(
                    "${data['TDS']}%",
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 8,
                  child: Text(
                    tempI,
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                )
              ]),
            ),
          ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDADEEC),
        body: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map data = snapshot.value as Map;
            data['key'] = snapshot.key;
            return Dashboard(data: data);
          },
        ),
      ),
    );
  }

  Widget Flask(double value) {
    const Size kSize = Size(80, 80);
    return Container(
      height: 150,
      width: 80,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: kSize / 6,
              painter: FlaskPainter(),
            ),
            CustomPaint(
              size: kSize / 6,
              painter: ReflectionPainter(),
            ),
            Container(
              height: 56,
              width: 73,
              padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: LiquidCircularProgressIndicator(
                value: value / 20,
                valueColor: value > 6 && value < 10
                    ? AlwaysStoppedAnimation(Colors.green)
                    : AlwaysStoppedAnimation(Colors.red),
                borderWidth: 0,
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                direction: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PhInd(double value) {
    return Container(
      height: 100,
      child: SfLinearGauge(
        orientation: LinearGaugeOrientation.vertical,
        minimum: 0.0,
        showLabels: false,
        markerPointers: [
          LinearShapePointer(
            value: value,
            color: value >= 5 && value <= 9 ? Colors.green : Colors.red,
            width: 12,
            height: 15,
            elevation: 0,
            offset: 2,
          ),
        ],
        isAxisInversed: true,
        animateRange: true,
        interval: 5,
        showTicks: false,
        labelOffset: 2,
        maximum: 14,
        labelPosition: LinearLabelPosition.inside,
        maximumLabels: 5,
        minorTicksPerInterval: 0,
        showAxisTrack: false,
      ),
    );
  }

  Widget AppDraw() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: 130,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color.fromARGB(143, 255, 255, 255)),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "System 1",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "SF-Pro",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Image(
                image: AssetImage("images/Icon.png"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
