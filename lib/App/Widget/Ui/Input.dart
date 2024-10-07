import 'package:escuchamos_flutter/App/Widget/VisualMedia/Icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:escuchamos_flutter/Constants/Constants.dart';
import 'package:escuchamos_flutter/App/Widget/Dialog/CustomDatePickerDialog.dart';

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
                      _obscureText ? MaterialIcons.visibility : MaterialIcons.visibilityOff,
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
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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
    bool obscureText = false,
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
                      _obscureText ? MaterialIcons.visibilityOff : MaterialIcons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : _showClearIcon
                    ? IconButton(
                        icon: Icon(MaterialIcons.clear),
                        onPressed: _clearText,
                      )
                    : null,
            counterText: "",
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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
  final int maxLength;

  GenericInput({
    String? text,
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
    bool obscureText = false,
    this.maxLength = 50, // Límite de caracteres por defecto
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
          maxLength: (widget as GenericInput).maxLength, // Limitar el número de caracteres
          inputFormatters: [
            LengthLimitingTextInputFormatter((widget as GenericInput).maxLength),
          ],
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
                      _obscureText ? MaterialIcons.visibilityOff : MaterialIcons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : _showClearIcon
                    ? IconButton(
                        icon: const Icon(MaterialIcons.clear),
                        onPressed: _clearText,
                      )
                    : null,
            counterText: '', // Ocultar el contador de caracteres
          ),
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//"INPUT QUE PERMITE AMPLIARSE Y LIMPIA EL TEXTO PRESIONANDO LA X, HEREDA BASIC INPUT"
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class BasicTextArea extends BasicInput {
  final int maxLines;
  final int minLines;
  final int maxLength;

  BasicTextArea({
    String? text,
    required TextEditingController input,
    Color border = AppColors.inputBasic,
    String? error,
    bool obscureText = false,
    this.maxLines = 5,
    this.minLines = 1,
    this.maxLength = 50, // Límite de caracteres por defecto
  }) : super(
          text: text,
          input: input,
          border: border,
          error: error,
          obscureText: obscureText,
        );

  @override
  _BasicTextAreaState createState() => _BasicTextAreaState();
}

class _BasicTextAreaState extends __BasicInputState {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.input,
          obscureText: widget.obscureText,
          maxLines: (widget as BasicTextArea).maxLines,
          minLines: (widget as BasicTextArea).minLines,
          maxLength: (widget as BasicTextArea).maxLength, // Limita el número de caracteres
          inputFormatters: [
            LengthLimitingTextInputFormatter((widget as BasicTextArea).maxLength),
          ],
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
                      _obscureText ? MaterialIcons.visibilityOff : MaterialIcons.visibility,
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
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          locale: const Locale('es', ''),
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
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: widget.input,
            focusNode: _focusNode,
            readOnly: true, // El campo de texto solo se puede editar a través del selector de fecha
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
                      icon: const Icon(MaterialIcons.clear),
                      onPressed: _clearText,
                    )
                  : const Icon(MaterialIcons.calendar),
            ),
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding solo para el input
          child: TextField(
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
                icon: const Icon(MaterialIcons.search),
                onPressed: widget is SearchInput ? (widget as SearchInput).onSearch : null,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(MaterialIcons.clear),
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
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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
                color: widget.isDisabled ? AppColors.grey : widget.border),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: widget.isDisabled ? AppColors.grey : widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: widget.isDisabled ? AppColors.grey : widget.border),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? MaterialIcons.visibilityOff : MaterialIcons.visibility,
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
                            icon: const Icon(MaterialIcons.clear),
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
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
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

class TextArea extends StatefulWidget {
  final TextEditingController input;
  final Color border;
  final Color fillColor; // Añadir parámetro para el color de fondo
  final String? error;
  final bool obscureText;
  final int minLines; // Añadir parámetro para líneas mínimas
  final int maxLines; // Añadir parámetro para líneas máximas

  TextArea({
    required this.input,
    this.border = AppColors.inputLigth,
    this.fillColor = AppColors.greyLigth, // Color de fondo predeterminado
    this.error,
    this.obscureText = false,
    this.minLines = 8, // Valor predeterminado
    this.maxLines = 8, // Valor predeterminado
  });

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          obscureText: _obscureText,
          minLines: widget.minLines, // Establecer líneas mínimas
          maxLines: widget.maxLines, // Establecer líneas máximas
          decoration: InputDecoration(
            hintText: 'Escribe aquí...', // Placeholder
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
            filled: true, // Permitir color de fondo
            fillColor: widget.fillColor, // Color de fondo
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: widget.border),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? MaterialIcons.visibilityOff : MaterialIcons.visibility,
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
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class BodyTextField extends StatefulWidget {
  final TextEditingController input;
  final String? error;
  final int minLines;
  final int maxLines;

  BodyTextField({
    required this.input,
    this.error,
    this.minLines = 1,
    this.maxLines = 5,
  });

  @override
  _BodyTextFieldState createState() => _BodyTextFieldState();
}

class _BodyTextFieldState extends State<BodyTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.input,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          decoration: const InputDecoration(
            hintText: 'Escribe aquí...',
            hintStyle: TextStyle(fontSize: 14, color: AppColors.grey),
            border: InputBorder.none,  // Sin bordes
            filled: false,  // Sin fondo
          ),
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ),
      ],
    );
  }
}








