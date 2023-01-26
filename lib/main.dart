import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';

import 'conical.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Query dbRef = FirebaseDatabase.instance.ref().child('quality');

  int whC = 0;
  var whS = "";
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
    } else if (ph > 7 && ph < 10) {
      phI = "Slightly acidic";
    } else if (ph < 7 && ph > 4) {
      phI = "Slightly basic";
    } else if (ph <= 4) {
      phI = "Basic";
    } else if (ph >= 10) {
      phI = "Acidic";
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

    if (oxy >= 6 && oxy <= 10) {
      oxyI = "Optimum";
    } else if (temp > 10) {
      oxyI = "High";
    } else if (temp < 6) {
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
            width: scrW / 3.2,
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
        child: Row(
          children: [
            const SizedBox(
              height: 20,
              width: 20,
            ),
            Column(
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: scrW / 4,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, (scrW - 50) / 9, 0, 0),
              child: Flask(data['Oxygen level'].toDouble()),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
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
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Column(
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
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: scrW / 2.9,
            ),
            Stack(children: [
              Container(
                height: 110,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: data['pH'] >= 5 && data['pH'] <= 9
                      ? Colors.green
                      : Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 46, 0, 0),
                  child: Text(
                    "${data['pH']}",
                    style: const TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          ],
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(scrW / 12, 15, 0, 0),
              height: scrH / 4,
              width: scrW / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: scrH / 50,
                    ),
                    const Text(
                      "TEMPERATURE",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: scrH / 100,
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
                    SizedBox(
                      height: scrH / 80,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: scrW / 30,
                        ),
                        Text(
                          "${data['Temperature']}°C",
                          style: const TextStyle(
                            fontFamily: "SF-Pro",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: scrW / 15,
                        ),
                        const Text(
                          "Optimum",
                          style: TextStyle(
                            fontFamily: "SF-Pro",
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              height: scrH / 4,
              width: scrW / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: scrH / 50,
                    ),
                    const Text(
                      "SALINITY",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: scrH / 50,
                    ),
                    Container(
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
                    SizedBox(
                      height: scrH / 40,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: scrW / 30,
                        ),
                        Text(
                          "${data['TDS']}%",
                          style: const TextStyle(
                            fontFamily: "SF-Pro",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: scrW / 15,
                        ),
                        Text(
                          tempI,
                          style: const TextStyle(
                            fontFamily: "SF-Pro",
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: GNav(
              gap: 5,
              onTabChange: (index) {
                print(index);
              },
              backgroundColor: Colors.white,
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: Color(0xffDADEEC),
              padding: EdgeInsets.all(5),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  iconActiveColor: Colors.black,
                ),
                GButton(
                  icon: Icons.dashboard_customize,
                  text: 'Add Pond',
                ),
                GButton(
                  icon: Icons.menu,
                  text: 'Menu',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
            ),
          ),
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
              height: 54,
              width: 72,
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
