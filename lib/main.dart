import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

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

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 21, 0, 0),
              child: Text(
                "Hello Ruby",style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(scrW/2.5, 21, 0, 0),
              child: Icon(Icons.account_circle,size: 24,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 21, 0, 0),
              child: Icon(Icons.menu,size: 24,),
            ),
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
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                    child: Text("WEATHER",style: TextStyle(
                      fontSize: 15,
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Text("27°C",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 28,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Text("Mostly clear",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 15,
                    ),),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB((scrW-50)/2.3, 0, 0, 0),
                child :Image(image: AssetImage("images/Cloud.png")),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
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
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Image(image: AssetImage("images/temp.png"),
                          height: 18,width: 12,),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text("TEMPERATURE",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Text("${data['Temperature']}°C",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 37,
                    ),),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB((scrW-50)/3.5, 0, 0, 0),
                child: Text("High",style: TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 15,
                ),),
              ),
              SizedBox(width: 15,),
               Container(
                  height: 65,width: 65,
                  child: LiquidCircularProgressIndicator(
                    value: tempP,
                    valueColor: tempP>=0.5 ? AlwaysStoppedAnimation(Colors.red) : AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Color(0xffC9EDFF),
                    borderColor: Colors.black,
                    borderWidth: 0.0,
                    direction: Axis.vertical,
                  ),
                ),
              // Container(
              //   height: 65,width: 65,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color(0xffC9EDFF),
              //   ),
              //   child :Image(image: AssetImage(
              //     "images/Mask1.png",),height: 65,width: 65,),
              // ),
            ],
          ),
        ),
        SizedBox(height: 20,),
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
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Icon(Icons.water_drop,size: 18,),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(3, 10, 0, 0),
                        child: Text("PH LEVEL",style: TextStyle(
                          fontFamily: "SF-Pro",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 10, 0, 0),
                    child: Text("${data['pH']}",style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontSize: 37,
                    ),),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB((scrW-50)/2.7, 0, 0, 0),
                child: Text("Low",style: TextStyle(
                  fontFamily: "SF-Pro",
                  fontSize: 15,
                ),),
              ),
              SizedBox(width: 15,),
              Container(
                height: 65,width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffC9EDFF),
                ),
                child :Image(image: AssetImage(
                  "images/ph.png",),height: 65,width: 65,),
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
              height: scrH/5,width: (scrW/2)-50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Image(image: AssetImage("images/de.png")),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text("OXYGEN LEVEL",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("${data['Oxygen level']} ppm",style: TextStyle(
                      fontSize: 35,
                      fontFamily: "SF-Pro",
                    ),),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
                        child: Text("Optimum",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(scrW/16, 0, 0, 0),
                        height: 53,width: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffC9EDFF),
                        ),
                        child :Image(image: AssetImage(
                          "images/i2.png",),height: 53,width: 55,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 15, 0, 0),
              height: scrH/5,width: (scrW/2)-50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Image(image: AssetImage("images/ec.png")),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text("CONDUCTIVITY",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("${data['TDS']}%",style: TextStyle(
                      fontSize: 37,
                      fontFamily: "SF-Pro",
                    ),),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
                        child: Text("Optimum",style: TextStyle(
                          fontSize: 15,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(scrW/16, 0, 0, 0),
                        height: 53,width: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffC9EDFF),
                        ),
                        child :Image(image: AssetImage(
                          "images/i2.png",),height: 53,width: 55,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDF1FE),
      body : FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
          Map data = snapshot.value as Map;
          data['key'] = snapshot.key;

          return SafeArea(child: Dashboard(data: data));
        },
      )
    );
  }
}
