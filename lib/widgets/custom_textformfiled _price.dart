import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';

import '../providers/auth.dart';

// ignore: must_be_immutable
class CustomTextFormFieldPrice extends StatelessWidget {
  CustomTextFormFieldPrice(
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
          // prefixIcon: const Icon(Icons.currency_exchange),
          prefix: const Text('\$ '),
          suffixIcon: label == 'Password'
              ? GestureDetector(
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).toggleText();
                  },
                  child: Provider.of<Auth>(context).obscureText
                      ? const Icon(
                          FeatherIcons.eyeOff,
                          color: primary,
                          // size: 35,
                        )
                      : const Icon(
                          FeatherIcons.eye, color: Colors.indigo,
                          // size: 35,
                        ),
                )
              : const SizedBox.shrink(),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primary)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primary, width: 2)),
          labelText: label,
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
