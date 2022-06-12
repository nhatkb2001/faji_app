import 'dart:async';

import 'package:ferce_app/views/authentication/instructionManual.dart';
import 'package:ferce_app/views/authentication/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import constants
import 'package:ferce_app/constants/images.dart';
import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/constants/fonts.dart';
import 'package:ferce_app/constants/others.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class verificationEmailScreen extends StatefulWidget {
  const verificationEmailScreen({Key? key}) : super(key: key);
  @override
  _verificationEmailScreen createState() => _verificationEmailScreen();
}

class _verificationEmailScreen extends State<verificationEmailScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;

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
                  image: AssetImage(otpCodeEmailBackground), fit: BoxFit.cover),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(height: 32 + 44),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Verification Account',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 327 + 24,
                    child: Text(
                      'You need to enter OTP Code, new password and authenticate them to mutate!',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 327 + 24,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Form(
                              // key: passwordFormKey,
                              child: Container(
                                width: 275 + 16,
                                height: 44,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: gray,
                                      width: 1,
                                    ),
                                    color: gray),
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        color: white,
                                        fontWeight: FontWeight.w400),
                                    // controller: passwordController,
                                    // obscureText: isHiddenPassword,
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
                                      hintText: "Enter your email",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   isHiddenPassword = !isHiddenPassword;
                                  // });
                                },
                                // child: (isHiddenEmail)
                                //     ?
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Icon(
                                    Iconsax.recovery_convert,
                                    size: 20,
                                    color: white,
                                  ),
                                )
                                // : Container(
                                //     height: 44,
                                //     width: 44,
                                //     decoration: BoxDecoration(
                                //         color: Colors.transparent,
                                //         border:
                                //             Border.all(color: gray, width: 1),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(8))),
                                //     child: Icon(
                                //       Iconsax.eye_slash,
                                //       size: 24,
                                //       color: black,
                                //     ),
                                //   ),
                                )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter OTP Code',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 19),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpInput(_fieldOne, true),
                      OtpInput(_fieldTwo, false),
                      OtpInput(_fieldThree, false),
                      OtpInput(_fieldFour, false)
                    ],
                  ),
                  SizedBox(height: 48),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 327 + 24,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Form(
                              // key: passwordFormKey,
                              child: Container(
                                width: 275 + 16,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: gray,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        color: black,
                                        fontWeight: FontWeight.w400),
                                    // controller: passwordController,
                                    obscureText: isHiddenPassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    autofillHints: [AutofillHints.password],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your password",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHiddenPassword = !isHiddenPassword;
                                });
                              },
                              child: (isHiddenPassword)
                                  ? Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye,
                                        size: 20,
                                        color: white,
                                      ),
                                    )
                                  : Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: gray, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye_slash,
                                        size: 24,
                                        color: black,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 327 + 24,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Form(
                              // key: confirmPasswordFormKey,
                              child: Container(
                                width: 275 + 16,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: gray,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        color: black,
                                        fontWeight: FontWeight.w400),
                                    // controller: confirmPasswordController,
                                    obscureText: isHiddenConfirmPassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    autofillHints: [AutofillHints.password],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your confirm password",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHiddenConfirmPassword =
                                      !isHiddenConfirmPassword;
                                });
                              },
                              child: (isHiddenConfirmPassword)
                                  ? Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye,
                                        size: 20,
                                        color: white,
                                      ),
                                    )
                                  : Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: gray, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye_slash,
                                        size: 24,
                                        color: black,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {},
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
                          "Authenticate",
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
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 327 + 24,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.transparent,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: black,
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
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: gray, width: 1)),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        style: TextStyle(
            color: black,
            fontSize: 18,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
