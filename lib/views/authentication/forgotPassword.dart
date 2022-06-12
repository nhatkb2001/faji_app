import 'dart:async';

import 'package:faji_app/views/authentication/instructionManual.dart';
import 'package:faji_app/views/authentication/signIn.dart';
import 'package:faji_app/views/authentication/verificationEmail.dart';
import 'package:faji_app/views/authentication/verificationPhone.dart';
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

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({Key? key}) : super(key: key);
  @override
  _forgotPasswordScreen createState() => _forgotPasswordScreen();
}

class _forgotPasswordScreen extends State<forgotPasswordScreen> {
  TextEditingController emailOrNumberController = TextEditingController();
  final GlobalKey<FormState> emailOrNumberFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(forgotPasswordBackground),
                    fit: BoxFit.cover),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    SizedBox(height: 32 + 44),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => instructionManualScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Icon(Iconsax.story, size: 24, color: black),
                      ),
                    ),
                    SizedBox(height: 42),
                    Container(
                      alignment: Alignment.center,
                      child: Image(
                          image:
                              AssetImage("assets/vectors/vectorLogoFerce.png")),
                    ),
                    SizedBox(height: 82),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Forgot Password!',
                        style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 327 + 24,
                      alignment: Alignment.center,
                      child: Text(
                        'Please enter the email address associated with your account. We will email you a link have OTP code to reset your password.',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email / Phone Number',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Form(
                      // key: emailFormKey,
                      child: Container(
                        width: 327 + 24,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: gray,
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w400),
                            controller: emailOrNumberController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: [AutofillHints.email],
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 20, right: 12),
                              hintStyle: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: black.withOpacity(0.5)),
                              hintText: "Enter your email or your phone number",
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.transparent,
                                fontSize: 0,
                                height: 0,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(height: 27.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => instructionManualScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Instruction Manual',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 27.5),
                    GestureDetector(
                      onTap: () {
                        late bool emailValid = RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(emailOrNumberController.text.toString());
                        if (emailValid == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      verificationEmailScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      verificationPhoneScreen()));
                        }
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
                            "Send",
                            style: TextStyle(
                              color: white,
                              fontFamily: 'Urbanist',
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
              )),
        ));
  }
}
