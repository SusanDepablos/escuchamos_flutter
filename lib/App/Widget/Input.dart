import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';

class DigitBoxInput extends StatefulWidget {
  final TextEditingController input;
  final Color border;
  final Color focusedBorderColor;
  final Color digitTextColor;
  final Color boxColor;
  final String? error;

  DigitBoxInput({
    required this.input,
    this.border = Colors.grey,
    this.focusedBorderColor = AppColors.primaryBlue,
    this.digitTextColor = Colors.black,
    this.boxColor = Colors.white,
    this.error,
  });

  @override
  _DigitBoxInputState createState() => _DigitBoxInputState();
}

class _DigitBoxInputState extends State<DigitBoxInput> {
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SecureInput extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;

  SecureInput({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
    this.obscureText = false,
  });

  @override
  _SecureInputState createState() => _SecureInputState();
}

class _SecureInputState extends State<SecureInput> {
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
            FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9]')), // Solo alfanumérico
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class GenericInput extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;

  GenericInput({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
    this.obscureText = false,
  });

  @override
  __GenericInputState createState() => __GenericInputState();
}

class __GenericInputState extends State<GenericInput> {
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class DateInput extends StatefulWidget {
  final String text;
  final TextEditingController input;
  final Color border;
  final String? error;

  DateInput({
    required this.text,
    required this.input,
    this.border = Colors.grey,
    this.error,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
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
      locale:
          const Locale('es', ''), // Idioma español para el selector de fechas
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                AppColors.primaryBlue, // Color de la barra superior (AppBar)
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue, // Color del día seleccionado
              onPrimary: Colors.white, // Color del texto en el día seleccionado
              onSurface:
                  Colors.black, // Color del texto en los días no seleccionados
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme
                  .primary, // Color del texto de los botones (OK/CANCEL)
            ),
          ),
          child: child!,
        );
      },
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
          readOnly:
              true, // El campo de texto solo se puede editar a través del selector de fecha
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
