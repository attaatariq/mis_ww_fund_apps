import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wwf_apps/themes/form_theme.dart';

/// Enhanced Text Field Widget
class FormTextField extends StatefulWidget {
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

  FormTextField({
    Key key,
    this.controller,
    this.label,
    this.hint,
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
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
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

    Widget suffix = widget.suffixIcon;
    if (widget.showPasswordToggle) {
      suffix = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: FormTheme.hintColor,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: FormTheme.spacingS),
            child: Text(
              widget.label,
              style: FormTheme.labelStyle,
            ),
          ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
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
              style: FormTheme.inputTextStyle,
              decoration: FormTheme.inputDecoration(
                hint: widget.hint,
                label: widget.label,
                prefixIcon: widget.prefixIcon,
                suffixIcon: suffix,
                hasError: hasError,
                isFocused: _isFocused,
                isEnabled: widget.enabled,
              ),
            ),
          ),
        ),
        if (hasError)
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Padding(
              padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 14,
                    color: FormTheme.errorColor,
                  ),
                  SizedBox(width: FormTheme.spacingXS),
                  Expanded(
                    child: Text(
                      widget.errorText,
                      style: FormTheme.errorTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

/// Enhanced Dropdown Field Widget
class FormDropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final Function(String) onChanged;
  final String errorText;
  final IconData prefixIcon;
  final bool enabled;

  FormDropdownField({
    Key key,
    this.label,
    this.hint,
    this.value,
    this.items,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  _FormDropdownFieldState createState() => _FormDropdownFieldState();
}

class _FormDropdownFieldState extends State<FormDropdownField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: FormTheme.spacingS),
            child: Text(
              widget.label,
              style: FormTheme.labelStyle,
            ),
          ),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: DropdownButtonFormField<String>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.enabled ? widget.onChanged : null,
            style: FormTheme.inputTextStyle,
            decoration: FormTheme.inputDecoration(
              hint: widget.hint,
              label: widget.label,
              prefixIcon: widget.prefixIcon,
              hasError: hasError,
              isFocused: _isFocused,
              isEnabled: widget.enabled,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: FormTheme.hintColor,
              size: 24,
            ),
            dropdownColor: FormTheme.backgroundColor,
            borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: FormTheme.errorColor,
                ),
                SizedBox(width: FormTheme.spacingXS),
                Expanded(
                  child: Text(
                    widget.errorText,
                    style: FormTheme.errorTextStyle,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

/// Enhanced Selectable Field (for date pickers, dialogs, etc.)
class FormSelectableField extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  final IconData prefixIcon;
  final VoidCallback onTap;
  final String errorText;
  final bool enabled;

  FormSelectableField({
    Key key,
    this.label,
    this.value,
    this.hint,
    this.prefixIcon,
    this.onTap,
    this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText.isNotEmpty;
    final hasValue = value != null && value.isNotEmpty && value != hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: FormTheme.spacingS),
            child: Text(
              label,
              style: FormTheme.labelStyle,
            ),
          ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 12 : 16,
                vertical: 16,
              ),
              decoration: FormTheme.containerDecoration(
                hasError: hasError,
                isEnabled: enabled,
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: hasError
                          ? FormTheme.errorColor
                          : FormTheme.hintColor,
                      size: 20,
                    ),
                    SizedBox(width: FormTheme.spacingM),
                  ],
                  Expanded(
                    child: Text(
                      hasValue ? value : (hint ?? 'Select'),
                      style: TextStyle(
                        color: hasValue
                            ? FormTheme.secondaryColor
                            : FormTheme.hintColor,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FormTheme.hintColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: FormTheme.errorColor,
                ),
                SizedBox(width: FormTheme.spacingXS),
                Expanded(
                  child: Text(
                    errorText,
                    style: FormTheme.errorTextStyle,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

/// Enhanced Radio Button Group
class FormRadioGroup<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final Function(T) onChanged;
  final List<FormRadioOption<T>> options;
  final String errorText;

  FormRadioGroup({
    Key key,
    this.label,
    this.value,
    this.groupValue,
    this.onChanged,
    this.options,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: FormTheme.spacingM),
            child: Text(
              label,
              style: FormTheme.labelStyle,
            ),
          ),
        ...options.map((option) => Padding(
              padding: EdgeInsets.only(bottom: FormTheme.spacingM),
              child: InkWell(
                onTap: () => onChanged(option.value),
                borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
                child: Container(
                  padding: EdgeInsets.all(FormTheme.spacingM),
                  decoration: BoxDecoration(
                    color: FormTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
                    border: Border.all(
                      color: groupValue == option.value
                          ? FormTheme.primaryColor
                          : FormTheme.borderColor,
                      width: groupValue == option.value ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: groupValue == option.value
                                ? FormTheme.primaryColor
                                : FormTheme.hintColor,
                            width: 2,
                          ),
                        ),
                        child: groupValue == option.value
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: FormTheme.primaryColor,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: FormTheme.spacingM),
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            color: FormTheme.secondaryColor,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: FormTheme.errorColor,
                ),
                SizedBox(width: FormTheme.spacingXS),
                Expanded(
                  child: Text(
                    errorText,
                    style: FormTheme.errorTextStyle,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

class FormRadioOption<T> {
  final T value;
  final String label;

  FormRadioOption({this.value, this.label});
}

/// Enhanced Checkbox Widget
class FormCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final String errorText;

  FormCheckbox({
    Key key,
    this.label,
    this.value = false,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(FormTheme.borderRadiusS),
          child: Container(
            padding: EdgeInsets.all(FormTheme.spacingM),
            decoration: BoxDecoration(
              color: FormTheme.backgroundColor,
              borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
              border: Border.all(
                color: hasError
                    ? FormTheme.errorColor
                    : value
                        ? FormTheme.primaryColor
                        : FormTheme.borderColor,
                width: hasError || value ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: hasError
                          ? FormTheme.errorColor
                          : value
                              ? FormTheme.primaryColor
                              : FormTheme.hintColor,
                      width: 2,
                    ),
                    color: value ? FormTheme.primaryColor : FormTheme.backgroundColor,
                  ),
                  child: value
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: FormTheme.backgroundColor,
                        )
                      : null,
                ),
                if (label != null && label.isNotEmpty) ...[
                  SizedBox(width: FormTheme.spacingM),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: FormTheme.secondaryColor,
                        fontSize: 14,
                        fontFamily: "AppFont",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: FormTheme.errorColor,
                ),
                SizedBox(width: FormTheme.spacingXS),
                Expanded(
                  child: Text(
                    errorText,
                    style: FormTheme.errorTextStyle,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

/// Enhanced Primary Button
class FormPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData icon;
  final double height;

  FormPrimaryButton({
    Key key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.height = 52,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: FormTheme.primaryButtonDecoration(isEnabled: enabled && !isLoading),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(FormTheme.backgroundColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: FormTheme.backgroundColor,
                          size: 20,
                        ),
                        SizedBox(width: FormTheme.spacingS),
                      ],
                      Text(
                        text,
                        style: FormTheme.buttonTextStyle,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced Secondary Button
class FormSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData icon;
  final double height;

  FormSecondaryButton({
    Key key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.height = 52,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: FormTheme.secondaryButtonDecoration(isEnabled: enabled && !isLoading),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(FormTheme.primaryColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: FormTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: FormTheme.spacingS),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: FormTheme.primaryColor,
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

/// File Picker Button
class FormFilePickerButton extends StatelessWidget {
  final String label;
  final String fileName;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;
  final String errorText;

  FormFilePickerButton({
    Key key,
    this.label,
    this.fileName,
    this.hint = "Select File",
    this.icon = Icons.attach_file,
    this.onTap,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText.isNotEmpty;
    final hasFile = fileName != null && fileName.isNotEmpty && fileName != hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: FormTheme.spacingS),
            child: Text(
              label,
              style: FormTheme.labelStyle,
            ),
          ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(FormTheme.borderRadiusM),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(FormTheme.spacingL),
              decoration: FormTheme.containerDecoration(
                hasError: hasError,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(FormTheme.spacingS),
                    decoration: BoxDecoration(
                      color: FormTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(FormTheme.borderRadiusS),
                    ),
                    child: Icon(
                      icon,
                      color: FormTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: FormTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasFile ? fileName : hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasFile
                                ? FormTheme.secondaryColor
                                : FormTheme.hintColor,
                            fontSize: 14,
                            fontFamily: "AppFont",
                            fontWeight: hasFile ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: FormTheme.hintColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: FormTheme.spacingS, left: FormTheme.spacingXS),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: FormTheme.errorColor,
                ),
                SizedBox(width: FormTheme.spacingXS),
                Expanded(
                  child: Text(
                    errorText,
                    style: FormTheme.errorTextStyle,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: FormTheme.spacingM),
      ],
    );
  }
}

