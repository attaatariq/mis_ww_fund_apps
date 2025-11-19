import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/colors/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String errorText;
  final bool enabled;
  final int maxLines;
  final int maxLength;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final bool readOnly;
  final VoidCallback onTap;
  final Widget suffixIcon;
  final bool showPasswordToggle;
  final String Function(String) validator;

  CustomTextField({
    Key key,
    this.controller,
    this.label = "",
    this.hint = "",
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.showPasswordToggle = false,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppTheme.colors.newWhite
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : _isFocused
                      ? AppTheme.colors.newPrimary
                      : Colors.grey.withOpacity(0.3),
              width: hasError ? 2 : 1.5,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: AppTheme.colors.newPrimary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: TextField(
              controller: widget.controller,
              obscureText: widget.showPasswordToggle ? _obscureText : widget.obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              focusNode: widget.focusNode,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.6),
                  fontSize: 14,
                  fontFamily: "AppFont",
                  fontWeight: FontWeight.normal,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Container(
                        padding: EdgeInsets.all(14),
                        child: Icon(
                          widget.prefixIcon,
                          color: hasError
                              ? Colors.red
                              : _isFocused
                                  ? AppTheme.colors.newPrimary
                                  : Colors.grey.withOpacity(0.6),
                          size: 20,
                        ),
                      )
                    : null,
                suffixIcon: widget.showPasswordToggle
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.withOpacity(0.6),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : widget.suffixIcon,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon != null ? 12 : 16,
                  vertical: 16,
                ),
                counterText: "",
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: Colors.red,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.errorText,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Dropdown variant
class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final Function(String) onChanged;
  final String errorText;
  final IconData prefixIcon;
  final bool enabled;

  CustomDropdownField({
    Key key,
    this.label = "",
    this.hint = "",
    this.value,
    this.items,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.colors.newBlack,
                fontSize: 13,
                fontFamily: "AppFont",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppTheme.colors.newWhite
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : Colors.grey.withOpacity(0.3),
              width: hasError ? 2 : 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.6),
                fontSize: 14,
                fontFamily: "AppFont",
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: prefixIcon != null
                  ? Container(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        prefixIcon,
                        color: hasError
                            ? Colors.red
                            : Colors.grey.withOpacity(0.6),
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 12 : 16,
                vertical: 16,
              ),
            ),
            style: TextStyle(
              color: AppTheme.colors.newBlack,
              fontSize: 14,
              fontFamily: "AppFont",
              fontWeight: FontWeight.normal,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.withOpacity(0.6),
            ),
            dropdownColor: AppTheme.colors.newWhite,
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: Colors.red,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: "AppFont",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Custom Button with proper touch target
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final double height;
  final double borderRadius;

  CustomButton({
    Key key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.height = 52, // Minimum 48dp + padding
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor != null
        ? backgroundColor
        : AppTheme.colors.newPrimary;
    final txtColor = textColor != null
        ? textColor
        : AppTheme.colors.newWhite;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: enabled && !isLoading
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: enabled && !isLoading
            ? bgColor
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: enabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: txtColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: txtColor,
                          fontSize: 15,
                          fontFamily: "AppFont",
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

