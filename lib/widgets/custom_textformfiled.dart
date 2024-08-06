import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      required TextEditingController email,
      required this.hint,
      required this.label})
      : _email = email;

  final TextEditingController _email;
  String label;
  String hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          fillColor: const Color(0xffaee0d5),
          filled: true,
          suffixIcon: label == 'Password'
              ? GestureDetector(
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).toggleText();
                  },
                  child: Provider.of<Auth>(context).obscureText
                      ? const Icon(
                          FeatherIcons.eyeOff,
                          color: Color(0xffaee0d5),
                          // size: 35,
                        )
                      : const Icon(
                          FeatherIcons.eye, color: Color(0xffaee0d5),
                          // size: 35,
                        ),
                )
              : const SizedBox.shrink(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffaee0d5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffaee0d5), width: 2),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true, // Insert this line
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          hintText: hint),
      controller: _email,
      autofocus: true,
      autocorrect: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (label == 'Email') {
            return Provider.of<Auth>(context, listen: false)
                .validationError
                ?.email;
          } else if (label == 'Password') {
            return Provider.of<Auth>(context, listen: false)
                .validationError
                ?.password;
          } else {
            return Provider.of<Auth>(context, listen: false)
                .validationError
                ?.name;
          }
        } else {
          return null;
        }
      },
      obscureText:
          label == 'Password' ? Provider.of<Auth>(context).obscureText : false,
    );
  }
}
