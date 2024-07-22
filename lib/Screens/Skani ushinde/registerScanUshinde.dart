import 'package:flutter/material.dart';
import 'package:scancode_viwango/Screens/Skani%20ushinde/skaniUshinde.dart';

import '../../widgets/scannerResources.dart';
import '../../widgets/tools.dart';

class skaniUshindeForm extends StatefulWidget {
  const skaniUshindeForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<skaniUshindeForm> {
  bool isLoading=false;
  var dbHelp=DatabaseHelper.instance;
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  scanner scancode=scanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Skani Ushinde Registration',style: TextStyle(fontFamily: 'Jersey25-Regular',color: Colors.white),),
        backgroundColor: Colors.green[700],
        // elevation: ,
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: <Widget>[

            // Translucent green container
            Column(
              children: [
                const SizedBox(height:100),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[700]!.withOpacity(0.2), // Translucent green
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: <Widget>[

                            Image.asset(
                              'assets/icons/logo2-removebg.png',
                              width: 150,
                              height: 150,

                            ),
                            buildTextFormField(
                              labelText: 'First Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name.';
                                }
                                return null;
                              },
                              onSaved: (value) => setState(() => _firstName = value!),
                            ),
                            const SizedBox(height: 10.0),
                            buildTextFormField(
                              labelText: 'Last Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name.';
                                }
                                return null;
                              },
                              onSaved: (value) => setState(() => _lastName = value!),
                            ),
                            const SizedBox(height: 10.0),
                            buildTextFormField(
                              labelText: 'Email',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email address.';
                                } else if (!RegExp(r"^[a-zA-Z0-9.a-z!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(value)) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) => setState(() => _email = value!),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(

                              onPressed: () async {

                               var details=await scancode.fetchDeviceInfo();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  // Process form data here (e.g., print to console or submit to backend)
                                  print('First Name: $_firstName');
                                  print('Last Name: $_lastName');
                                  print('Email: $_email');
                                  User consumer;
                                  await dbHelp.insertUser(_firstName, _lastName, _email, details[0]).then((value) async{
                                    consumer=await dbHelp.getUser(details[0]);

                                    MaterialPageRoute route =MaterialPageRoute(
                                                builder: (context)
                                            => MyDashboard(
                                                  useFirstname: consumer.firstName,
                                                  useLastname: consumer.lastName,
                                                  email: consumer.email,
                                                  deviceID: consumer.deviceID),);
                                    Navigator.pushReplacement(context, route);
                                        }).then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.celebration,size: 20,),
                                                SizedBox(width: 5,),
                                                Text('Alert'),

                                              ],
                                            ),
                                            content:  const Text('Welcome to the Skani Ushinde platform'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the AlertDialog
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  });


                                      // .then((value) async => consumer=await dbHelp.getUser(details[0]) ).
                              //     then((consumer) => {return MaterialPageRoute(
                              //         builder: (context)
                              //     {
                              //       return MyDashboard(
                              //           useFirstname: consumer.firstName,
                              //           useLastname: consumer.lastName,
                              //           email: consumer.email,
                              //           deviceID: consumer.deviceID);
                              //     },)
                              //   ,
                              // });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(Color(0xFF388E3C)), // Match app bar color
                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                shape: MaterialStatePropertyAll(

                                  RoundedRectangleBorder(side: const BorderSide(color: Colors.white,width: 2),
                                    borderRadius: BorderRadius.circular(25.0), // Rounded corners
                                  ),
                                ),

                              ),
                              child: const Text('Register',style: TextStyle(fontFamily: 'Jersey25-Regular',fontSize: 20),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            // User icon positioned on top left

          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String labelText,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white), // Set label text color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.white, // Set border color to white
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.white, // Set focused border color to white
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.white, // Set enabled border color to white
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
            // Set error border color to red
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red, // Set focused error border color to red
          ),
        ),
      ),
      style: TextStyle(color: Colors.white), // Set text color to white
      validator: validator,
      onSaved: onSaved,
    );
  }
}
