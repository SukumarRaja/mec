
import 'package:mec/Configs/Enum.dart';
import 'package:flutter/material.dart';

//-**********---------- WHATSAPP Color Theme: -------------------------
final mecBlack = new Color(0xFF1E1E1E);
final mecBlue = new Color(0xFF02ac88);
final mecDeepGreen = Color.fromRGBO(38, 142, 205, 1);
final mecLightGreen =Color.fromRGBO(79, 175, 192, 1);
final mecgreen = Color.fromRGBO(79, 175, 192, 1);
final mecteagreen = new Color(0xFFe9fedf);
final mecWhite = Colors.white;
final mecGrey = Color(0xff85959f);
final mecChatbackground = new Color(0xffe8ded5);
const DESIGN_TYPE = Themetype.whatsapp;
const IsSplashOnlySolidColor = false;
const SplashBackgroundSolidColor =  Color.fromRGBO(79, 175, 192, 1);//applies this colors to fill the areas around splash screen.  Color Code: 0xFF01826b for Whatsapp theme & 0xFFFFFFFF for messenger theme.
final statusBarColor = mecDeepGreen;
final isDarkIconsinStatusBar =
    false; // This Color will be applied to status bar across the App if App is messenger theme. For whatsapp theme, it picks the color automatically.

//*--Admob Configurations- (By default Test Ad Units pasted)----------
const IsBannerAdShow =
    false; // Set this to 'true' if you want to show Banner ads throughout the app
const Admob_BannerAdUnitID_Android =
    'ca-app-pub-3940256099942544/6300978111'; // Test Id: 'ca-app-pub-3940256099942544/6300978111'
const Admob_BannerAdUnitID_Ios =
    'ca-app-pub-3940256099942544/2934735716'; // Test Id: 'ca-app-pub-3940256099942544/2934735716'
const IsInterstitialAdShow =
    false; // Set this to 'true' if you want to show Interstitial ads throughout the app
const Admob_InterstitialAdUnitID_Android =
    'ca-app-pub-3940256099942544/1033173712'; // Test Id:  'ca-app-pub-3940256099942544/1033173712'
const Admob_InterstitialAdUnitID_Ios =
    'ca-app-pub-3940256099942544/4411468910'; // Test Id: 'ca-app-pub-3940256099942544/4411468910'
const IsVideoAdShow =
    false; // Set this to 'true' if you want to show Video ads throughout the app
const Admob_RewardedAdUnitID_Android =
    'ca-app-pub-3940256099942544/5224354917'; // Test Id: 'ca-app-pub-3940256099942544/5224354917'
const Admob_RewardedAdUnitID_Ios =
    'ca-app-pub-3940256099942544/1712485313'; // Test Id: 'ca-app-pub-3940256099942544/1712485313'
//Also don't forget to Change the Admob App Id in "mec/android/app/src/main/AndroidManifest.xml" & "mec/ios/Runner/Info.plist"

//*--Agora Configurations---
const Agora_APP_IDD =
    '337bb4522dbe4ebd9d7338668703035d'; // Grab it from: https://www.agora.io/en/
const dynamic Agora_TOKEN =
    null; // not required until you have planned to setup high level of authentication of users in Agora.

//*--Giphy Configurations---
const GiphyAPIKey =
    'MUlrfWiTuTJBr0V6rEU6Q9IgdloDTrMT'; // Grab it from: https://developers.giphy.com/

//*--App Configurations---
const Appname =
    'Mec'; //app name shown evrywhere with the app where required
const DEFAULT_COUNTTRYCODE_ISO =
    'IN'; //default country ISO 2 letter for login screen
const DEFAULT_COUNTTRYCODE_NUMBER =
    '+91'; //default country code number for login screen
const FONTFAMILY_NAME =
    null; // make sure you have registered the font in pubspec.yaml

//--WARNING----- PLEASE DONT EDIT THE BELOW LINES UNLESS YOU ARE A DEVELOPER -------
const SplashPath = 'assets/images/mec.png';
const AppLogoPath = 'assets/images/logo.png';
