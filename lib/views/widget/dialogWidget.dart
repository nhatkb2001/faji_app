import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:ferce_app/constants/colors.dart';

bool isChosedFemale = false;
bool isChosedMale = false;
bool isChosedCustom = false;
bool isChosedSecret = false;
genderDialog(
  BuildContext mContext,
) {
  return showDialog(
      context: mContext,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext mcontext, StateSetter setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: white,
              content: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        height: 200,
                        width: 327 + 24,
                        child: Padding(
                            padding: const EdgeInsets.all(0),
                            // padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Select your gender",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'Urbanist',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Iconsax.close_square,
                                          size: 24, color: black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChosedFemale = false;
                                            isChosedMale = !isChosedMale;
                                            isChosedCustom = false;
                                            isChosedSecret = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                (isChosedMale == false)
                                                    ? Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            new BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  'https://i.imgur.com/dVGYdKv.jpg'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            new BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  'https://i.imgur.com/dVGYdKv.jpg'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              color: black,
                                                              width: 1),
                                                        ),
                                                      )
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Male",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: black,
                                                fontFamily: 'Urbanist',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )),
                                    SizedBox(width: 26),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChosedFemale = !isChosedFemale;
                                            isChosedMale = false;
                                            isChosedCustom = false;
                                            isChosedSecret = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                (isChosedFemale == false)
                                                    ? Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  'https://i.imgur.com/ZO3niJM.jpg'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                        ))
                                                    : Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  'https://i.imgur.com/ZO3niJM.jpg'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              color: black,
                                                              width: 1),
                                                        ),
                                                      )
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Female",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: black,
                                                fontFamily: 'Urbanist',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )),
                                    SizedBox(width: 26),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChosedFemale = false;
                                            isChosedMale = false;
                                            isChosedSecret = !isChosedSecret;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                (isChosedSecret == false)
                                                    ? Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Icon(
                                                              Iconsax.bubble,
                                                              size: 24,
                                                              color: black),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 48,
                                                        height: 48,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          border: Border.all(
                                                              color: black,
                                                              width: 1),
                                                        ),
                                                        child: Icon(
                                                            Iconsax.bubble,
                                                            size: 24,
                                                            color: black),
                                                      )
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Secret",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: black,
                                                fontFamily: 'Urbanist',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  width: 279,
                                  height: 44,
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: white,
                                        fontFamily: 'Urbanist',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )))
                  ]));
        });
      });
}

datePickerDialog(BuildContext context, selectDate, category) {
  return showRoundedDatePicker(
      height: 320,
      context: context,
      fontFamily: "Urbanist",
      initialDate: selectDate,
      firstDate: DateTime(1900),
      lastDate: (category == "dob") ? DateTime.now() : DateTime(2050),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        //Section 1
        paddingDateYearHeader: EdgeInsets.all(8),
        backgroundHeader: black,
        textStyleDayButton: TextStyle(
            fontFamily: "Urbanist",
            fontSize: 16,
            color: white,
            fontWeight: FontWeight.w500,
            height: 1.0),
        textStyleYearButton: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 24,
          color: white,
          fontWeight: FontWeight.w500,
        ),

        //Section 2
        textStyleMonthYearHeader: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w600,
        ),
        backgroundHeaderMonth: black,
        paddingMonthHeader: EdgeInsets.only(top: 12, bottom: 12),
        sizeArrow: 24,
        colorArrowNext: white,
        colorArrowPrevious: white,
        // marginLeftArrowPrevious: 8,
        // marginTopArrowPrevious: 0,
        // marginTopArrowNext: 0,
        // marginRightArrowNext: 8,

        //Section 3
        paddingDatePicker: EdgeInsets.all(0),
        backgroundPicker: black,
        textStyleDayHeader: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w600,
        ),
        textStyleDayOnCalendar: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w400,
        ),
        textStyleDayOnCalendarSelected: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: black,
          fontWeight: FontWeight.w600,
        ),

        decorationDateSelected: BoxDecoration(
          color: white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.10),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),

        textStyleDayOnCalendarDisabled:
            TextStyle(fontSize: 20, color: white.withOpacity(0.1)),

        textStyleCurrentDayOnCalendar: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 20,
          color: black,
          fontWeight: FontWeight.w700,
        ),

        //Section 4
        paddingActionBar: EdgeInsets.all(8),
        backgroundActionBar: black,
        textStyleButtonAction: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w600,
        ),
        textStyleButtonPositive: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w600,
        ),
        textStyleButtonNegative: TextStyle(
          fontFamily: "Urbanist",
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w600,
        ),
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear: TextStyle(
            fontFamily: "Urbanist",
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w400),
        textStyleYearSelected: TextStyle(
            fontFamily: "Urbanist",
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.w600),
        heightYearRow: 80,
        backgroundPicker: gray,
      ));
}
