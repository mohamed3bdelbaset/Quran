import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:seventh_project/Controller/auth_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class Otp_screen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const Otp_screen(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<Otp_screen> createState() => _Otp_screenState();
}

class _Otp_screenState extends State<Otp_screen> {
  TextEditingController otpController = TextEditingController();
  bool incorrectOtp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Lottie.asset('assets/otp.json',
              width: context.ScreenHeight / 6,
              height: context.ScreenHeight / 6,
              fit: BoxFit.fill),
          Center(
              child: Text('ادخل الكود',
                  style: TextStyle(fontSize: context.LargeFont))),
          Text(
            'الاتصال بالرقم ${widget.phoneNumber} لإملاء الرمز.',
            style: TextStyle(fontSize: context.MiddleFont),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                appContext: context,
                autoFocus: true,
                length: 6,
                autovalidateMode: AutovalidateMode.always,
                controller: otpController,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldWidth: 50,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.blue,
                  activeColor: Colors.grey,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(5),
                ),
                onCompleted: (value) => AuthController.signInWithNum(
                        context, widget.verificationId, value)
                    .then((value) {
                  // If the code that the user entered not equal sms code
                  if (value == false) {
                    otpController.clear();
                    incorrectOtp = true;
                    setState(() {});
                  }
                }),
              ),
            ),
          ),
          if (incorrectOtp)
            Text('رمز غير صحيح يرحي المحاولة مرة اخري',
                style: TextStyle(
                    color: Colors.red.shade600, fontSize: context.MiddleFont))
        ],
      ),
    );
  }
}
