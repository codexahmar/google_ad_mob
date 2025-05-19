import 'package:flutter/material.dart';
import 'package:google_ad_mob/home_screen.dart';
import 'package:google_ad_mob/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize AdMob
  await MobileAds.instance.initialize();
  // Load ads
  AdUtils.loadInterstitialAd();
  AdUtils.loadRewardedAd();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
