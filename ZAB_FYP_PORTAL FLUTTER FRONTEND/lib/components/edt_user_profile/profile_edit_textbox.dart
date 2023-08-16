import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ProfileEditTextbox extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? placeholder;
  final bool disabled;
  final bool isPhoneField;
  final String? countryCode;
  final bool isCountry;
  final TextEditingController controller;
  final Function(String value)? onChanged;

  const ProfileEditTextbox(
      {Key? key,
      required this.icon,
      required this.label,
      required this.value,
      this.placeholder,
      this.disabled = false,
      required this.controller,
      this.isPhoneField = false,
      this.isCountry = false,
      this.onChanged = null,
      this.countryCode = null})
      : super(key: key);

  @override
  State<ProfileEditTextbox> createState() => _ProfileEditTextboxState();
}

class _ProfileEditTextboxState extends State<ProfileEditTextbox> {
  String? iconEmoji;

  @override
  initState() {}

  @override
  Widget build(BuildContext context) {
    if (widget.isPhoneField) {
      return IntlPhoneField(
        controller: widget.controller,
        decoration: decoration(context),
        disableLengthCheck: true,
        keyboardType: TextInputType.phone,
        initialCountryCode: widget.countryCode,
        onCountryChanged: ((value) {
          if (widget.onChanged != null) {
            widget.onChanged!("${value.dialCode}${widget.controller.text}");
          }
        }),
        onChanged: ((value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value.completeNumber);
          }
        }),
      );
    }

    return TextField(
      controller: widget.controller,
      onTap: widget.isCountry ? () => selectCountry(context) : null,
      enabled: !this.widget.disabled,
      readOnly: widget.isCountry ? true : false,
      onChanged: ((value) {
        if (!widget.isCountry && widget.onChanged != null) {
          widget.onChanged!(value);
        }
      }),
      decoration: decoration(context),
    );
  }

  selectCountry(BuildContext context) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: Theme.of(context).colorScheme.background,
          textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
          bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),

          //Optional. Styles the search field.
          inputDecoration: decoration(context),
        ),
        onSelect: (Country country) {
          widget.controller.text = country.displayNameNoCountryCode;
          setState(() {
            iconEmoji = country.flagEmoji;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(country.countryCode);
          }
        });
  }

  InputDecoration decoration(BuildContext context) {
    return InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        focusColor: Theme.of(context).colorScheme.surface,
        hoverColor: Theme.of(context).colorScheme.surface,
        prefixIcon: iconEmoji != null
            ? SizedBox(
                width: 30,
                child: Center(
                    child: Text(
                  iconEmoji!,
                  style: TextStyle(fontSize: 24),
                )),
              )
            : Icon(this.widget.icon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Theme.of(context).colorScheme.primary,
                width: 1)),
        labelText: this.widget.label,
        hintText: this.widget.placeholder);
  }
}
