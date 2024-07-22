import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../widgets/scannerResources.dart';
import '../../widgets/tools.dart';
class MyDashboard extends StatefulWidget {
  var useFirstname;

  var useLastname;

  var email;

  var deviceID;

  MyDashboard({super.key, required this.useFirstname,required this.useLastname,required this.email,required this.deviceID});


  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  scanner hello=scanner();

  var dbHelper=DatabaseHelper.instance;
  bool isLoading=true;
     List <ScanDetail>scanList=[];
  @override
  void initState()  {
    super.initState();
    dbHelper.database;
    dbHelper.getScans().then((scans) {

      setState(() {

        scanList = scans;

        isLoading = false;

      });

    });

    // scanList= [...hello];
    // .then((database) {
    //   dbHelper.createUserTable();
    // });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
         isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerHeight = screenHeight * 0.28;
    List? location ;
    List? time ;
    



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text(
          'Skani Ushinde',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontFamily: 'Jersey25-Regular',
          ),
        ),
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6))),
        elevation: 4,
        // Add an elevated shadow for a more distinct top bar effect

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () async {
          List<String> details = await hello.fetchDeviceInfo();
          String? result = await hello.triggerScanner();
          List? location = await hello.fetchLocation();
          List? time = await hello.fetchTime();

          if (await dbHelper.scanExists(result!) != 0) {
            // Existing scan message
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: "Sorry you have already scanned that qrcode / barcode");
              },
            );
          } else {
            // New scan processing
            await dbHelper.insertScan(
                result, location?[0], location?[1], time?[0], time?[1], details[0]);

            // Update scanList and UI
            setState(() async {
              scanList = await dbHelper.getScans();
              print(scanList);
            });

            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertDialogue(message: "Congratulations you have increased your chance to win ");
              },
            );
          }
        },

        child: const Column(
          children: [
            SizedBox(height: 10),
            Icon(Icons.camera, color: Colors.white),
            Text('Scan', style: TextStyle(color: Colors.white, fontFamily: 'Jersey25-Regular')),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.all(5),
            child: FlipCard(
              autoFlipDuration: const Duration(seconds: 1),
              fill: Fill.fillFront,
              side: CardSide.BACK,
              direction: FlipDirection.HORIZONTAL,
              front: Container(
                padding: const EdgeInsets.all(5),
                child: Container(
                  height: containerHeight,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      topLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                    color: Colors.black,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green,

                        Colors.grey[850]!.withOpacity(0.8), // Very low opacity
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05), // Very low opacity
                        blurRadius: 1.0,
                        spreadRadius: 0.5,
                      )
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1), // Very low opacity
                      width: 3.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add a section for a security element (optional)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Connecting Brands & Consumers',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Jersey25-Regular',
                              ),
                            ),
                            // Add a placeholder widget for your chosen security element (e.g., QR code, hologram)
                            Icon(Icons.qr_code_2, color: Colors.grey, size: 60,),
                          ],
                        ),

                        // User profile section
                        Row(
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),

                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: const Image(
                                  image: AssetImage('assets/icons/user.png'),
                                  height: 300,
                                  width: 300,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    'Name: ${widget.useFirstname} ${widget.useLastname}',
                                    style:  TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Jersey25-Regular',
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.grey[200],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Email: ${widget.email}',
                                  style: TextStyle(fontSize: 18, color: Colors.grey[200], fontFamily: 'Jersey25-Regular',),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Device ID: ${widget.deviceID}',
                                  style: TextStyle(fontSize: 18, color: Colors.grey[200], fontFamily: 'Jersey25-Regular',),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Add a section for additional user information (optional)
                        // ... (Implement logic to display additional user data if needed)
                      ],
                    ),
                  ),
                ),
              ),
              back: Container(
                padding: const EdgeInsets.all(5),
                child: Container(
                  height: containerHeight,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      topLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                    color: Colors.black,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[850]!.withOpacity(0.8), // Very low opacity
                        Colors.green,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05), // Very low opacity
                        blurRadius: 0.5,
                        spreadRadius: 0.5,
                      )
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1), // Very low opacity
                      width: 3.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 40),
                        Center(
                          child:    Image.asset(
                            'assets/icons/logo.png',
                            width: 85,
                            height: 85,

                          ),
                        ),
                        const Center(
                          child: Text(
                            'Connecting Brands & Consumers',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Jersey25-Regular',
                            ),
                          ),

                        )
                        // Add a section for additional user information (optional)
                        // ... (Implement logic to display additional user data if needed)
                      ],
                    ),
                  ),
                ),
              ),

              onFlip: () {

              },
            ),
          ),
         // const SizedBox(height: 20,),
        Container(
            // padding: const EdgeInsets.only(right: 10,left: 10),
            child: Expanded(
                child:Container(
                  padding: const EdgeInsets.only(right: 20,left: 20),
                  width: double.maxFinite,
                  decoration:  BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),
                  child: scanList.isEmpty?
                  const Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🏆',style: TextStyle(fontSize: 80),),
                      Text('Scan to increase your winning chance ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
                    ],
                  ),)
                  :ListView.builder(
                    scrollDirection: Axis.vertical,
                     itemCount: scanList.length,
                    itemBuilder: (context, index) {
                      return  ListTile(
                        leading: Text(scanList[index].time?? ''),
                        title:Text(scanList[index].scanData?? ''),
                        trailing: Text(scanList[index].city?? ''),
                      );
                    },
                  ),
                )
            ),
          ),
        ],
      ),
    );

  }
  }


