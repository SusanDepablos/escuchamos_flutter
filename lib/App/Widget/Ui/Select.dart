import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/Constants/Constants.dart';

class SelectBasic extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final void Function(String?)? onChanged;
  final String hintText; // Valor predeterminado

  SelectBasic({
    required this.selectedValue,
    required this.items,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.whiteapp,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.inputBasic,
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedValue, // Asegúrate de que este valor sea el correcto
          hint: selectedValue == null
              ? Text(hintText) // Muestra el valor predeterminado
              : Text(items.firstWhere(
                      (item) => item['id'] == selectedValue)['name'] ??
                  ''), // Muestra el valor seleccionado
          items: items.map((item) {
            return DropdownMenuItem<String?>(
              value: item['id'], // Cambiado a 'id' en lugar de 'value'
              child: Text(
                item['name'] ?? '',
                style: TextStyle(
                  color: AppColors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            onChanged?.call(value); // Llama a onChanged si no es nulo
          },
          isExpanded: true,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

abstract class SelectBase<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T?> items;
  final void Function(T?)? onChanged;
  final String hintText;
  final TextStyle? textStyle;
  final Color dropdownColor;
  final double iconSize;

  SelectBase({
    required this.selectedValue,
    required this.items,
    this.onChanged,
    this.hintText = '+0',
    this.textStyle,
    this.dropdownColor = AppColors.whiteapp,
    this.iconSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: DropdownButton<T?>(
        value: selectedValue,
        hint: Text(
          hintText,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T?>(
            value: item,
            child: buildItem(context, item),
          );
        }).toList(),
        onChanged: onChanged,
        style: textStyle,
        dropdownColor: dropdownColor,
        underline: SizedBox(), // Sin subrayado
        icon: SizedBox(), // Sin ícono
        iconSize: iconSize,
        alignment: Alignment.center,
      ),
    );
  }

  Widget buildItem(BuildContext context, T? item);
}

class SelectText extends SelectBase<String?> {
  SelectText({
    required String? selectedValue,
    required List<String?> items,
    void Function(String?)? onChanged,
    String hintText = '+0',
    TextStyle? textStyle,
    Color dropdownColor = AppColors.whiteapp,
    double iconSize = 0,
  }) : super(
          selectedValue: selectedValue,
          items: items,
          onChanged: onChanged,
          hintText: hintText,
          textStyle: textStyle,
          dropdownColor: dropdownColor,
          iconSize: iconSize,
        );

  @override
  Widget buildItem(BuildContext context, String? item) {
    return Text(
      item ?? '',
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }
}

class SelectWithFlags extends SelectBase<String?> {
  final List<Map<String, String?>> itemsMap;

  SelectWithFlags({
    required String? selectedValue,
    required this.itemsMap,
    void Function(String?)? onChanged,
    String hintText = '+0',
    TextStyle? textStyle,
    Color dropdownColor = AppColors.whiteapp,
    double iconSize = 0,
  }) : super(
          selectedValue: selectedValue,
          items: itemsMap.map((data) => data['dialingCode']! + data['isoCode']!).toList(),
          onChanged: onChanged,
          hintText: hintText,
          textStyle: textStyle,
          dropdownColor: dropdownColor,
          iconSize: iconSize,
        );

  @override
  Widget buildItem(BuildContext context, String? item) {
    final itemData = itemsMap.firstWhere(
      (data) => (data['dialingCode']! + data['isoCode']!) == item,
      orElse: () => {'dialingCode': '', 'isoCode': ''},
    );
    String? code = itemData['isoCode'];
    String flagAssetPath = 'icons/flags/png100px/${code?.toLowerCase()}.png';

    return Row(
      children: [
        Image.asset(
          flagAssetPath,
          package: 'country_icons',
          width: 20.0,
          height: 14.0,
        ),
        SizedBox(width: 6.0),
        Text(
          '${itemData['dialingCode'] ?? ''}',
          style: textStyle,
        ),
      ],
    );
  }
}

class SelectCountryWithFlags extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String?>> itemsMap;
  final void Function(String?)? onChanged;
  final String hintText;
  final TextStyle? textStyle;
  final Color dropdownColor;
  final double iconSize;

  SelectCountryWithFlags({
    required this.selectedValue,
    required this.itemsMap,
    this.onChanged,
    this.hintText = '+0',
    this.textStyle,
    this.dropdownColor = Colors.white,
    this.iconSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupar todo el ancho disponible
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.whiteapp, // Fondo blanco
        borderRadius: BorderRadius.circular(16.0), // Bordes más redondeados
        border: Border.all(
          color: AppColors.inputBasic, // Color del borde
          width: 1.0, // Grosor del borde
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedValue,
          hint: Text(
            hintText,
            style: textStyle,
          ),
          items: itemsMap.map((data) {
            String? code = data['isoCode'];
            String flagAssetPath = 'icons/flags/png100px/${code?.toLowerCase()}.png';
            return DropdownMenuItem<String?>(
              value: data['id'],
              child: Row(
                children: [
                  Image.asset(
                    flagAssetPath,
                    package: 'country_icons',
                    width: 20.0,
                    height: 14.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    data['name'] ?? '',
                    style: textStyle,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: dropdownColor,
          iconSize: iconSize,
          isExpanded: true, // Permite que el dropdown use todo el espacio disponible
        ),
      ),
    );
  }
}