import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scancode_viwango/Screens/webviewPage.dart';
import 'package:share/share.dart';
import '../widgets/scannerResources.dart';
import '../widgets/tools.dart';
import 'barcodeNoBottomSheet.dart';
class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}


class _mainScreenState extends State<mainScreen> {

  Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  var qrcode ;
  var fileName;
  var scannedData;
  bool isLoading=true;
  var file;
  var details;
  var scanResult;
  String title='e-Viwango';

  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<dynamic> searchProduct(String Data) async {
    final barcode =Data;


    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            'https://emarket.scancode.co.tz/api/search-by-qrcode?barcode=$barcode'),
      );





      print('Hello juan');
      if (response.statusCode == 200) {

        print('${response.statusCode} hello');
        final productData = json.decode(response.body);

        var productData2=productData[0];

        if (kDebugMode) {
          print(productData2);
        }


        // print('$image hello');
        setState(() {
          isLoading = false;
        });

        if(productData2==null)
        {
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: 'sorry our application could not recognize the product',);
              });
        }
        else{
          var image = productData2['product_image'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return barcodeScreen(productData2: productData2, image: image, isLoading: isLoading);
              },
            ),
          );

        }
      } else if (response.statusCode == 500) {
        print('${response.statusCode} hello');
        setState(() {
          isLoading = false;
        });


        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialogue(message: 'Internal server error please try again later');
            });
      } else {
        print('${response.statusCode} hello');

        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialogue(message: 'Sorry there is a failure to lookup the product',);
            });
      }
    }
    catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialogue(message: "please try again later, the server is unreachable");
        },
      );



    }
  }
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.9;
    return  Scaffold(
      backgroundColor: Colors.green[700],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed:(){
          Share.share('https://play.google.com/store/apps/details?id=com.scancodetz.scancode', subject: 'ScanCode Viwango');
        },
        child: const Icon(Icons.share,color: Colors.white,),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              padding: const EdgeInsets.only(bottom: 10,left: 0,top: 50,right: 0),
              child:  Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children:  [
                  Row(
                    children: [
                      const SizedBox(width: 15,),
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 85,
                        height: 85,

                      ),
                      const Text('''Connecting Brands 
& Consumers''',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Jersey25-Regular'),)
                    ],
                  ),
                  const SizedBox(height: 60,),

                     Container(
                       width: MediaQuery.of(context).size.width,
                    child: const Row(
                              children:[
                                Expanded(
                                  child: Column(
                                    children: [
                                      Icon(Icons.balance,color: Colors.white,size: 35,),
                                      SizedBox(height: 10,),
                                      Text('Regulators',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Jersey25-Regular'),),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 40,),
                                Expanded(
                                  child: Column(
                                    children: [
                                     Icon(Icons.handyman,color: Colors.white,size: 35,),
                                      SizedBox(height: 10,),
                                      Text('Manufacturers',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Jersey25-Regular'),),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 45,),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Icon(Icons.business_center_sharp,color: Colors.white,size: 35,),
                                      SizedBox(height: 10,),
                                      Text('Traders',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Jersey25-Regular'),),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 45,),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Icon(Icons.person_3,color: Colors.white,size: 35,),
                                      SizedBox(height: 10,),
                                      Text('Consumers',style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: 'Jersey25-Regular'),),
                                      SizedBox(width: 40,),
                                    ],
                                  ),
                                ),
                              ]
                    ),
                  ),

                  const SizedBox(height: 20,),
                   Container(
                     padding: const EdgeInsets.only(right: 10),

                     width: MediaQuery.of(context).size.width,
                     child: Row(
                       children: [
                         const SizedBox(width: 18,),
                         Expanded(
                        child: Container(
                          height: 50,
                          width: 180,
                          child:   ElevatedButton(
                              style: const ButtonStyle(
                                  elevation: WidgetStatePropertyAll(2),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.white),
                                  alignment: Alignment.center ,
                                  shape: WidgetStatePropertyAll(
                                      BeveledRectangleBorder(
                                          borderRadius:BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              bottomRight:Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                              topRight: Radius.circular(4)
                                          )
                                      )
                                  )
                              ),
                              onPressed:()  async {

                                if(_isConnected){
                                  scanner cam=scanner();
                                  String? result= await cam.triggerScanner();
                                  if (result != '-1') {
                                    scannedData = result;

                                    if (scannedData.toString().contains('http')) {
                                      if(scannedData.toString().contains('music')){
                                        title='e-Music';
                                      }
                                      else{
                                        title='e-Viwango';
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {

                                            return webpage(urlInput: scannedData, jina: title);
                                          },
                                        ),
                                      );


                                    } else {

                                      _checkConnection();

                                      searchProduct(scannedData);

                                      _checkConnection();

                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertDialogue(message: 'unfortunately our application could not recognize the the barcode or qrcode');
                                        });

                                  }
                                }
                                else{

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialogue(message: 'Please check your internet connection');
                                      });

                                }
                              },
                              child: const Text('Scan',style: TextStyle(color: Colors.black,fontSize:18,fontWeight: FontWeight.bold,fontFamily: 'Jersey25-Regular'),)),
                        ),
                      ),
                      const SizedBox(width: 20,),
                         Expanded(
                        child: Container(
                          height: 50,
                          width: 180,
                          child:  ElevatedButton(

                              style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(2),
                                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                                  shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(4),bottomRight:Radius.circular(4),bottomLeft: Radius.circular(4),topRight: Radius.circular(4) ))) ),
                              onPressed:(){
                                _checkConnection();
                                if(_isConnected){
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const bottomsheetScreen(),
                                );
                              }
                                else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialogue(message: 'Please check your internet connection');
                                      });
                                }
                            }, child: const Text('Extract',style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Jersey25-Regular'),)),
                        ),
                      ),
                       ],
                     ),
                   ),

                ],
              ),
            ),
            Container(
              child: Expanded(
                  child:Container(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              tabsButton(textDisplayed: 'Skani Ushinde',iconName: 'qrcode',functionName: 'skani',),
                              const SizedBox(width: 8,),
                              tabsButton(textDisplayed: 'eViwango',iconName: 'quality-control',functionName: 'viwango',),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              tabsButton(textDisplayed: 'eMarket',iconName: 'cart'
                                  ,functionName: 'market',),
                              const SizedBox(width: 8,),
                              tabsButton(textDisplayed: 'eMusic',iconName: 'playlist',functionName: 'music',),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              tabsButton(textDisplayed: 'eMenu',iconName: 'list',functionName: 'menu',),
                              const SizedBox(width: 8,),
                              tabsButton(textDisplayed: 'Text Extractor',iconName: 'printer', functionName: 'extractor',),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              tabsButton(textDisplayed: 'Scan In',iconName: 'cloud-computing',functionName: 'scan',),
                              const SizedBox(width: 8,),
                              tabsButton(textDisplayed: 'eCard',iconName: 'st-patricks-day',functionName: 'card',),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),

          ]
      ),

    );
  }
}
