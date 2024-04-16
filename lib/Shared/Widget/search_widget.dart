// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Theme/config.dart';
import 'package:seventh_project/Shared/Widget/custom_field.dart';

class search_widget extends StatefulWidget {
  Function? onChanged;
  double borderRadius;
  TextEditingController controller;
  void Function()? onClear;
  EdgeInsetsGeometry? margin;
  bool autofocus;
  String hintText;
  search_widget(
      {required this.controller,
      this.borderRadius = 8.0,
      this.onChanged,
      this.onClear,
      this.margin,
      this.autofocus = false,
      this.hintText = 'بحث',
      super.key});

  @override
  State<search_widget> createState() => _search_widgetState();
}

class _search_widgetState extends State<search_widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        // height: context.ScreenHeight / 18,
        margin: widget.margin ?? EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).splashColor,
            borderRadius: BorderRadius.circular(widget.borderRadius)),
        child: Custom_filed(fieldmodel(
            hinttext: widget.hintText,
            leading:
                Icon(Icons.search, color: Colors.grey, size: context.IconSize),
            trailing: widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: widget.onClear,
                    icon: Icon(Icons.close_rounded, size: context.IconSize))
                : null,
            autofocus: widget.autofocus,
            controller: widget.controller,
            onChanged: widget.onChanged)),
      ),
    );
  }
}
