import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

//The message that appears after completing some operations

alert_widget(String text, IconData icon, BuildContext context) {
  Color Customcolor =
      context.isDark ? Colors.grey.shade900 : Colors.grey.shade600;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        height: context.ScreenHeight / 18,
        width: context.ScreenWidth / 1.05,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Customcolor, borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: context.IconSize),
            Flexible(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text('${text}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white, fontSize: context.MiddleFont)),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
