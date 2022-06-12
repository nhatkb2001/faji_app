import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:faji_app/firebase/firebaseAuth.dart';
import 'package:faji_app/views/authentication/signIn.dart';
import 'package:faji_app/views/widget/snackBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

class signUpScreen extends StatefulWidget with InputValidationMixin {
  const signUpScreen({Key? key}) : super(key: key);
  @override
  _signUpScreen createState() => _signUpScreen();
}

class _signUpScreen extends State<signUpScreen> with InputValidationMixin {
  bool isSendVerifyCodeEmail = false;
  bool isSendVerifyCodePhone = false;
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isHiddenEmailCode = true;
  bool isHiddenPhoneCode = true;
  bool isChecked = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> confirmPasswordFormKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> phoneNumberFormKey = GlobalKey<FormState>();

  TextEditingController phoneVerificationController = TextEditingController();
  final GlobalKey<FormState> phoneVerificationFormKey = GlobalKey<FormState>();

  TextEditingController emailVerificationController = TextEditingController();
  final GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();

  int _startEmail = 60;
  int _startPhone = 60;

  bool isLoading = false;

  bool _enabledPhone = true;
  bool _enabledEmail = true;

  bool submitValid = false;

  Color notiColorEmail = red;
  Color notiColorName = red;
  Color notiColorPhoneNumber = red;
  Color notiColorPassword = red;

  late Timer _timerEmail;

