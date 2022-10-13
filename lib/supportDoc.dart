// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class Functions{
  _makingPhoneCall() async {
    const number = '06598******';
    try{
      await FlutterPhoneDirectCaller.callNumber(number);
    }on Exception catch (_){
      print("check the code $_");
    }
  }
  Future<List> getNumbers() async{
    final prefs = await SharedPreferences.getInstance();
    var a = prefs.getKeys();
    var lst = [];
    for (String j in a){
      lst.add(prefs.getString(j));
    }
    return lst;
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      loc.Location location = loc.Location();
      await location.requestService();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  String location ='Null, Press Button';
  String Address = 'search';
  Future<String> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return Address;
  }
  Future<bool> internetcheck() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
  void sending_SMS(String msg, List<String> list_receipents) async {
    String send_result =
    await sendSMS(message: msg, recipients: list_receipents)
        .catchError((err) {
      print(err);
    });
    print(send_result);
  }
  Widget landingpage(){
    return SafeArea(
      child: Center(
        child: TextButton(
          onLongPress: () async {
            getNumbers();
            var v = await getNumbers();
            final List<String> strs = v.map((e) => e.toString()).toList();
            bool val = await internetcheck();
            final Battery _battery = Battery();
            final level = await _battery.batteryLevel;
            if (val == false) {
              Position? position = await Geolocator.getLastKnownPosition();
              String addr = await GetAddressFromLatLong(position!);
              String text = "This is Eva,Just have a check on my owner. Battery:$level%\nLast Location: $addr\nAn Emergency alarm Triggered";
              sending_SMS(text, strs);
            } else {
              var a = await _determinePosition();
              String addr = await GetAddressFromLatLong(a);
              String text = "This is Eva,Just have a check on my owner. Battery:$level%\nCurrent Location: $addr\nAn Emergency alarm Triggered";
              sending_SMS(text, strs);
            }
          },
          onPressed: null,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/help.jpg'),
            radius: 220,
          ),
        ),
      ),
    );
  }
  Widget calling_page(){
    return SafeArea(
      child: Center(
        child: TextButton(
          onLongPress: () async {
            _makingPhoneCall();
          },
          onPressed: null,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/call.png'),
            radius: 220,
          ),
        ),
      ),
    );
  }
}
