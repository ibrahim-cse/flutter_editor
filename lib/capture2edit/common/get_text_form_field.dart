import 'package:flutter/material.dart';
import 'package:flutter_editor/capture2edit/common/toast_helper.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField({required this.controller, required this.myhint, required this.myicon, this.isObscureText = false, this.inputType = TextInputType.text});

  final TextEditingController controller;
  final String myhint;
  final IconData myicon;
  final bool isObscureText;
  TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal),
        controller: controller,
        obscureText: isObscureText,
        keyboardType: inputType,
        // validator: (val) => val!.length == 0 ? 'Please Enter $myhint' : null,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter $myhint';
          }
          if (myhint == "Email" && !validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },

        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(myicon),
          hintText: myhint,
          labelText: myhint,
          fillColor: Color(0xFFCCCCCE),
          filled: true,
        ),
      ),
    );
  }
}
