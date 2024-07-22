// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scancode_viwango/Screens/webviewPage.dart';
import '../widgets/tools.dart';
class bottomsheetScreen extends StatefulWidget {
  const bottomsheetScreen({super.key});

  @override
  State<bottomsheetScreen> createState() => _bottomsheetScreenState();
}

class _bottomsheetScreenState extends State<bottomsheetScreen> {
  var qrcode ;
  var fileName;
  bool isLoading=true;

  var file;
  var details;
  var scanResult;
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  Future<dynamic> searchProduct(String Data) async {
    if(!Data.isEmpty){
      final barcode = Data;


    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            'https://emarket.scancode.co.tz/api/search-by-qrcode?barcode=$barcode'),
      );


      if (kDebugMode) {
        print('Hello juan');
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('${response.statusCode} hello');
        }
        final productData = json.decode(response.body);

        var productData2 = productData[0];
        if (kDebugMode) {
          print(productData2);
        }




        if (productData2 == null) {
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return isLoading
                    ? loading():
                alertDialogue(message: 'sorry our application could not recognize the product');
              });
        }
        else {
          var image = productData2['product_image'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('eViwango',
                      style: TextStyle(fontFamily: 'Jersey25-Regular'),),
                    backgroundColor: Colors.green[700],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4))),
                  ),
                  body: isLoading
                      ? loading() : SingleChildScrollView(
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
                                  label: Text(
                                      ''), // Empty label for cleaner design
                                ),
                                DataColumn(
                                  label: Text(
                                      ''), // Empty label for cleaner design
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
                                          color: Colors
                                              .grey[800], // Adjust text color for better contrast
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Icon(Icons.check_circle_outline,
                                              color: Colors.green[700]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              dataRowHeight: 60.0,
                              // Adjust row height for better readability
                              columnSpacing: 16.0, // Adjust spacing between columns for aesthetics

                            ),
                            const SizedBox(height: 10,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[700],
                                // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Border radius
                                ),
                                elevation: 8.0,
                                // Elevation
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                // Button padding
                                shadowColor: Colors.black,
                                // Shadow color
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                var identity = productData2['identity'];
                                if (kDebugMode) {
                                  print(identity);
                                }


// JavaScript function to be called when the data is received.


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return webpage(
                                        urlInput: 'https://emarket.scancode.co.tz/m/$identity',
                                        jina: 'eViwango',);
                                    },
                                  ),
                                );
                              },
                              child:
                                  Text(
                                    'Discover More',
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),),

                              )
                          ],
                        )
                    ),
                  ),
                );
              },
            ),
          );
        }
      } else if (response.statusCode == 500) {
        if (kDebugMode) {
          print('${response.statusCode} hello');
        }
        setState(() {
          isLoading = false;
        });


        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return isLoading
                  ? loading():alertDialogue(
                  message: 'Internal server error please try again later');
            });
      } else {
        if (kDebugMode) {
          print('${response.statusCode} hello');
        }

        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return isLoading
                  ? loading():alertDialogue(
                  message: 'Sorry there is a failure to lookup the product');
            });
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return isLoading
              ? loading():alertDialogue(
              message: "please try again later, the server is unreachable");
        },
      );
    }
  }
    else{
      setState(() {
        isLoading = false;
      });
      return isLoading
          ? loading():showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialogue(
                message: 'Please enter the Barcode Number');
          });
    }
  }
  // final Function taskTittleAdd;
  TextEditingController barcode=TextEditingController();
  @override
  Widget build(BuildContext context) {
    // String? newTaskTitle;
    return  Container(

      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Text('Enter Barcode Number:',textAlign: TextAlign.center,style: TextStyle(color: Colors.green[700],fontSize: 20,fontWeight: FontWeight.bold),),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.barcode_reader,color: Colors.green[700],size: 35,),
              ),
              keyboardType: TextInputType.number,
              controller: barcode,

              autofocus: true,
              onChanged: (newText){
                // newTaskTitle=newText;
              },
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green[700]),alignment: Alignment.center ,),
                onPressed:(){
                  searchProduct(barcode.text);
                },
                child: const Text('Extract',style: TextStyle(color: Colors.black),)),

          ],
        ),
      ),


    );
  }
}
