import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;

  CustomInput({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
    this.obscureText = false,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscureText;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
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
      // Mostrar el ícono de la "X" solo si el campo tiene texto y está enfocado
      _showClearIcon = _controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _clearText() {
    _controller.clear();
    _updateClearIconVisibility(); // Asegura que el ícono se actualice
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
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
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : _showClearIcon
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearText,
                      )
                    : null,
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
