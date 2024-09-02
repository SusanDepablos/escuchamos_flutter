import 'package:flutter/material.dart';

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
    this.dropdownColor = Colors.white,
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
    Color dropdownColor = Colors.white,
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
    Color dropdownColor = Colors.white,
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
        SizedBox(width: 8.0),
        Text(
          '${itemData['dialingCode'] ?? ''}',
          style: textStyle,
        ),
      ],
    );
  }
}
