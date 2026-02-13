import 'package:flutter/material.dart';

// Primary — Royal Blue (from design)
const Color primaryColor = Color(0xFF4361EE);
const Color primaryLight = Color(0xFFE8ECFD);
const Color secondaryColor = Color(0xFF3A56D4);

// Income / Expense
const Color incomeColor = Color(0xFF2E7D32);
const Color expenseColor = Color(0xFFD32F2F);

// Background
const Color backgroundColorLight = Color(0xFFF5F7FA);
const Color backgroundColorDark = Color(0xFF121212);

// Card
const Color cardColorLight = Color(0xFFFFFFFF);
const Color cardColorDark = Color(0xFF1E1E1E);

const Color transparent = Colors.transparent;

// Shadow
const Color shadowColorLight = Color(0xFFE0E4EC);
const Color shadowColorDark = Color(0xFF000000);

// Divider
const Color dividerColorLight = Color(0xFFE8ECF0);
const Color dividerColorDark = Color(0xFF2A2A2A);

// Disabled
const Color disabledColorLight = Color(0xffA0A0A0);
Color disabledColorDark = const Color(0xFFB0B0B0);

// Hint
const Color hintColorLight = Color(0xFF8E99A4);
const Color hintColorDark = Color(0xFF6B7280);

// Text
const Color textColorLight = Color(0xFF1A1D1F);
const Color textColorDark = Color(0xFFF3F3F3);

// Icon
const Color iconColorLight = Color(0xFF6B7280);
const Color iconColorDark = Color(0xFF9CA3AF);

// Category chart colors
const Color chartBlue = Color(0xFF4361EE);
const Color chartGreen = Color(0xFF2EC4B6);
const Color chartOrange = Color(0xFFFF9F1C);
const Color chartPink = Color(0xFFFF6B6B);
const Color chartPurple = Color(0xFFA29BFE);

// Gradient
LinearGradient get primaryGradient => const LinearGradient(
      colors: [Color(0xFF5A75F0), primaryColor],
      stops: [0.0, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
