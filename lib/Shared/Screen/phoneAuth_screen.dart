import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seventh_project/Controller/auth_controller.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/custom_field.dart';

class PhoneAuth_screen extends StatefulWidget {
  const PhoneAuth_screen({super.key});

  @override
  State<PhoneAuth_screen> createState() => _PhoneAuth_screenState();
}

class _PhoneAuth_screenState extends State<PhoneAuth_screen> {
  TextEditingController phoneController = TextEditingController();
  String countryCode = '+20';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text('رقم الهاتف',
                style: TextStyle(fontSize: context.LargeFont)),
          ),
          Text('سيتلقى رقمك رمز تأكيد عبرالرسائل القصيرة.',
              style: TextStyle(fontSize: context.MiddleFont)),
          Lottie.asset('assets/phone.json',
              width: 200, height: 200, fit: BoxFit.fill),
          CountryCodePicker(
            onChanged: (value) {
              countryCode = value.dialCode!;
              setState(() {});
            },
            onInit: (value) {
              countryCode = value!.dialCode!;
            },
            initialSelection: 'EG', showDropDownButton: true,
            showCountryOnly: true,
            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            barrierColor: context.isDark ? Colors.grey.shade900 : null,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: true,
            // optional. aligns the flag and the Text left
            alignLeft: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Custom_filed(fieldmodel(
                enabledBorder: Colors.grey,
                controller: phoneController,
                texttype: TextInputType.phone,
                hinttext: 'رقم هاتفك')),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).highlightColor,
                fixedSize:
                    Size(context.ScreenWidth / 1.2, context.ScreenHeight / 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            onPressed: () => AuthController.sendOtp(
                context, countryCode + phoneController.text),
            child: Text('استمرار',
                style: TextStyle(
                    color: context.defaultColor, fontSize: context.MiddleFont)),
          )
        ],
      ),
    );
  }
}
