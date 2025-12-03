import 'package:flutter/material.dart';

// - FONT SIZES
const VeryLargeTextSize = 30.0;
const LargeTextSize = 24.0;
const SemiLargeTextSize = 20.0; //
const MediumTextSize = 18.0;
const BodyTextSize = 16.0;
const SmallTextSize = 14.0;

// - COLORS
const BackgroundScreenColorGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromRGBO(32, 72, 142, 1.0),
      Color.fromRGBO(49, 93, 169, 1.0)
    ] // Degradado de azules
    );
const ButtonWhiteScreenColorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(255, 255, 255, 1.0),
      Color.fromRGBO(199, 199, 199, 1.0)
    ] // Degradado de azules
    );
const BackgroundScreenColor = Color(0xffF4F4F9);
const BackgroundItemColor = Color.fromRGBO(32, 72, 142, 1);
const PrimaryThemeColor = Color.fromRGBO(32, 72, 142, 1); // Azul principal
const SecondaryThemeColor =
    Color.fromRGBO(240, 201, 28, 1); // Amarillo, MEJOR OPCION: 252, 202, 0
const TertiaryThemeColor = Color.fromRGBO(49, 93, 169, 1); // Azul secundario
const BarHeaderPage = Color.fromRGBO(36, 65, 113, 1); // Azul obscuro
const ScrollColor = Color.fromRGBO(34, 74, 145, 0.95); // Azul para scroll
const DisabledThemeColor = Color.fromRGBO(218, 218, 218, 1); // Plomo

// - Font Family
const String DefaultFontFamily = 'Helvetica';

// STYLES FOR WIDGETS
const AppBarTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: SemiLargeTextSize,
  color: Colors.white,
);

const BodyTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontWeight: FontWeight.w400,
  fontSize: BodyTextSize,
  color: Colors.black,
);

// TEXTO BLANCO NORMAL PARA ETIQUETAS
const LabelLightNormalInputTextStyle = TextStyle(
    fontFamily: DefaultFontFamily,
    fontSize: BodyTextSize,
    color: PrimaryThemeColor);

// TEXTO BLANCO NEGRITA PARA ETIQUETAS
const LabelLightBoldInputTextStyle = TextStyle(
    fontFamily: DefaultFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: MediumTextSize,
    color: Colors.white);

// TEXTO AZUL PRIMARIO NEGRITA PARA ETIQUETAS
const LabelBlueNormalInputTextStyle = TextStyle(
    fontFamily: DefaultFontFamily,
    fontSize: BodyTextSize,
    color: PrimaryThemeColor);
const LabelBlueNormalInput = TextStyle(
    fontFamily: DefaultFontFamily,
    fontSize: BodyTextSize,
    color: PrimaryThemeColor);
const LabelBlueNormalInputText = TextStyle(
    fontFamily: DefaultFontFamily,
    fontSize: BodyTextSize,
    color: PrimaryThemeColor);

// TEXTO SMALL AZUL PRIMARIO NEGRITA PARA ETIQUETAS
const LabelSMBlueNormalInputTextStyle = TextStyle(
    fontFamily: DefaultFontFamily, fontSize: 15, color: PrimaryThemeColor);

const LabelBlueBoldInputTextStyle = TextStyle(
    fontFamily: DefaultFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: BodyTextSize,
    color: PrimaryThemeColor);

// TEXTO BLANCO SUBTITULOS
const SemiTitleLightTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontSize: SemiLargeTextSize,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

const TitleLightTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontSize: LargeTextSize,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

// TEXTO BLANCO SUBTITULOS
const SemiTitleBlueTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontSize: SemiLargeTextSize,
  fontWeight: FontWeight.w500,
  color: PrimaryThemeColor,
);

// TEXTO BLANCO PARA BOTONES
const BtnLightTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontSize: BodyTextSize,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

// TEXTO AZUL PRIMARIO PARA BOTONES
const BtnBlueTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontSize: BodyTextSize,
  fontWeight: FontWeight.w500,
  color: PrimaryThemeColor,
);

const SnackBarInfoTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 17,
  color: Colors.white,
);

const SnackBarErrorTextStyle = TextStyle(
  fontFamily: DefaultFontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 17,
  color: SecondaryThemeColor,
);
