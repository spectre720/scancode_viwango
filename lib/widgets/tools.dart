import 'dart:convert';

import '../Screens/Skani ushinde/registerScanUshinde.dart';
import 'scannerResources.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

import '../Screens/Skani ushinde/skaniUshinde.dart';
import '../Screens/Text Extractor/textExtractor.dart';
import '../Screens/webviewPage.dart';
import 'package:http/http.dart' as http;
class barcodeScreen extends StatelessWidget {
  Map productData2;

  var image;

  bool isLoading;

   barcodeScreen({super.key,required this.productData2,required this.image,required this.isLoading});



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('eViwango',style: TextStyle(fontFamily: 'Jersey25-Regular'),),
        backgroundColor: Colors.green[700],
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(4),bottomLeft: Radius.circular(4))),
      ),
      body:  isLoading
          ? const loading()
          :SingleChildScrollView(
        child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Image.network(
                    'https://emarket.scancode.co.tz/bronchures/$image',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(''), // Empty label for cleaner design
                    ),
                    DataColumn(
                      label: Text(''), // Empty label for cleaner design
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Product Name:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800], // Adjust text color for better contrast
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            productData2['product_name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Category:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            productData2['category'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    // ... other DataRow entries
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Address:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            productData2['address'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Status:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.check_circle_outline, color: Colors.green[700]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  dataRowHeight: 60.0, // Adjust row height for better readability
                  columnSpacing: 16.0, // Adjust spacing between columns for aesthetics

                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green[700], // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Border radius
                    ),
                    elevation: 8.0, // Elevation
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Button padding
                    shadowColor: Colors.black, // Shadow color
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed:(){
                    var identity=productData2['identity'];
                    if (kDebugMode) {
                      print(identity);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {

                          return webpage(urlInput: 'https://emarket.scancode.co.tz/m/$identity', jina: 'eViwango',);
                        },
                      ),
                    );
                  },
                  child:
                  const Text(
                    'Discover More',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                )
              ],
            )
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('image', image));
  }
}

class alertDialogue extends StatelessWidget {
  var message;

   alertDialogue({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning,size: 20,color: Colors.red,),
          SizedBox(width: 5,),
          Text('Alert'),

        ],
      ),
      content:  Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the AlertDialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
