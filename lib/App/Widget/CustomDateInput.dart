import 'package:flutter/material.dart';

class CustomDateInput extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;

  CustomDateInput({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
  });

  @override
  _CustomDateInputState createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.input;
    _focusNode = FocusNode();
    _focusNode.addListener(_updateClearIconVisibility);
    _controller.addListener(_updateClearIconVisibility);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateClearIconVisibility);
    _controller.removeListener(_updateClearIconVisibility);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updateClearIconVisibility() {
    setState(() {
      _showClearIcon = _controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _clearText() {
    _controller.clear();
    _updateClearIconVisibility();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: true, // El campo de texto solo se puede editar a través del selector de fecha
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: widget.text,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: widget.border),
            ),
            suffixIcon: _showClearIcon
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearText,
                  )
                : Icon(Icons.calendar_today),
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
