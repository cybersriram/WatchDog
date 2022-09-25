// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, unnecessary_new
import 'package:flutter/material.dart';
import 'supportDoc.dart';
import 'getnumber.dart';
void main() {
  runApp(
    MaterialApp(
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int btnVal = 1;
  Widget selectWidget(){
    if(btnVal == 1){
      return Functions().landingpage();
    }
    else if(btnVal == 2){
      return Functions().calling_page();
    }
    else{
      return SafeArea(
        child: Text(
          "Something Went Wrong Kindly restart the App",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 26,
              color: Colors.green
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text('Long Press The Button'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Numberget()),
                      // (Route<dynamic> route) => true,
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                )),
          ]),
      body: selectWidget(),
      persistentFooterButtons: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      btnVal = 1;
                    });
                  },
                  child: Text("Trigger SMS",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            VerticalDivider(
              thickness: 1,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      btnVal = 2;
                    });
                  },
                  child: Text("Emergency Call",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
