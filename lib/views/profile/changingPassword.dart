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

class changingPasswordScreen extends StatefulWidget {
  const changingPasswordScreen({Key? key}) : super(key: key);
  @override
  _changingPasswordScreen createState() => _changingPasswordScreen();
}

class _changingPasswordScreen extends State<changingPasswordScreen> {
  bool isHiddenCurrentPassword = true;
  bool isHiddenNewPassword = true;
  bool isHiddenConfirmPassword = true;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

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
                image: AssetImage(changingPasswordBackground),
                fit: BoxFit.cover),
          ),
          child: Container(
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                SizedBox(height: 20 + 44),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Iconsax.back_square, size: 28),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print('Menu');
                      },
                      child: Icon(Iconsax.menu_14, size: 28),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Changing Password',
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
                    'Your new password must be different from the current password and ensure the safety of password.',
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: black),
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  alignment: Alignment.topLeft,
                  width: 327 + 24,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Current Password',
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
                                  controller: currentPasswordController,
                                  obscureText: isHiddenCurrentPassword,
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
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenCurrentPassword =
                                    !isHiddenCurrentPassword;
                              });
                            },
                            child: (isHiddenCurrentPassword)
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
                          'New Password',
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
                                  controller: newPasswordController,
                                  obscureText: isHiddenNewPassword,
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
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenNewPassword = !isHiddenNewPassword;
                              });
                            },
                            child: (isHiddenNewPassword)
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
                          'Confirm New Password',
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
                                  controller: confirmNewPasswordController,
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
                              "Change",
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
                          currentPasswordController.text = '';
                          newPasswordController.text = '';
                          confirmNewPasswordController.text = '';
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
                              "Reset",
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
                ),
              ],
            ),
          ),
        )));
  }
}
