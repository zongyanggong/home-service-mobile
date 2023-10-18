import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const InputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
        this.maxLines,
      this.widget,
      this.onChanged,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Container(
            height: maxLines == null || maxLines == 1 ? 52 : null,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: maxLines??1,
                    readOnly:widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Colors.grey[700],
                    controller: controller,
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged!(value);
                      }
                    },
                    onFieldSubmitted: (value){
                      if (onSubmitted!=null){
                        onSubmitted!(value);
                      }
                    },
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0)),
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
