
import 'package:phoneinformations/model/phoneInfos.dart';
import 'package:phoneinformations/phoneinformations.dart';
import 'package:scancode_viwango/widgets/tools.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../Screens/phoneDetails.dart';
class scanner{
  List<String> deviceDetails=[];
  String model = "";
  String id = "";
  String androidId = "";
  String sdkInt = "";
  String name = "";
  List? location ;
  List? time ;

  scanner();

  Future<String?> triggerScanner() async{

    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#28b53d', // Color for the scanner UI
      'Cancel',


      // Cancel button text
      true,
      // Show flash icon
      ScanMode
          .DEFAULT,
      // Scan mode (you can also use ScanMode.QR for QR codes only)

    );
    return barcodeScanResult;
  }







  Future<dynamic> fetchDeviceInfo() async {
    PhoneInfo phoneInfos;

    try {
      phoneInfos = await Phoneinformations.getPhoneInformation();
      model = phoneInfos.model;
      name = phoneInfos.brand;

      id = phoneInfos.id;
      deviceDetails.add(id);
      // deviceDetails.add(model);
      // deviceDetails.add(name);
      return deviceDetails;
    } catch (e) {
      return alertDialogue(message: e,);
    }
  }

  Future <dynamic> fetchLocation() async {
    final userLoc = userLocation();

    try{
      location = await userLoc.updatePosition();
    }
    catch(e){
      return alertDialogue(message: e);
    }
  }


  Future <dynamic> fetchTime() async {
    final userLoc = userLocation();

    try{
      time = await userLoc.getCurrentTime();
    }
    catch(e){
      return alertDialogue(message: e);
    }
  }



}



class DatabaseHelper {

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  List <ScanDetail> scanList=[];

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await openDatabase('scancode.db');
    return _database;
  }

  Future<dynamic> createUserTable() async {
    var db= await database;
    await db?.execute('''
    CREATE TABLE IF NOT EXISTS user (
      id INTEGER PRIMARY KEY,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      email TEXT NOT NULL ,
      deviceID TEXT NOT NULL UNIQUE
    )
  ''');


  }






  Future<int> scanExists(String scanData) async {
    final db = await database;
    final List<Map<String, dynamic>> scan = await db!.query(
      'scan',
      where: 'scanData = ?',
      whereArgs: [scanData],
    );
    return scan.length;
  }


  Future<int> userExists(String deviceID) async {
    final db = await database;
    final List<Map<String, dynamic>> user = await db!.query(
      'user',
      where: 'deviceID = ?',
      whereArgs: [deviceID],
    );
    return user.length;
  }

  Future<dynamic> createScansTable() async {
    var db= await database;
    await db?.execute('''
    CREATE TABLE IF NOT EXISTS scan (
      id INTEGER PRIMARY KEY,
      scanData TEXT NOT NULL UNIQUE,
      district TEXT NOT NULL,
      city TEXT NOT NULL ,
      time TEXT NOT NULL ,
      date TEXT NOT NULL ,
      deviceID TEXT NOT NULL 
    )
  ''');


  }
  Future<void> insertScan( String scanData, String district, String city,String time,String date,String deviceID  ) async {
    var db=await database;
    await db?.insert(
      'scan',
      {
        'scanData': scanData,
        'district': district,
        'city': city,
        'time':time?[0],
        'date':date,
        'deviceID':deviceID,

      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<ScanDetail>> getScans() async {
    final db = await database;
    List<Map<String,dynamic>> scans = await db!.query('scan');
    for(var i=0;i<scans.length;i++){

      scanList.add(ScanDetail.fromMap(scans[i]));
    }
    return scanList;
  }

  Future<void> insertUser( String firstName, String lastName, String email,String deviceID  ) async {
    var db=await database;
    await db?.insert(
      'user',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'deviceID':deviceID,

      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }




  Future<User> getUser(String deviceID) async {

    final db = await database;
    List<Map<String, dynamic>> user = await db!.query('user',where: 'deviceID = ?',whereArgs: [deviceID]);
    if (user.isEmpty) {
      throw Exception('No user found with deviceID: $deviceID');
    }
    Map<String, dynamic> userMap = user.first;
    return User.fromMap(userMap);
  }

}




class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String deviceID;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.deviceID,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      deviceID: json['deviceID'],
    );
  }
}




class ScanDetail {
  final int id;
  final String scanData;
  final String district;
  final String city;
  final String time;
  final String date;
  final String deviceID;


  ScanDetail({
    required this.id,
    required this.scanData,
    required this.district,
    required this.city,
    required this.time,
    required this.date,
    required this.deviceID,
  });

  factory ScanDetail.fromMap(Map<String, dynamic> json) {
    return ScanDetail(
      id: json['id'],
      scanData: json['scanData'],
      district: json['district'],
      city: json['city'],
      time: json['time'],
      date: json['date'],
      deviceID: json['deviceID'],
    );
  }
}

