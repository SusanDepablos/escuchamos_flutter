import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///"INPUT DE ENTRADA BASICA QUE TIENE LA OPCION DE OCULTAR EL TEXTO, BASE PARA INPUTS"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class BasicInput extends StatefulWidget {
  String? text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;

  BasicInput({
    this.text,
    required this.input,
    this.border = AppColors.inputBasic,
    this.error,
    this.obscureText = false,
  });

  @override
  __BasicInputState createState() => __BasicInputState();
}

class __BasicInputState extends State<BasicInput> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.input;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.text,
            labelStyle: TextStyle(color: widget.border),
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
                : null,
          ),
        ),
        if (widget.error != null &&
            widget
                .error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//"INPUT CON UN LÍMITE DE 8 CARACTERES PREDETERMINADOS, HEREDA BASIC INPUT"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SecureInput extends BasicInput {
  final int maxLength;

  SecureInput({
    String? text,
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
    bool obscureText = true,
    this.maxLength = 8,
  }) : super(
          text: text,
          input: input,
          border: border,
          error: error,
          obscureText: obscureText,
        );

  @override
  __SecureInputState createState() => __SecureInputState();
}

class __SecureInputState extends __BasicInputState {
  late FocusNode _focusNode;
  late bool _obscureText;
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_updateClearIconVisibility);
    widget.input.addListener(_updateClearIconVisibility);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateClearIconVisibility);
    widget.input.removeListener(_updateClearIconVisibility);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateClearIconVisibility() {
    setState(() {
      _showClearIcon = widget.input.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _clearText() {
    widget.input.clear();
    _updateClearIconVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          focusNode: _focusNode,
          obscureText: _obscureText,
          maxLength:
              widget is SecureInput ? (widget as SecureInput).maxLength : null,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9]')),
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
            suffixIcon: _obscureText
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
            counterText: "",
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//"INPUT QUE LIMPIA EL TEXTO PRESIONANDO LA X, HEREDA BASIC INPUT"
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GenericInput extends BasicInput {
  GenericInput({
    String? text,
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
    bool obscureText = false,
  }) : super(
          text: text,
          input: input,
          border: border,
          error: error,
          obscureText: obscureText,
        );

  @override
  __GenericInputState createState() => __GenericInputState();
}

class __GenericInputState extends __BasicInputState {
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    widget.input.addListener(_updateClearIconVisibility);
  }

  @override
  void dispose() {
    widget.input.removeListener(_updateClearIconVisibility);
    super.dispose();
  }

  void _updateClearIconVisibility() {
    setState(() {
      // Mostrar el ícono de la "X" solo si el campo tiene texto
      _showClearIcon = widget.input.text.isNotEmpty;
    });
  }

  void _clearText() {
    widget.input.clear();
    _updateClearIconVisibility(); // Asegura que el ícono se actualice
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.text, // Cambiado de hintText a labelText
            labelStyle: TextStyle(color: widget.border), // Estilo para el label
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
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///"INPUT DE FECHA, HEREDA BASIC INPUT"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class DateInput extends BasicInput {
  DateInput({
    String? text,
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
  }) : super(
          text: text,
          input: input,
          border: border,
          error: error,
          obscureText: false, // No se usa obscureText en DateInput
        );

  @override
  __DateInputState createState() => __DateInputState();
}

class __DateInputState extends __BasicInputState {
  late FocusNode _focusNode;
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_updateClearIconVisibility);
    widget.input.addListener(_updateClearIconVisibility);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateClearIconVisibility);
    widget.input.removeListener(_updateClearIconVisibility);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateClearIconVisibility() {
    setState(() {
      _showClearIcon = widget.input.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _clearText() {
    widget.input.clear();
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
        widget.input.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          focusNode: _focusNode,
          readOnly:
              true, // El campo de texto solo se puede editar a través del selector de fecha
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            labelText: widget.text, // Cambiado de hintText a labelText
            labelStyle: TextStyle(color: widget.border), // Estilo para el label
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
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///"INPUT DE BUSQUEDA"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class SearchInput extends BasicInput {
  final VoidCallback? onSearch;
  final VoidCallback? onClear;

  SearchInput({
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
    this.onSearch,
    this.onClear,
    String? text = 'Buscar',
  }) : super(
          text: text,
          input: input,
          border: border,
          error: error,
          obscureText: false, // La barra de búsqueda no oculta el texto
        );

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends __BasicInputState {
  bool _hasText = false; // Nuevo estado para controlar la visibilidad del ícono de la "X"

  @override
  void initState() {
    super.initState();
    // Agrega un listener para actualizar el estado de _hasText basado en el contenido del input
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.text,
            labelStyle: TextStyle(color: widget.border),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: widget.border),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: widget is SearchInput ? (widget as SearchInput).onSearch : null,
            ),
            suffixIcon: _hasText
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _hasText = false; // Resetear el estado para esconder la "X"
                      });
                      if (widget is SearchInput) {
                        (widget as SearchInput).onClear?.call();
                      }
                    },
                  )
                : null, // Solo muestra el ícono de la "X" si _hasText es true
          ),
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class NumericInput extends StatefulWidget {
  final String? text;
  final TextEditingController input;
  final Color border;
  final String? error;
  final bool obscureText;
  final bool isDisabled;
  final ValueChanged<String>? onChanged;

  NumericInput({
    this.text,
    required this.input,
    this.border = Colors.black,
    this.error,
    this.obscureText = false,
    this.isDisabled = true,
    this.onChanged,
  });

  @override
  _NumericInputState createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  bool _obscureText = false;
  bool _showClearIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          obscureText: widget.obscureText && _obscureText,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
            _NumericInputFormatter(), // Asegúrate de que esta clase esté definida en el mismo archivo o importada
          ],
          decoration: InputDecoration(
            labelText: widget.text,
            labelStyle: TextStyle(
                color: widget.isDisabled ? Colors.grey : widget.border),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: widget.isDisabled ? Colors.grey : widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: widget.isDisabled ? Colors.grey : widget.border),
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
                : widget.isDisabled
                    ? null
                    : _showClearIcon
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              widget.input.clear();
                              setState(() {
                                _showClearIcon = false;
                              });
                            },
                          )
                        : null,
          ),
          enabled: !widget.isDisabled,
          onChanged: (text) {
            setState(() {
              _showClearIcon = text.isNotEmpty;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
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

class _NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText == '0') {
      return oldValue;
    }

    if (newText.isNotEmpty && newText[0] == '0' && newText.length > 1) {
      return oldValue;
    }

    return newValue;
  }
}