class loading extends StatelessWidget {
  const loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        child: Column(
          children: [
            CircularProgressIndicator(
                backgroundColor: Colors.green[700],
                color: Colors.white),
            const SizedBox(height: 10,),
            const Text('Loading', style: TextStyle(
                fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    ) ;
  }
}

class tabsButton extends StatefulWidget {
   tabsButton({super.key,required this.textDisplayed,required this.iconName,required this.functionName});
   String? textDisplayed;
   String? iconName;
   String functionName;
   var scannedData;

  @override
  State<tabsButton> createState() => _tabsButtonState();
}

class _tabsButtonState extends State<tabsButton> {

  Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  var qrcode ;
  var fileName;
  bool isLoading=true;
  var file;
  var details;
  var scanResult;
  String title='e-Viwango';
  var dbHelp=DatabaseHelper.instance;

  scanner scancode=scanner();
  void _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();


    _checkConnection();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  String? selectedImagePath;
  void initState() {
    super.initState();
    dbHelp.database;
    // .then((database) {
    //   dbHelp.createUserTable();
    // });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
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
          print('hug ${productData2}');


          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: 'sorry our application could not recognize the product',);
              });
        }
        else{

            print('hug ${productData2}');

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
  Future<String?> getImage() async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {

      setState(()  {
        selectedImagePath = pickedFile.path;
      }
      );
    }
    return selectedImagePath;
  }
  void perform() async {
    final pickedImage = await getImage();
    if (pickedImage != null) {
      scanImport(pickedImage);
    }
  }
  scanImport(String pathFromGallery) async {
    var str = await Scan.parse(selectedImagePath!);
    if (str != null) {
      setState(() {
        qrcode = str;
      });


      if(qrcode != '-1'){
        if (qrcode.toString().contains('http')) {
          print('hell $qrcode');
          if(qrcode.toString().contains('music')){
            title='e-Music';
          }
          else{
            title='e-Viwango';
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return webpage(urlInput: qrcode, jina: 'eViwango',);
              },
            ),
          );


        } else{
          print('hell0 $qrcode');
          searchProduct(qrcode);

        }}
      else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              if (kDebugMode) {
                print('amani $qrcode');
              }
              return alertDialogue(message: 'Sorry unfortunately our app couldnt recognize the product');
            });
      }

    }
    else{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialogue(message: 'sorry unfortunately our app couldnt recognize the image uploaded');
          });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
    height: 120,
    child:  ElevatedButton(
    style: const ButtonStyle(
    elevation: MaterialStatePropertyAll(2),
    backgroundColor: MaterialStatePropertyAll(Colors.white),
    alignment: Alignment.center ,
    shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius:BorderRadius.only(
    topLeft: Radius.circular(2),
    topRight: Radius.circular(2),
    bottomLeft: Radius.circular(2),
    bottomRight: Radius.circular(2)
    )
    )
    )
    ),
    onPressed:() async {
      if(widget.functionName=='skani'){
        List<String> details=await scancode.fetchDeviceInfo();

        print(details);
        if (widget.functionName == 'skani') {
          if(await dbHelp.userExists(details[0])!=0){
            var  user=await dbHelp.getUser(details[0]).then((user) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  MyDashboard(email: user.email,useFirstname: user.firstName,useLastname: user.lastName,deviceID: user.deviceID,)),
            ),);

                  }
          else{
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  skaniUshindeForm(),
              ),
            );
          }
                }
      }
      else if(widget.functionName=='viwango') {
        _checkConnection();

        if(_isConnected){

          String? result= await scancode.triggerScanner();
          if (result != '-1') {



            // Process the scanned data, e.g., display it on the same page

            widget.scannedData = result;




            if (widget.scannedData.toString().contains('http')) {
              if(widget.scannedData.toString().contains('music')){
                title='e-Music';
              }
              else{
                title='e-Viwango';
              }






              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {

                    return webpage(urlInput: widget.scannedData, jina: title);
                  },
                ),
              );


            } else {



              searchProduct(widget.scannedData);



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

      }
      else if(widget.functionName=='market'){
        _checkConnection();
        if(_isConnected){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => webpage(
                              urlInput: 'https://emarket.scancode.co.tz/',
                              jina: 'eMarketing',
                            )),
                  );
                }
        else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: 'Please check your internet connection');
              });
        }
              }
      else if(widget.functionName=='music'){

        if(_isConnected){
          scanner cam=scanner();
          String? result= await cam.triggerScanner();
          if (result != '-1') {



            // Process the scanned data, e.g., display it on the same page

            widget.scannedData = result;




            if (widget.scannedData.toString().contains('http')) {
              if(widget.scannedData.toString().contains('music')){
                title='e-Music';
              }
              else{
                title='e-Viwango';
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {

                    return webpage(urlInput: widget.scannedData, jina: title);
                  },
                ),
              );


            } else {



              searchProduct(widget.scannedData);



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
      }
      else if(widget.functionName=='menu'){
        null;
      }
      else if(widget.functionName=='extractor'){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => textExtractor(),
        ));

      }
      else if(widget.functionName=='scan'){
        perform();
      }
      else if(widget.functionName=='card'){
        _checkConnection();
        if(_isConnected){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => webpage(
                              urlInput: 'https://emarket.scancode.co.tz/',
                              jina: 'eCard',
                            )),
                  );
                }
        else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: 'Please check your internet connection');
              });
        }
              }
      else{
        null;
      }




    },
    child: Column(
      children: [
        const SizedBox(height: 15,),
        Image.asset(
          'assets/icons/${widget.iconName}.png',
          width: 65,
          height: 65,

        ),
        Text(
                  '${widget.textDisplayed}',style: const TextStyle(color: Colors.black,fontFamily: 'Jersey25-Regular',fontSize: 18),),
      ],
    )),
),
    );
  }
}
