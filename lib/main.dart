import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'conical.dart';

Future<void> main() async{
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

  Widget Dashboard({required Map data}){

    double scrW = MediaQuery.of(context).size.width;
    double scrH = MediaQuery.of(context).size.height;


    if(data['pH']==null || data['TDS']==null ||
        data['Oxygen level']==null || data['Temperature']==null){
      return Container();
    }
    double tempP = data['Temperature']/50.0;
    double phP = data['pH']/14.0;
    double oxyP = data['pH']/20.0;

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 21, 0, 0),
              child: Icon(Icons.account_circle,size: 24,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 21, 0, 0),
              child: Text(
                "Hello Ruby",style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(scrW/3, 21, 0, 0),
                  child :Image(image: AssetImage("images/Cloud.png"),height: 55,width: 79,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(scrW/3, 0, 0, 0),
                  child: Text("27°C",style: TextStyle(
                    fontFamily: "SF-Pro",
                    fontSize: 20,
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(scrW/3, 5, 0, 0),
                  child: Text("Mostly clear",style: TextStyle(
                    fontFamily: "SF-Pro",
                    fontSize: 15,
                  ),),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 44,),
        Container(
          alignment: Alignment.center,
          height: scrH/6.5,width: scrW-50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(23, 10, 0, 0),
                        child: Text("OXYGEN LEVEL",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(23, 10, 0, 0),
                    child: Text("${data['Oxygen level']} ppm",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 37,
                    ),),
                  ),
                ],
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB((scrW-50)/3.5, 0, 0, 0),
              //   child: Text("Low",style: TextStyle(
              //     fontFamily: "SF-Pro",
              //     fontSize: 15,
              //   ),),
              // ),
              SizedBox(width: 110,),
               Text("Low"),
               Container(
                 padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
                   child: Flask(data['Oxygen level'].toDouble())
               ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Container(
          alignment: Alignment.center,
          height: 120,width: scrW-50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(23, 10, 0, 0),
                        child: Text("PH LEVEL",style: TextStyle(
                          fontFamily: "SF-Pro",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(23, 5, 0, 0),
                    child: Text("${data['pH']}",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 37,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(23, 5, 0, 0),
                    child: Text("Slightly basic",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 15,
                    ),),
                  ),
                ],
              ),
              SizedBox(width: 130,),
              Text("Low",style: TextStyle(
                fontFamily: "SF-Pro",
                fontSize: 15,
              ),),
              SizedBox(width: 10,),
              Stack(
                children: [
                  Container(height: 110,width: 60,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2,46,0,0),
                      child: Text("${data['pH']}",style: TextStyle(
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                  Container(height: 100,width: 40,
                    margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                  ),
                  Container(margin:EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Row(
                        children: [
                          PhInd(data['pH'].toDouble()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,0),
                            child: Image(image: AssetImage("images/ph_meter.png"),height: 100,),
                          ),
                        ],
                      )),
                ]
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 15, 0, 0),
              height: 163,width: scrW/2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                    child: Text("TEMPERATURE",style: TextStyle(
                      fontSize: 15,
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  // Center(
                  //   child: Image(image: AssetImage("images/temp_meter.png"),),
                  // ),
                  SizedBox(height: 8,),
                  Stack(
                    children: <Widget>[
    Center(
      child: Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      height: 100,width: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Color(0xfffddeeff),),),
    ),
    Center(
      child: Container(height: 90,width: 30,margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Color(
          0xffffffff),),),
    ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                          height: 65, width: 10,
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                          child: LiquidLinearProgressIndicator(
                            value: tempP,direction: Axis.vertical,
                            backgroundColor: Colors.blue[200],
                            borderColor: Colors.blue[200],
                            borderWidth: 1.0,
                            borderRadius: 40,
                            valueColor: data['Temperature']>=24 && data['Temperature']<=28 ? AlwaysStoppedAnimation(Colors.green) : AlwaysStoppedAnimation(Colors.red),
                          ),
                        ),
                      ),
    ]
    ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(18, 3, 0, 0),
                        child: Text("${data['Temperature']}°C",style: TextStyle(
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(27, 0, 0, 0),
                        child: Text("Optimum",style: TextStyle(
                          fontFamily: "SF-Pro",
                          fontSize: 16,
                          color: Colors.blue,
                        ),),
                      ),
                    ],
                  )
    ]),
    ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 15, 0, 0),
              height: 163,width: scrW/2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,0,0),
                        child: Text("SALINITY",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                    // Center(
                    //   child: Image(image: AssetImage("images/temp_meter.png"),),
                    // ),
                    SizedBox(height: 8,),

                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(18, 3, 0, 0),
                          child: Text("${data['Temperature']}°C",style: TextStyle(
                            fontFamily: "SF-Pro",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(27, 0, 0, 0),
                          child: Text("Optimum",style: TextStyle(
                            fontFamily: "SF-Pro",
                            fontSize: 16,
                            color: Colors.blue,
                          ),),
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
    return Scaffold(
      backgroundColor: const Color(0xffDADEEC),
      body : FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
          Map data = snapshot.value as Map;
          data['key'] = snapshot.key;

          return SafeArea(child: Dashboard(data: data));
        },
      ),
    );
  }

  Widget Flask(double value){
    const Size kSize = Size(80, 80);
    return Container(
      height: 150,width: 80,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: kSize/6,
              painter: FlaskPainter(),
            ),
            CustomPaint(
              size: kSize/6,
              painter: ReflectionPainter(),
            ),
            Container(
              height: 53,width: 61.8,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: LiquidCircularProgressIndicator(
                value: value/20,valueColor: AlwaysStoppedAnimation(Colors.green),
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

  Widget PhInd(double value){
    return Container(
      height: 100,
      child: SfLinearGauge(
        orientation: LinearGaugeOrientation.vertical,
        minimum: 0.0,
        showLabels: false,
        markerPointers: [
          LinearShapePointer(value: value,color: Colors.blue,width: 12,height: 15,elevation: 0,offset: 2,),
        ],
        isAxisInversed: true,
        // ranges: <LinearGaugeRange>[
        //   LinearGaugeRange(startValue: 0,endValue: 1,color: Color(0xffd53632),),
        //   LinearGaugeRange(startValue: 1,endValue: 2,color: Color(0xffe66037)),
        //   LinearGaugeRange(startValue: 2,endValue: 3,color: Color(0xfff2a846)),
        //   LinearGaugeRange(startValue: 3,endValue: 4,color: Color(0xfff7cf4a)),
        //   LinearGaugeRange(startValue: 4,endValue: 5,color: Color(0xffdddf51)),
        //   LinearGaugeRange(startValue: 5,endValue: 6,color: Color(0xffa3d548)),
        //   LinearGaugeRange(startValue: 6,endValue: 7,color: Color(0xff6ab334)),
        //   LinearGaugeRange(startValue: 7,endValue: 8,color: Color(0xff459a2e)),
        //   LinearGaugeRange(startValue: 8,endValue: 9,color: Color(0xff4aa463)),
        //   LinearGaugeRange(startValue: 9,endValue: 10,color: Color(0xff55bbb6)),
        //   LinearGaugeRange(startValue: 10,endValue: 11,color: Color(0xff3b86c1)),
        //   LinearGaugeRange(startValue: 11,endValue: 12,color: Color(0xff1e4bbf)),
        //   LinearGaugeRange(startValue: 12,endValue: 13,color: Color(0xff3226ae)),
        //   LinearGaugeRange(startValue: 13,endValue: 14,color: Color(0xff341486)),
        // ],useRangeColorForAxis: true,animateAxis: true,
        animateRange: true,interval: 5,
        showTicks: false,labelOffset: 2,
        maximum: 14,labelPosition: LinearLabelPosition.inside,
        maximumLabels: 5,minorTicksPerInterval: 0,
        showAxisTrack: false,
      ),
    );
  }
}
