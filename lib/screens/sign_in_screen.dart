import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mashhorbazar/screens/sign_up_screen.dart';
import 'package:mashhorbazar/utils/colors.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/languages_controller.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/custom_text.dart';
import '../widgets/socialbuttonbox.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final box = GetStorage();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final SignInController signInController = Get.find<SignInController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final String phoneNumber = "+93708488200";

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.mashhorbazarBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// ============================================================
  /// BACK BUTTON
  /// ============================================================
  Future<bool> showExitPopup() async {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }

    return true;
  }

  /// ============================================================
  /// LANGUAGE POPUP
  /// ============================================================
  void showLanguagePopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.38),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 520),
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10233F).withOpacity(0.16),
                  blurRadius: 35,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NText(
                        text: languagesController.tr("LANGUAGES"),
                        color: const Color(0xFF10233F),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF718096),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: languagesController.alllanguagedata.length,
                    itemBuilder: (context, index) {
                      final data = languagesController.alllanguagedata[index];

                      final String languageName = data["name"].toString();

                      final bool selected =
                          languagesController.selectedlan.value == languageName;

                      return GestureDetector(
                        onTap: () {
                          selectLanguage(data);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),

                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.secondaryColor
                                : const Color(0xFFF8FAFD),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primaryColor.withOpacity(0.28)
                                  : const Color(0xFFE9EEF5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 34,
                                width: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primaryColor
                                        : const Color(0xFFE5EAF1),
                                  ),
                                ),
                                child: NText(
                                  text: languageName.isNotEmpty
                                      ? languageName
                                            .substring(0, 1)
                                            .toUpperCase()
                                      : "L",
                                  color: selected
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: NText(
                                  text: data["fullname"].toString(),
                                  color: const Color(0xFF26384F),
                                  fontSize: 14,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primaryColor,
                                  size: 21,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ============================================================
  /// SELECT LANGUAGE
  /// ============================================================
  void selectLanguage(Map<String, dynamic> data) {
    final languageName = data["name"].toString();

    final matched = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageName,
      orElse: () => {"isoCode": "en", "direction": "ltr"},
    );

    final languageISO = matched["isoCode"] ?? "en";
    final languageDirection = matched["direction"] ?? "ltr";

    languagesController.changeLanguage(languageName);

    box.write("language", languageName);
    box.write("direction", languageDirection);

    Locale locale;

    switch (languageISO) {
      case "fa":
        locale = const Locale("fa", "IR");
        break;

      case "ar":
        locale = const Locale("ar", "AE");
        break;

      case "ps":
        locale = const Locale("ps", "AF");
        break;

      case "tr":
        locale = const Locale("tr", "TR");
        break;

      case "bn":
        locale = const Locale("bn", "BD");
        break;

      case "en":
      default:
        locale = const Locale("en", "US");
    }

    EasyLocalization.of(context)!.setLocale(locale);

    Navigator.pop(context);

    setState(() {});
  }

  /// ============================================================
  /// WHATSAPP
  /// ============================================================
  Future<void> whatsapp() async {
    const contact = "+93708488200";

    final androidUrl =
        "whatsapp://send?phone=$contact&text=Hi, I need some help";

    final iosUrl =
        "https://wa.me/$contact?text=${Uri.encodeComponent('Hi, I need some help')}";

    try {
      final Uri url = Uri.parse(Platform.isIOS ? iosUrl : androidUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("WhatsApp Error: $e");
    }
  }

  /// ============================================================
  /// LOGIN
  /// ============================================================
  Future<void> loginNow() async {
    if (signInController.usernameController.text.trim().isEmpty ||
        signInController.passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Oops!",
        "Fill the text fields",
        backgroundColor: const Color(0xFF10233F),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    await signInController.signIn();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.mashhorbazarBackground,
        body: Stack(
          children: [
            /// =====================================================
            /// BACKGROUND
            /// =====================================================
            Positioned.fill(
              child: Container(color: AppColors.mashhorbazarBackground),
            ),

            /// =====================================================
            /// TOP BLUE HERO
            /// =====================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 285,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D78E8),
                      AppColors.primaryColor,
                      Color(0xFF00469B),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                    bottomRight: Radius.circular(48),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -80,
                      right: -60,
                      child: _heroCircle(size: 220, opacity: 0.07),
                    ),
                    Positioned(
                      top: 85,
                      left: -90,
                      child: _heroCircle(size: 210, opacity: 0.05),
                    ),
                    Positioned(right: 34, bottom: 45, child: _heroDot(8, 0.20)),
                    Positioned(right: 58, bottom: 68, child: _heroDot(5, 0.13)),
                  ],
                ),
              ),
            ),

            /// =====================================================
            /// MAIN CONTENT
            /// =====================================================
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  children: [
                    /// =================================================
                    /// TOP BAR
                    /// =================================================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(children: [const Spacer(), languageButton()]),
                    ),

                    const SizedBox(height: 18),

                    /// =================================================
                    /// LOGO + HERO TEXT
                    /// =================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            height: 84,
                            width: 84,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.asset(
                                  "assets/icons/logo.png",
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          NText(
                            text: languagesController.tr("LOGIN"),
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 6),
                          NText(
                            text: languagesController.tr(
                              "PLEASE_ENTER_YOUR_INFORMATION",
                            ),
                            textAlign: TextAlign.center,
                            color: Colors.white.withOpacity(0.72),
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// =================================================
                    /// FLOATING LOGIN CARD
                    /// =================================================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE9EEF5)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF173B66).withOpacity(0.10),
                            blurRadius: 35,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Username label
                          NText(
                            text: languagesController.tr("USERNAME"),
                            color: const Color(0xFF31445D),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 8),

                          premiumTextField(
                            controller: signInController.usernameController,
                            hintText: languagesController.tr("USERNAME"),
                            icon: Icons.person_outline_rounded,
                            obscureText: false,
                          ),

                          const SizedBox(height: 17),

                          /// Password label
                          NText(
                            text: languagesController.tr("PASSWORD"),
                            color: const Color(0xFF31445D),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 8),

                          premiumTextField(
                            controller: signInController.passwordController,
                            hintText: languagesController.tr("PASSWORD"),
                            icon: Icons.lock_outline_rounded,
                            obscureText: !isPasswordVisible,
                            suffix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// Password recovery
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: whatsapp,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: NText(
                                  text: languagesController.tr(
                                    "PASSWORD_RECOVERY",
                                  ),
                                  color: AppColors.primaryColor,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Login button
                          GestureDetector(
                            onTap: loginNow,
                            child: Container(
                              height: 56,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(17),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.24,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 9),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Center(
                                        child: Obx(
                                          () => NText(
                                            text:
                                                signInController
                                                        .isLoading
                                                        .value ==
                                                    false
                                                ? languagesController.tr(
                                                    "LOGIN",
                                                  )
                                                : languagesController.tr(
                                                    "PLEASE_WAIT",
                                                  ),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// Divider
                          Row(
                            children: [
                              Expanded(child: dividerLine()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: NText(
                                  text: languagesController.tr("OR"),
                                  color: const Color(0xFF9AA7B7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(child: dividerLine()),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// Register
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                NText(
                                  text: languagesController.tr(
                                    "HAVE_NOT_REGISTERED_YET",
                                  ),
                                  textAlign: TextAlign.center,
                                  color: const Color(0xFF7C899A),
                                  fontSize: 13.5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const SignUpScreen());
                                  },
                                  child: NText(
                                    text: languagesController.tr("REGISTER"),
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// =================================================
                    /// SUPPORT
                    /// =================================================
                    NText(
                      text: languagesController.tr("FIND_US_ON"),
                      color: const Color(0xFF8C99AA),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 13),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        supportButton(
                          onTap: whatsapp,
                          child: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Color(0xFF25D366),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        supportButton(
                          onTap: () {
                            showSocialPopup(context);
                          },
                          child: Image.asset(
                            "assets/icons/social-media.png",
                            height: 23,
                            width: 23,
                          ),
                        ),
                        const SizedBox(width: 12),
                        supportButton(
                          onTap: () {
                            _makePhoneCall(phoneNumber);
                          },
                          child: const Icon(
                            Icons.call_outlined,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// LANGUAGE BUTTON
  /// ============================================================
  Widget languageButton() {
    return GestureDetector(
      onTap: showLanguagePopup,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, color: Colors.white, size: 19),
            const SizedBox(width: 8),
            Obx(
              () => NText(
                text: languagesController.selectedlan.value,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// PREMIUM TEXT FIELD
  /// ============================================================
  Widget premiumTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
    Widget? suffix,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 1.1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF20344F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                hintStyle: const TextStyle(
                  color: Color(0xFFA1ADBC),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 8),
            suffix,
            const SizedBox(width: 11),
          ] else
            const SizedBox(width: 14),
        ],
      ),
    );
  }

  /// ============================================================
  /// DIVIDER
  /// ============================================================
  Widget dividerLine() {
    return Container(height: 1, color: const Color(0xFFE6ECF3));
  }

  /// ============================================================
  /// SUPPORT BUTTON
  /// ============================================================
  Widget supportButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE4EAF2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF183A64).withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  /// ============================================================
  /// HERO DECORATION
  /// ============================================================
  Widget _heroCircle({required double size, required double opacity}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _heroDot(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

/// ============================================================
/// PHONE CALL
/// ============================================================
Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
