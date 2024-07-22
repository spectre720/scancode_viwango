import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:scancode_viwango/widgets/tools.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';


class textExtractor extends StatefulWidget {



  @override
  State<textExtractor> createState() => _textExtractorState();
}

class _textExtractorState extends State<textExtractor> {

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
  bool isLoading=true;
  bool isScanned = false;
     late String extractedText="";
    String? imgpath;

  Future<void> _scanText() async {
    extractedText = "";
    setState(() {
      isLoading=true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final text = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'eng');
      setState(() {
        extractedText = text;
        print(text);
        isLoading = false;
      });
    }
    else{
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialogue(message: 'Please upload an image with better quality the app could not extract the text');
          });
    }
  }

  Future<void> _scanTextByUpload() async {

    extractedText = "";
    setState(() {
      isLoading=true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {

      final text = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'eng', args: {'psm': '4'});
      if(text.isNotEmpty){
        setState(() {
          extractedText = text;
          print(text);
          isLoading = false;
        });
      }
      else{
        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialogue(message: 'The image is of low quality');
            });
      }
    }
  }
  Future<void> _saveAsPDF() async {
    print(extractedText);

    if (extractedText.isEmpty) {
      // Handle empty text case (optional: show a message)
      return;
    }

    final pdf = PdfDocument();
    final page = pdf.pages.add();
    final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final bounds = Rect.fromLTWH(10, 10, page.size.width - 20, page.size.height - 20);
    page.graphics.drawString(extractedText, font, bounds: bounds);

    final output = await getDownloadsDirectory();
    if (output == null) {
      print('Error: Unable to access Downloads directory.');
      return;
    }

    String fileName = DateTime.now().toString() + '.pdf';
    final file = File('${output.path}/Scancode document $fileName');

    try {
      await file.writeAsBytes(await pdf.save());
      print('PDF saved to ${file.path}');
    } catch (e) {
      print('Error writing PDF: $e');
    }

    pdf.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.25;
    final double screenWidth = MediaQuery.of(context).size.height;
    final double containerWidth = screenHeight * 0.25;
    return  Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Text Extractor',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[700],
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6))),
      ),
      body:   Expanded(
        child: Center(
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 80,),

                 Image.asset(
                  'assets/icons/logo2-removebg.png',
                  width: 200,
                  height: 200,),


              const SizedBox(height: 20,),
             ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: const WidgetStatePropertyAll(Size.fromWidth(250)),
                      // elevation: MaterialStatePropertyAll(8.0), // More prominent elevation
                      backgroundColor: WidgetStatePropertyAll(Colors.green[700]), // Match app bar color
                      foregroundColor: const WidgetStatePropertyAll(Colors.white), // White text for clear visibility
                      alignment: Alignment.center,

                      shape: WidgetStatePropertyAll(

                        RoundedRectangleBorder(side: const BorderSide(color: Colors.white,width: 2),
                          borderRadius: BorderRadius.circular(25.0), // Rounded corners
                        ),
                      ),
                      minimumSize: const WidgetStatePropertyAll(Size(150.0, 60.0)), // Set fixed button size
                    ),
                    onPressed:() {
                      _scanText().then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Text Extractor',style: TextStyle(fontFamily: 'Jersey25-Regular'),),
                                  backgroundColor: Colors.green[700],
                                  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(4),bottomLeft: Radius.circular(4))),
                                ),
                                body:isLoading
                                    ? const loading(): Center(
                                  child: SingleChildScrollView(
                                    child:
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SelectableText(extractedText),
                                          ElevatedButton(
                                            child: const Text('Save as PDF'),
                                            onPressed: () {
                                              _saveAsPDF();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),)
                              ;
                            },
                          ),
                        );
                      },);

                      },


                    child: const Text('Scan',style: TextStyle(fontSize: 30),)
          ),

              const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: const WidgetStatePropertyAll(Size.fromWidth(250)),
                      // elevation: MaterialStatePropertyAll(8.0), // More prominent elevation
                      backgroundColor: WidgetStatePropertyAll(Colors.green[700]), // Match app bar color
                      foregroundColor: const WidgetStatePropertyAll(Colors.white), // White text for clear visibility
                      alignment: Alignment.center,
                      shape: WidgetStatePropertyAll(

                        RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white,width: 2),
                          borderRadius: BorderRadius.circular(25.0), // Rounded corners
                        ),
                      ),
                      minimumSize: const WidgetStatePropertyAll(Size(150.0, 60.0)), // Set fixed button size
                    ),
                    onPressed:() {
                      _scanTextByUpload().then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Text Extractor',style: TextStyle(fontFamily: 'Jersey25-Regular'),),
                                  backgroundColor: Colors.green[700],
                                  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(4),bottomLeft: Radius.circular(4))),
                                ),
                                body:isLoading
                                    ? const loading()
                                    : Center(
                                  child: SingleChildScrollView(
                                    child: Card(
                                      elevation: 4.0,
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        // height: screenHeight,
                                        // width: screenWidth,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Use RichText for optional text decoration
                                            RichText(
                                              text: TextSpan(
                                                text: extractedText,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'serif',
                                                  color: Colors.black,
                                                  height: 1.5,
                                                   // Example decoration (optional)
                                                  decorationThickness: 1.0, // Adjust thickness (optional)
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                elevation: const WidgetStatePropertyAll(4.0), // More prominent elevation
                                                backgroundColor: const WidgetStatePropertyAll(Color(0xFF388E3C)), // Match app bar color
                                                foregroundColor: const WidgetStatePropertyAll(Colors.white), // White text for clear visibility
                                                alignment: Alignment.center,
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(6.0), // Rounded corners
                                                  ),
                                                ),
                                                minimumSize: const WidgetStatePropertyAll(Size(150.0, 60.0)), // Set fixed button size
                                              ),
                                              child: const Text('Save as PDF',style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontFamily: 'Jersey25-Regular',
                                              ),),
                                              onPressed: () {
                                                _saveAsPDF();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              ;
                            },
                          ),
                        );
                      },);

                    },

                    child: const Text('Upload image',style: TextStyle(fontSize: 30),)),


            ],
          ),
        ),
      ),
    );
  }
}
