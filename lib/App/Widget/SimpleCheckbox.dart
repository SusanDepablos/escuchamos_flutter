// simple_checkbox.dart
import 'package:flutter/material.dart';

class SimpleCheckbox extends StatefulWidget {
  final Function(bool) onChanged;
  final String label;
  final Color labelColor;
  final VoidCallback?
      onLabelTap;
  final String? error;

  SimpleCheckbox({
    required this.onChanged,
    required this.label,
    this.labelColor =
        Colors.black,
    this.onLabelTap,
    this.error,
  });

  @override
  _SimpleCheckboxState createState() => _SimpleCheckboxState();
}

class _SimpleCheckboxState extends State<SimpleCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: widget
                  .onLabelTap,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget
                      .labelColor,
                ),
              ),
            ),
            SizedBox(
                width: 4.0),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked =
                      value ?? false;
                });
                widget.onChanged(_isChecked);
              },
            ),
          ],
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(
                  color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
