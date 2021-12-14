import 'package:flutter/material.dart';
import 'package:reminderly/Constants/ColorsAndTextsConstants.dart';

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
      validator: myValidator as String Function(String),
      controller: myController,
      onChanged: onEntry as void Function(String),
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
            borderSide: BorderSide(color: kMaroon, width: 5),
          ),
          focusColor: kMaroon,
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
      validator: myValidator as String Function(String),
      controller: myController,
      onChanged: onEntry as void Function(String),
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
            borderSide: BorderSide(color: kMaroon, width: 5),
          ),
          focusColor: kMaroon,
          hintText: label,
          hintStyle: kTextfield,
          prefixIcon: preIcon,
          suffixIcon: suffIcon),
    );
  }
}

class DynamicTextField2 extends StatelessWidget {
  final String label;
  final Icon preIcon;
  final Icon suffIcon;
  final TextInputType preferredInput;
  final Function onEntry;
  final TextEditingController myController;
  final Function myValidator;
  final int maxLines;

  DynamicTextField2(
      {this.preIcon,
      this.label,
      this.suffIcon,
      this.preferredInput,
      this.onEntry,
      this.myController,
      this.myValidator,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      validator: myValidator as String Function(String),
      controller: myController,
      onChanged: onEntry as void Function(String),
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
            borderSide: BorderSide(color: kMaroon, width: 5),
          ),
          focusColor: kMaroon,
          hintText: label,
          hintStyle: kTextfield,
          prefixIcon: preIcon,
          suffixIcon: suffIcon),
    );
  }
}
