import 'package:flutter/material.dart';

class CustomDigitInput extends StatefulWidget {
  final TextEditingController input;
  final Color border;
  final String? error;

  CustomDigitInput({
    required this.input,
    this.border = Colors.grey,
    this.error,
  });

  @override
  _CustomDigitInputState createState() => _CustomDigitInputState();
}

class _CustomDigitInputState extends State<CustomDigitInput> {
  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());

    // Inicializar el texto del controlador principal
    widget.input.addListener(_syncControllers);
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    widget.input.removeListener(_syncControllers);
    super.dispose();
  }

  void _syncControllers() {
    final text = widget.input.text;
    for (int i = 0; i < 6; i++) {
      if (i < text.length) {
        _controllers[i].text = text[i];
      } else {
        _controllers[i].clear();
      }
    }
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(0, 1);
    }
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
    _updateMainController();
  }

  void _updateMainController() {
    String code = _controllers.map((controller) => controller.text).join();
    widget.input.text = code;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return _buildDigitBox(index);
          }),
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

  Widget _buildDigitBox(int index) {
    return Container(
      width: 40.0,
      height: 50.0,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: widget.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: widget.border),
          ),
        ),
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }
}
