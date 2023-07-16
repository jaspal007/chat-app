import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormFieldInput extends StatefulWidget {
  TextFormFieldInput({
    super.key,
    required this.textEditingController,
    this.textInputType = TextInputType.text,
    required this.label,
    this.obscure = false,
    this.isValid,
    //required this.textFieldValue,
    required this.onSave,
  });
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String label;
  bool obscure;
  final String? Function(String?)? isValid;
  //String textFieldValue;
  final void Function(String?) onSave;
  @override
  State<TextFormFieldInput> createState() => _TextFormFieldInputState();
}

class _TextFormFieldInputState extends State<TextFormFieldInput> {
  TextEditingController get controller => widget.textEditingController;
  TextInputType get textInputType => widget.textInputType;
  String get label => widget.label;
  bool get isObscure => widget.obscure;
  late bool password; //set a non final bool variable to late
  bool _showClearButton = false;

  void isPassword() => password = (widget.obscure)
      ? true
      : false; //and initialize its value to initial obscure value passed by the user

  void obscureText() {
    setState(() {
      password = !password; //toggle it between states of visible or not visible
    });
  }

  @override
  void initState() {
    isPassword();
    super.initState();
    controller.addListener(() {
      setState(() {
        _showClearButton = controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: password,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: _showClearButton
            ? isObscure //use the obscure getter function to check if the field is a password field
                ? IconButton(
                    onPressed: obscureText,
                    icon: Icon(
                      password
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  )
                : IconButton(
                    onPressed: () => controller.clear(),
                    icon: const Icon(Icons.clear),
                  )
            : null,
      ),
      validator: widget.isValid,
      onSaved: widget.onSave,
    );
  }
}