  void startTimerSendCodeEmail() {
    const oneSec = const Duration(seconds: 1);

    _timerEmail = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startEmail == 0) {
          setState(() {
            timer.cancel();
            isSendVerifyCodeEmail = false;
            _startEmail = 30;
            _enabledEmail = true;
          });
        } else {
          setState(() {
            _startEmail--;
          });
        }
      },
    );
  }

  late Timer _timerPhonenumber;

  void startTimerSendCodePhone() {
    const oneSec = const Duration(seconds: 1);
    _timerPhonenumber = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startPhone == 0) {
          setState(() {
            timer.cancel();
            isSendVerifyCodePhone = false;
            _startPhone = 30;
            _enabledPhone = true;
          });
        } else {
          setState(() {
            _startPhone--;
          });
        }
      },
    );
  }

  late EmailAuth emailAuth;

  void sendOtpEmail() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailController.value.text, otpLength: 4);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }

  bool checkPhone = false;
  late String verificationId;
  Future sendOtpPhone() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (verificationFailed) async {
        showSnackBar(context, verificationFailed.message, 'error');
      },
      codeSent: (verificationId, respendingToken) async {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        setState(() {
          checkPhone = true;
        });
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message, 'error');
    }
  }

  void controlSignUp() {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: phoneVerificationController.value.text);
    signInWithPhoneAuthCredential(phoneAuthCredential);
    bool checkEmail = (emailAuth.validateOtp(
        recipientMail: emailController.value.text,
        userOtp: emailVerificationController.value.text));
    if ((emailAuth.validateOtp(
                recipientMail: emailController.value.text,
                userOtp: emailVerificationController.value.text)) ==
            true &&
        checkPhone == true &&
        emailFormKey.currentState!.validate() &&
        usernameFormKey.currentState!.validate() &&
        // phoneNumberFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate()) {
      registerUser(emailController.text, passwordController.text,
          usernameController.text, phoneNumberController.text, context);
    } else {
      showSnackBar(context, "Please! Check your information!", 'error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "Faji Application",
    );
  }

  @override
  void dispose() {
    _timerPhonenumber.cancel();
    _timerEmail.cancel();
    super.dispose();
  }

  //Create validation

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(signUpBackground), fit: BoxFit.cover),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              color: black,
            ),
            // child: IconButton(icon:Iconsax.refresh_circle, size: 36, color: white),
          ),
          Container(
            margin: EdgeInsets.only(top: 72 + 44, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up!',
                  style: TextStyle(
                      fontFamily: 'Recoleta',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                SizedBox(height: 8),
                Container(
                  width: 327 + 24,
                  child: Text(
                    'Only one step left to be part of the Faji' +
                        's World community!',
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 72 + 44 + 32 + 8 + 32 + 7 + 32),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Container(
                  margin: EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      // SizedBox(height: 32),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 65,
                              child: Divider(
                                color: gray,
                                thickness: 0.5,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "personal information",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                color: gray,
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: 65,
                              child: Divider(
                                color: gray,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 327 + 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Form(
                                  key: emailFormKey,
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
                                        //validator
                                        validator: (email) {
                                          if (isEmailValid(email.toString())) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorEmail = green;
                                              });
                                            });
                                            return null;
                                          } else {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorEmail = red;
                                              });
                                            });
                                            return '';
                                          }
                                        },
                                        controller: emailController,
                                        autofillHints: [AutofillHints.email],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 12),
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
                                  onTap: (_enabledEmail)
                                      ? () {
                                          setState(() {
                                            isSendVerifyCodeEmail =
                                                !isSendVerifyCodeEmail;
                                            startTimerSendCodeEmail();
                                            _enabledEmail = false;
                                            sendOtpEmail();
                                          });
                                        }
                                      : null,
                                  child: (isSendVerifyCodeEmail == false)
                                      ? Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Icon(
                                            Iconsax.scan,
                                            size: 20,
                                            color: white,
                                          ),
                                        )
                                      : Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text('$_startEmail',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Urbanist',
                                                    color: white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                )
                              ],
                            ),
                            SizedBox(height: 24),
                            Container(
                              child: Text(
                                'User name',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 8),
                            Form(
                              key: usernameFormKey,
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
                                    //validator
                                    validator: (name) {
                                      if (isNameValid(name.toString())) {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            notiColorName = green;
                                          });
                                        });
                                        return null;
                                      } else {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            notiColorName = red;
                                          });
                                        });
                                        return '';
                                      }
                                    },
                                    controller: usernameController,
                                    keyboardType: TextInputType.name,
                                    autofillHints: [AutofillHints.name],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your user name",
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
                            SizedBox(height: 24),
                            Text(
                              "Phone number",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Form(
                                  key: phoneNumberFormKey,
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
                                        validator: (phoneNumber) {
                                          if (isPhoneNumberValid(
                                              phoneNumber.toString())) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorPhoneNumber = green;
                                              });
                                            });
                                            return null;
                                          } else {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorPhoneNumber = red;
                                              });
                                            });
                                            return '';
                                          }
                                        },
                                        controller: phoneNumberController,
                                        autofillHints: [
                                          AutofillHints.telephoneNumber
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 12),
                                          hintStyle: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: black.withOpacity(0.5)),
                                          hintText: "Enter your phone number",
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
                                  onTap: (_enabledPhone)
                                      ? () {
                                          setState(() {
                                            _enabledPhone = false;
                                            isSendVerifyCodePhone =
                                                !isSendVerifyCodePhone;
                                            startTimerSendCodePhone();
                                            sendOtpPhone();
                                          });
                                        }
                                      : null,
                                  child: (isSendVerifyCodePhone == false)
                                      ? Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Icon(
                                            Iconsax.scan,
                                            size: 20,
                                            color: white,
                                          ),
                                        )
                                      : Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text('$_startPhone',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Urbanist',
                                                    color: white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                )
                              ],
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
                                        key: passwordFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              validator: (password) {
                                                if (isPasswordValid(
                                                    password.toString())) {
                                                  WidgetsBinding.instance!
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      notiColorPassword = green;
                                                    });
                                                  });
                                                  return null;
                                                } else {
                                                  WidgetsBinding.instance!
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      notiColorPassword = red;
                                                    });
                                                  });
                                                  return '';
                                                }
                                              },
                                              controller: passwordController,
                                              obscureText: isHiddenPassword,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText: "Enter your password",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            isHiddenPassword =
                                                !isHiddenPassword;
                                          });
                                        },
                                        child: (isHiddenPassword)
                                            ? Container(
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                    color: black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                        key: confirmPasswordFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              controller:
                                                  confirmPasswordController,
                                              obscureText:
                                                  isHiddenConfirmPassword,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText:
                                                    "Enter your confirm password",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "authentication",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      color: gray,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              alignment: Alignment.topLeft,
                              width: 327 + 24,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Email Verification',
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
                                        key: emailVerificationFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              controller:
                                                  emailVerificationController,
                                              obscureText: isHiddenEmailCode,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText:
                                                    "Enter your email code verification",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            isHiddenEmailCode =
                                                !isHiddenEmailCode;
                                          });
                                        },
                                        child: (isHiddenEmailCode)
                                            ? Container(
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                    color: black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                      'Phone Number Verificatiion',
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
                                        key: phoneVerificationFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              controller:
                                                  phoneVerificationController,
                                              obscureText: isHiddenPhoneCode,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText:
                                                    "Enter your phone code verification",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            isHiddenPhoneCode =
                                                !isHiddenPhoneCode;
                                          });
                                        },
                                        child: (isHiddenPhoneCode)
                                            ? Container(
                                                height: 44,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                    color: black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      height: 16,
                                      width: 16,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: isChecked
                                            ? black
                                            : Colors.transparent,
                                        border:
                                            Border.all(color: gray, width: 1),
                                      ),
                                      child: isChecked
                                          ? Icon(
                                              Icons.check,
                                              color: white,
                                              size: 12,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Agree to ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Terms & Conditions",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: black,
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: black,
                              ),
                              child: ElevatedButton(
                                //action navigate to dashboard screen
                                onPressed: () async {
                                  if (isLoading) return;
                                  setState(() {
                                    isLoading = true;
                                    controlSignUp();
                                  });
                                  await Future.delayed(Duration(seconds: 3));
                                  if (this.mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: black,
                                    onPrimary: Colors.white,
                                    shadowColor: black.withOpacity(0.25),
                                    elevation: 15,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    // maximumSize: Size.fromWidth(200),
                                    minimumSize: Size(327 + 24, 44),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(16.0)),
                                    // BorderRadius.all(Radius.circular(16)),
                                    textStyle: TextStyle(
                                        color: white,
                                        fontFamily: 'SFProText',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                child: isLoading
                                    ? Container(
                                        height: 48,
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: white)),
                                            const SizedBox(width: 16),
                                            Text(
                                              "Please Wait...",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "or continue with",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      color: gray,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              width: 327 + 24,
                              height: 44,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Container(
                                    width: 156,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(width: 1.5, color: gray),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/vectors/vectorFacebook.png',
                                            width: 16.0,
                                            height: 16.0,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Facebook',
                                          style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 156,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(width: 1.5, color: gray),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/vectors/vectorGoogle.png',
                                            width: 16.0,
                                            height: 16.0,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Google',
                                          style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'To be able to register, you must agree to our',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: gray),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Terms of Use',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                ),
                                Text(
                                  ' and',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: gray),
                                ),
                                Text(
                                  ' Privacy Policy',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                ),
                              ],
                            ),
                            SizedBox(height: 67 + 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isEmailValid(String email) {
    RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  bool isNameValid(String name) => name.length >= 3;

  bool isPasswordValid(String password) => password.length >= 6;

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = new RegExp(r'(^(?:[+84])?[0-9]{10,12}$)');
    return regex.hasMatch(phoneNumber);
  }
}
