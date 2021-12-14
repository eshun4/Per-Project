import 'package:flutter/material.dart';
import 'package:rideboard/ui/components/constants.dart';

class DynamicTextField extends StatelessWidget {
  final String label;
  final Icon preIcon;
  final Icon suffIcon;
  final TextInputType preferredInput;
  final Function onEntry;
  final TextEditingController myController;
  final Function myValidator;

  DynamicTextField(
      {this.preIcon,
      this.label,
      this.suffIcon,
      this.preferredInput,
      this.onEntry,
      this.myController,
      this.myValidator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: myValidator,
      controller: myController,
      onChanged: onEntry,
      obscuringCharacter: '*',
      style: kTextfield,
      keyboardType: preferredInput,
      obscureText: false,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.purple, width: 5),
          ),
          focusColor: Colors.purple,
          hintText: label,
          hintStyle: kTextfield,
          prefixIcon: preIcon,
          suffixIcon: suffIcon),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String label;
  final Icon preIcon;
  final Icon suffIcon;
  final TextInputType preferredInput;
  final Function onEntry;
  final TextEditingController myController;
  final Function myValidator;

  PasswordField(
      {this.label,
      this.preIcon,
      this.preferredInput,
      this.suffIcon,
      this.onEntry,
      this.myController,
      this.myValidator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: myValidator,
      controller: myController,
      onChanged: onEntry,
      obscuringCharacter: '*',
      style: kTextfield,
      keyboardType: preferredInput,
      obscureText: true,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.purple, width: 5),
          ),
          focusColor: Colors.purple,
          hintText: label,
          hintStyle: kTextfield,
          prefixIcon: preIcon,
          suffixIcon: suffIcon),
    );
  }
}
