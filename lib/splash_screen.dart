import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mashhorbazar/controllers/dashboard_controller.dart';
import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final GetStorage box = GetStorage();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  Future<void> checkData() async {
    /// Previously selected language
    final String languageShortName = box.read("language") ?? "En";

    /// Find language information
    final matchedLang = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {
        "name": "En",
        "fullname": "English",
        "isoCode": "en",
        "region": "US",
        "direction": "ltr",
      },
    );

    final String isoCode = matchedLang["isoCode"] ?? "en";

    final String region = matchedLang["region"] ?? "US";

    final String direction = matchedLang["direction"] ?? "ltr";

    /// Save language information
    await box.write("language", languageShortName);

    await box.write("language_iso", isoCode);

    await box.write("language_region", region);

    await box.write("direction", direction);

    /// Load internal translations
    languagesController.changeLanguage(languageShortName);

    final Locale locale = Locale(isoCode, region);

    if (!mounted) return;

    await EasyLocalization.of(context)!.setLocale(locale);

    print("🌐 API Language: ${box.read("language_iso")}");

    /// Check authentication
    if (box.read('userToken') == null) {
      Get.offAllNamed(welcomescreen);
    } else {
      dashboardController.fetchDashboardData();

      Get.offAllNamed(basescreen);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          checkData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/icons/logo.png", height: 180)),
    );
  }
}
