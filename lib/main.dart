import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:scancode_viwango/widgets/scannerResources.dart';
import 'Screens/landingScreen.dart';

Future<void> initializeInAppWebView() async {
  // Call the new static method for initialization (assuming latest version)
  await InAppWebView.fromPlatform(platform: PlatformInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams()));
}
var dbHelp=DatabaseHelper.instance;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dbHelp.database.then((database) {
    dbHelp.createUserTable();
    dbHelp.createScansTable();

  }).then((value) {
     initializeInAppWebView();
  });
  runApp(const scancodeApp());
}


class scancodeApp extends StatelessWidget {
  const scancodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: mainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


