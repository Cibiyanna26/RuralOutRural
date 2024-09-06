import "package:flutter/material.dart";

class MaterialTheme {
  final String fontFamily;
  const MaterialTheme(this.fontFamily);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF027FFF),
      surfaceTint: Color(0xff425e91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd7e2ff),
      onPrimaryContainer: Color(0xff001b3f),
      secondary: Color(0xff565e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdae2f9),
      onSecondaryContainer: Color(0xff131c2c),
      tertiary: Color(0xff705574),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffad8fd),
      onTertiaryContainer: Color(0xff29132e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff1a1c20),
      onSurfaceVariant: Color(0xff44474e),
      outline: Color(0xff74777f),
      outlineVariant: Color(0xffc4c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffabc7ff),
      primaryFixed: Color(0xffd7e2ff),
      onPrimaryFixed: Color(0xff001b3f),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff294677),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2c),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff29132e),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff573e5b),
      surfaceDim: Color(0xffd9d9e0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe8e7ee),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF027FFF),
      surfaceTint: Color(0xffabc7ff),
      onPrimary: Color(0xff0d2f5f),
      primaryContainer: Color(0xff294677),
      onPrimaryContainer: Color(0xffd7e2ff),
      secondary: Color(0xffbec6dc),
      onSecondary: Color(0xff283041),
      secondaryContainer: Color(0xff3e4759),
      onSecondaryContainer: Color(0xffdae2f9),
      tertiary: Color(0xffddbce0),
      onTertiary: Color(0xff3f2844),
      tertiaryContainer: Color(0xff573e5b),
      onTertiaryContainer: Color(0xfffad8fd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff425e91),
      primaryFixed: Color(0xffd7e2ff),
      onPrimaryFixed: Color(0xff001b3f),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff294677),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2c),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff29132e),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff573e5b),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1c20),
      surfaceContainer: Color(0xff1e2025),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}
