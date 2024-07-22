import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:phoneinformations/phoneinformations.dart';
import 'package:permission_handler/permission_handler.dart';


class phoneInfo extends StatefulWidget {
  const phoneInfo({Key? key}) : super(key: key);

  @override
  State<phoneInfo> createState() => _phoneInfoState();
}
class userLocation{
  userLocation();
  var address;
  List? position;

  Future<List?> updatePosition() async{
    Position pos=await determinePosition();
    List pm= await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if(pm.isNotEmpty){
      final Placemark firstPlacemark = pm.first;
      final String administrativeArea = firstPlacemark.administrativeArea ?? '';
      final String subAdministrativeArea = firstPlacemark.subAdministrativeArea ?? '';
      final String country = firstPlacemark.country ?? '';

      List<dynamic> locationDetails = [subAdministrativeArea, administrativeArea, country];
      print(locationDetails);
      return locationDetails;
    }
    else{
      return null;
    }

  }
  Future<List?> getCurrentTime() async {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    String date='$day-$month-$year';
    String time='$hour:$minute:$second';
    List<dynamic> timeDetails = [date, time];
    print(timeDetails);
    return timeDetails;

  }
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
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

// Future <List?> userPosition() async{
//   updatePosition();
//   position= address;
//   return position;
//
// }



}

class _phoneInfoState extends State<phoneInfo> {
  String model = "";
  String andoidVersion = "";
  String serial = "";
  String id = "";
  String androidId = "";
  String manufacturer = "";
  String brand = "";
  String sdkInt = "";
  String simSerialNumber = "";
  String simNumber = "";
  String subscriberID = "";
  String networkCountryISO = "";
  String simCountryISO = "";
  String softwareVersion = "";
  String voiceMailNumber = "";
  String networkType = "";
  String networkGeneration = "";
  String cid = "";
  String lac = "";
  String name = "";
  String simOperator = "";
  String mobileNetworkCode = "";
  String mobileCountryCode = "";
  List? location ;
  List? time ;


  @override
  void initState() {
    super.initState();
    requestPhoneStatePermission();


  }

  Future<void> initPlatformState() async {
    PhoneInfo phoneInfos;

    try {
      phoneInfos = await Phoneinformations.getPhoneInformation();
      model = phoneInfos.model;
      name=phoneInfos.brand;
      andoidVersion = phoneInfos.andoidVersion;
      serial = phoneInfos.serial;
      id = phoneInfos.id;
      androidId = phoneInfos.androidId;
      manufacturer = phoneInfos.manufacturer;
      sdkInt = phoneInfos.sdkInt;
      simSerialNumber = phoneInfos.simSerialNumber;
      simNumber = phoneInfos.simNumber;
      subscriberID = phoneInfos.subscriberID;
      networkCountryISO = phoneInfos.networkCountryISO;
      simCountryISO = phoneInfos.simCountryISO;
      mobileNetworkCode = phoneInfos.mobileNetworkCode;
      mobileCountryCode = phoneInfos.mobileCountryCode;
      softwareVersion = phoneInfos.softwareVersion;
      voiceMailNumber = phoneInfos.voiceMailNumber;
      networkType = phoneInfos.networkType;
      networkGeneration = phoneInfos.networkGeneration;
      cid = phoneInfos.cid;
      lac = phoneInfos.lac;
      final userLoc = userLocation();
      simOperator = phoneInfos.simOperator;
      location=await userLoc.updatePosition()  ;
      time=await userLoc.getCurrentTime()  ;
      print(simNumber);
    } catch (e) {
      print("Failed to get phone infos, error : $e");
    }
    if (!mounted) return;

    setState(() {});
  }
  Future<void> requestPhoneStatePermission() async {
    var status = await Permission.phone.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.phone.request();
    }
    if (status == PermissionStatus.granted) {
      initPlatformState();

    } else {
      // Permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skani Ushinde Registration',style: TextStyle(fontFamily: 'Jersey25-Regular',color: Colors.white),),
        backgroundColor: Colors.green[700],
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(4),bottomLeft: Radius.circular(4))),
      ),
        body: Column(
          children: [
            Center(
              child: Text('Version: $andoidVersion'),
            ),
            Center(
              child: Text('Model: $model'),
            ),
            Center(
              child: Text('time: $time'),
            ),
            Center(
              child: Text('id: $id'),
            ),
            Center(
              child: Text('androidId: $androidId'),
            ),
            Center(
              child: Text('Imei: $simSerialNumber'),
            ),
            Center(
              child: Text('PhoneNumber: $simNumber'),
            ),
            Center(
              child: Text('DeviceId: $subscriberID'),
            ),
            Center(
              child: Text('networkCountryISO: $networkCountryISO'),
            ),
            Center(
              child: Text('simOperator: $simOperator'),
            ),
            Center(
              child: Text('mobileNetworkCode: $mobileNetworkCode'),
            ),
            Center(
              child: Text('mobileCountryCode: $mobileCountryCode'),
            ),
            Center(
              child: Text('SIMCountryISO: $simCountryISO'),
            ),
            Center(
              child: Text('softwareVersion: $softwareVersion'),
            ),
            Center(
              child: Text('voiceMailNumber: $voiceMailNumber'),
            ),
            Center(
              child: Text('networkType: $networkType'),
            ),
            Center(
              child: Text('networkGeneration: $networkGeneration'),
            ),
            Center(
              child: Text('location: $location'),
            ),
            Center(
              child: Text('brand: $name'),
            ),
          ],
        ),
      );

  }
}