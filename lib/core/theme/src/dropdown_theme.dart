import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/core/theme/src/input_decoration_theme.dart';

DropdownMenuThemeData get dropdownMenuThemeLight => DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationThemeLight,
      textStyle: TextStyle(fontSize: 14.sp, color: hintColorLight),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(cardColorLight),
        shape: WidgetStateProperty.all(AppRadius.circular16Shape),
        surfaceTintColor: WidgetStateProperty.all(dividerColorLight),
      ),
    );

DropdownMenuThemeData get dropdownMenuThemeDark => dropdownMenuThemeLight.copyWith(
      inputDecorationTheme: inputDecorationThemeDark,
      textStyle: TextStyle(fontSize: 14.sp, color: hintColorDark),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(cardColorDark),
        surfaceTintColor: WidgetStateProperty.all(dividerColorDark),
      ),
    );
