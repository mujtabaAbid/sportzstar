import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../helper/basic_enum.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    this.heading,
    this.headingStyle,
    required this.onSaved,
    // this.type,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.label,
    this.fieldType = InputType.text,
    this.icon,
    this.obscureText,
    this.sidePadding,
    this.controller,
    this.noValidator = false,
    this.suffixIcon,
    this.imageWidget,
    this.backgroundColor,
    this.readOnly = false,
    this.highlightErrorBorder = false,
    this.textCapitalization = TextCapitalization.none,
    this.headingWidget, // Default value added
    this.showCountryCodePicker = false,
    this.maxLines,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
  });
  final String? heading;
  final TextStyle? headingStyle;
  // final InputType? type;
  final String? label;
  final String? icon;
  final bool? obscureText;
  // final bool? onChanged;
  final double? sidePadding;
  final TextInputType keyboardType;
  final Function? validator;
  final bool? noValidator;
  final Function onSaved;
  final InputType fieldType;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? imageWidget;
  final bool? readOnly;
  final Color? backgroundColor;
  final bool highlightErrorBorder;
  final TextCapitalization textCapitalization;
  final Widget? headingWidget;
  final bool showCountryCodePicker;
  final int? maxLines;
  final String? initialValue;
  final TextInputAction? textInputAction;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // vertical: 12,
        horizontal: widget.sidePadding ?? 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 4),
              widget.headingWidget ??
                  Text(
                    widget.heading ??
                        (widget.fieldType == InputType.email
                            ? 'Username or email'
                            : ''),
                    style:
                        widget.headingStyle ??
                        const TextStyle(color: Colors.black, fontSize: 14),
                  ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (widget.showCountryCodePicker)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [const SizedBox(width: 10)]),
                ),

              Expanded(
                child: TextFormField(
                  textInputAction: widget.textInputAction,
                  initialValue: widget.initialValue,
                  maxLines:
                      (widget.obscureText ?? false)
                          ? 1
                          : (widget.maxLines ?? 1),
                  // maxLines: widget.maxLines,
                  readOnly: widget.readOnly!,
                  obscureText: widget.obscureText ?? false,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  textCapitalization: widget.textCapitalization,
                  validator:
                      widget.validator != null
                          ? (value) => widget.validator!(value)
                          : (widget.noValidator == true
                              ? null
                              : ValidationBuilder().build()),
                  onSaved: (value) {
                    widget.onSaved(value ?? '');
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText:
                        widget.label ??
                        (widget.fieldType == InputType.email ? 'Email' : ''),
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: widget.suffixIcon,

                    // ✅ This shows +XX prefix inside the input field
                    //  prefixText: widget.showCountryCodePicker ? '$selectedCountryCode ' : null,
                    prefixStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    filled: true,
                    fillColor:
                        widget.backgroundColor ??
                        const Color.fromARGB(255, 224, 224, 224),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color:
                            widget.highlightErrorBorder
                                ? Colors.green
                                : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
