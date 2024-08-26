import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class DigitBox extends StatefulWidget {
  final TextEditingController input;
  final Color border;
  final Color focusedBorderColor;
  final Color digitTextColor;
  final Color boxColor;
  final String? error;

  DigitBox({
    required this.input,
    this.border = Colors.grey,
    this.focusedBorderColor = AppColors.primaryBlue,
    this.digitTextColor = Colors.black,
    this.boxColor = Colors.white,
    this.error,
  });

  @override
  _DigitBoxState createState() => _DigitBoxState();
}

class _DigitBoxState extends State<DigitBox> {
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
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: widget.boxColor, // Color de fondo de cada caja
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.digitTextColor, // Color del texto en cada caja
          fontWeight: FontWeight.bold,
        ),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: AppColors
                    .primaryBlue), // Color del borde cuando no está enfocado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: widget
                    .focusedBorderColor), // Color del borde cuando está enfocado
          ),
        ),
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }
}
