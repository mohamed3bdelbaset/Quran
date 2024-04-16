import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class fieldmodel {
  final String? labelText;
  final Widget? leading;
  final Widget? trailing;
  final TextInputType? texttype;
  final TextInputAction? actiontype;
  TextEditingController? controller;
  bool issecure;
  bool autofocus;
  bool expands;
  bool enabled;
  final Key? key;
  final int? maxLines;
  final int? lenght;
  Function? onSubmit = () {};
  Function? onChanged = () {};
  final Color disabledBorder;
  final Color enabledBorder;
  final double borderRadius;
  final String? hinttext;

  fieldmodel(
      {this.leading,
      this.trailing,
      this.labelText,
      this.texttype,
      this.controller,
      this.actiontype,
      this.issecure = false,
      this.autofocus = false,
      this.enabled = true,
      this.expands = false,
      this.disabledBorder = Colors.transparent,
      this.enabledBorder = Colors.transparent,
      this.borderRadius = 0,
      this.key,
      this.lenght,
      this.maxLines = 1,
      this.onSubmit,
      this.onChanged,
      this.hinttext});
}

class Custom_filed extends StatefulWidget {
  final fieldmodel model;
  const Custom_filed(this.model, {super.key});

  @override
  State<Custom_filed> createState() => _custom_filedState();
}

class _custom_filedState extends State<Custom_filed> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.model.key,
      validator: (x) {
        if (x!.isEmpty) {
          return 'some field requird';
        }
        return null;
      },
      decoration: InputDecoration(
          border: filedborder(Colors.transparent, widget.model.borderRadius),
          enabledBorder: filedborder(
              widget.model.enabledBorder, widget.model.borderRadius),
          disabledBorder: filedborder(
              widget.model.disabledBorder, widget.model.borderRadius),
          focusedBorder: filedborder(
              widget.model.enabledBorder, widget.model.borderRadius),
          errorBorder: filedborder(
              widget.model.enabledBorder, widget.model.borderRadius),
          prefixIcon:
              widget.model.leading != null ? widget.model.leading : null,
          labelText: widget.model.labelText,
          labelStyle:
              TextStyle(color: Colors.grey, fontSize: context.MiddleFont),
          hintText: widget.model.hinttext,
          hintStyle:
              TextStyle(color: Colors.grey, fontSize: context.MiddleFont),
          suffixIcon:
              widget.model.trailing != null ? widget.model.trailing : null),
      keyboardType: widget.model.texttype,
      textInputAction: widget.model.actiontype,
      controller: widget.model.controller,
      obscureText: widget.model.issecure,
      enabled: widget.model.enabled,
      maxLength: widget.model.lenght,
      expands: widget.model.expands,
      maxLines: widget.model.maxLines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      onFieldSubmitted: (x) {
        if (widget.model.onSubmit != null) widget.model.onSubmit!();
      },
      onChanged: (x) {
        if (widget.model.onChanged != null) widget.model.onChanged!();
      },
      autofocus: widget.model.autofocus,
      textDirection: TextDirection.rtl,
    );
  }
}

OutlineInputBorder filedborder(Color color, double borderRadius) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: 1.0));
}
