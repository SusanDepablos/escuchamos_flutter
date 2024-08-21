import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import para filtros de texto

class CustomInput8 extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;

  CustomInput8({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
    this.obscureText = false,
  });

  @override
  _CustomInput8State createState() => _CustomInput8State();
}

class _CustomInput8State extends State<CustomInput8> {
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
      _showClearIcon = _controller.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _clearText() {
    _controller.clear();
    _updateClearIconVisibility(); 
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
          maxLength: 8, // Limitar a 8 caracteres
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Solo alfanumérico
          ],
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
            counterText: "", // Oculta el contador de caracteres
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
