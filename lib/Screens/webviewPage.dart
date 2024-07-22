// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:scancode_viwango/widgets/tools.dart';
import 'package:url_launcher/url_launcher.dart';
class webpage extends StatefulWidget{
  final String urlInput;

  final String jina;


  webpage({Key? key, required this.urlInput, required this.jina}) : super(key: key);


  @override
  State<webpage> createState() => _webpageState();

}


class _webpageState extends State<webpage> {
  bool isLoading=true;

  late InAppWebViewController  inAppWebViewController;

  @override
  void initState() {

    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    // Call the barcode scanner when the page is loaded

  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      // appBar: AppBar(
      //   title:  Text(widget.jina,style: const TextStyle(fontFamily: 'Jersey25-Regular',color: Colors.white),),
      //   backgroundColor: Colors.green[700],
      //   shape:const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomRight: Radius.circular(6),
      //           bottomLeft: Radius.circular(6)
      //       )
      //   ),
      // ),

      body:
      isLoading
          ? const loading()
          :Column(
        children: [
          Expanded(
            child: InAppWebView(
                  initialUrlRequest: URLRequest(
                  allowsCellularAccess: true,
                  allowsConstrainedNetworkAccess: true,
                  allowsExpensiveNetworkAccess: true,

                  url: WebUri.uri(Uri.parse(widget.urlInput))
              ),
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                });
              },
              onWebViewCreated: (InAppWebViewController controller) async {
                inAppWebViewController = controller;
              },

              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request;
                if (uri.toString().contains('whatsapp')) {
                  launchUrl(uri as Uri);
                  return NavigationActionPolicy.CANCEL; // Prevent InAppWebView from loading the URL
                }
                return NavigationActionPolicy.ALLOW; // Allow InAppWebView to load the URL
              },
              // ... other InAppWebView configurations
            ),

            ),


          Container(

            decoration: BoxDecoration(
              color: Colors.green[700],
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 1,
                  spreadRadius: 0.5,
                )
              ],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)),

            ),
            padding: const EdgeInsets.only(left: 50,right: 50),
            // Button positioning (adjust as needed)

            child: Row(
              children: [
                // Reload Button


                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                  onPressed: () => inAppWebViewController.goBack(),
                ),
                const SizedBox(width: 80.0),
                // Forward Button
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                  onPressed: () => inAppWebViewController.goForward(),
                ),
                const SizedBox(width: 80.0),
                IconButton(
                  icon: const Icon(Icons.refresh_sharp,color: Colors.white,),
                  onPressed: () => inAppWebViewController.reload(),
                ),
              ],
            ),
          ),

        ]

      ),




    );

  }
}
