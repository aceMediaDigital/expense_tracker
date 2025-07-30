/* =======================================================
 *
 * Created by anele on 29/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


class AppInput extends StatelessWidget {

  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? prefixIcon;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const AppInput({super.key,
    required this.obscureText,
    this.keyboardType, this.suffixIcon,
    required this.controller, this.validator,
    this.onTap, this.prefixIcon, this.maxLines,
    this.onChanged, this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 01, vertical: 0.1),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 13, color: Colors.black),
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: onTap,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          suffixIcon: suffixIcon,
          //fillColor: Colors.blue,
          prefixIcon: prefixIcon,
          enabledBorder:  OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0.3),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(width: 0.3),
          ),
          errorBorder:  OutlineInputBorder(
              //borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder:  OutlineInputBorder(
              //borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          //fillColor: AppColors.silverColor
        ),
      ),
    );
  }
}
