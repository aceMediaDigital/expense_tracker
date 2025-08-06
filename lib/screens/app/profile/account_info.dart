/* =======================================================
 *
 * Created by anele on 31/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfoScreen extends StatefulWidget {
  
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {

  final GlobalKey<FormState> agentProfileFormKey = GlobalKey<FormState>();


  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cellNumberController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    cellNumberController.dispose();
    //whatsAppPlusController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Account Info'),
        backgroundColor: Color(0xFF429690),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                      children: <Widget>[
                        ClipOval(
                            child: Material(
                                child:  Container(
                                  width: 120, height: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Image.asset('assets/images/user-avatar.png', fit: BoxFit.cover,),
                                )
                            )
                        ),

                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              //_showSelectPhotoOptions(context);
                            },
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                //color: Colors.yellow[900],
                                //child: const Icon(Icons.edit, color: Colors.white, size: 20,),
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),

                Form(
                  key: agentProfileFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text('Firstname'),
                        const SizedBox(height: 10),
                        AppInput(
                          obscureText: false,
                          controller: firstNameController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value == null || value.isEmpty ? 'Enter your name ' : null,
                        ),
                        const SizedBox(height: 20,),

                        Text('Lastname'),
                        const SizedBox(height: 10,),
                        AppInput(
                          obscureText: false,
                          controller: lastNameController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value == null || value.isEmpty ? 'Enter surname ' : null,
                        ),
                        const SizedBox(height: 20,),

                        Text('Cell Number'),
                        const SizedBox(height: 10,),
                        AppInput(
                          obscureText: false,
                          controller: cellNumberController,
                          keyboardType: TextInputType.number,
                          validator: (String? value) => value == null || value.isEmpty ? 'Enter phone number ' : null,
                        ),
                        const SizedBox(height: 20,),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: OutlinedButton(
                            onPressed: ()  async {
                              saveProfile();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF429690), width: .5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              //padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              foregroundColor: Colors.blue,
                              //backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text('Save'),
                          ),
                        ),

                        const SizedBox(height: 20,),
                      ]
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  void saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    if ( agentProfileFormKey.currentState!.validate() ) {

      await prefs.setString('firstName', firstNameController.text);
      await prefs.setString('lastName', lastNameController.text);
      await prefs.setString('cellNumber', cellNumberController.text);

      // Show Spinning
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Information saved!')),
      );

      Future.delayed(Duration(seconds: 5), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

    }
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    firstNameController.text = prefs.getString('firstName') ?? '';
    lastNameController.text = prefs.getString('lastName') ?? '';
    cellNumberController.text = prefs.getString('cellNumber') ?? '';
  }

}