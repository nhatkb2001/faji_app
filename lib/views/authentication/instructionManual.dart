import 'dart:async';

import 'package:faji_app/views/authentication/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import constants
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/constants/fonts.dart';
import 'package:faji_app/constants/others.dart';
import 'package:iconsax/iconsax.dart';

class instructionManualScreen extends StatefulWidget {
  const instructionManualScreen({Key? key}) : super(key: key);
  @override
  _instructionManualScreen createState() => _instructionManualScreen();
}

class _instructionManualScreen extends State<instructionManualScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Container(
            width: 375 + 24,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(instructionManualBackground),
                  fit: BoxFit.cover),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(height: 32 + 44),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Instruction Manual',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 375,
                    child: Text(
                      'To be able to recover your password now, please follow these steps with us:',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black),
                    ),
                  ),
                  Container(
                    width: 327 + 24,
                    child: Divider(
                      color: gray,
                      thickness: 0.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Step 1: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Entering your registered email in the textfield.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Step 2: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Pressing the',
                        ),
                        TextSpan(
                          text: ' Send',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' button to recover the password',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Step 3: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Accessing email address you’ve used to register and check the',
                        ),
                        TextSpan(
                          text: ' OTP code',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' has been sent!',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Step 4: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' Entering the ',
                        ),
                        TextSpan(
                          text: ' OTP code',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' new password and authentication of login password ',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 64),
                  Container(
                    width: 327 + 24,
                    child: Divider(
                      color: gray,
                      thickness: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 185,
                    alignment: Alignment.center,
                    child: Text(
                      'For any questions or problems please email us at',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: black,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: 185,
                    alignment: Alignment.center,
                    child: Text(
                      'HelpFaji@gmail.com',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 64),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 327 + 24,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: black,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Understand",
                          style: TextStyle(
                            color: white,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
