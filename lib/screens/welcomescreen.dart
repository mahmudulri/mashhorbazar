import 'dart:async';

import 'package:mashhorbazar/global_controller/languages_controller.dart';
import 'package:mashhorbazar/global_controller/page_controller.dart';
import 'package:mashhorbazar/helpers/capture_image_helper.dart';
import 'package:mashhorbazar/routes/routes.dart';
import 'package:mashhorbazar/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/colors.dart';
import '../widgets/custom_text.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen>
    with SingleTickerProviderStateMixin {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  final GetStorage box = GetStorage();

  final PageController titlePageController = PageController();

  Timer? sliderTimer;

  int currentTitlePage = 0;

  /// ============================================================
  /// LOGO ANIMATION
  /// ============================================================
  late AnimationController logoAnimationController;
  late Animation<double> logoScaleAnimation;
  late Animation<double> logoMoveAnimation;
  late Animation<double> logoGlowAnimation;

  /// ============================================================
  /// 3 TITLE SLIDES
  /// ============================================================
  List<Map<String, String>> get titleSlides => [
    {
      "title": languagesController.tr("ALL_YOUR_FINANCIAL_SERVICES_IN_ONE_APP"),
      "subtitle": languagesController.tr(
        "RECHARGE_PAY_TRANSFER_AND_MANAGE_YOUR_EVERYDAY_PAYMENTS_EASILY",
      ),
    },
    {
      "title": languagesController.tr("FAST_AND_SECURE_MOBILE_RECHARGE"),
      "subtitle": languagesController.tr(
        "RECHARGE_AFGHANISTAN_TURKEY_AND_MORE_NETWORKS_QUICKLY_AND_SECURELY",
      ),
    },
    {
      "title": languagesController.tr("SIMPLE_PAYMENTS_ANYWHERE_ANYTIME"),
      "subtitle": languagesController.tr(
        "EVERYTHING_YOU_NEED_FOR_TELECOM_AND_DIGITAL_PAYMENTS_IN_ONE_PLACE",
      ),
    },
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.mashhorbazarBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    logoScaleAnimation = Tween<double>(begin: 0.97, end: 1.035).animate(
      CurvedAnimation(parent: logoAnimationController, curve: Curves.easeInOut),
    );

    logoMoveAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: logoAnimationController, curve: Curves.easeInOut),
    );

    logoGlowAnimation = Tween<double>(begin: 16, end: 34).animate(
      CurvedAnimation(parent: logoAnimationController, curve: Curves.easeInOut),
    );

    logoAnimationController.repeat(reverse: true);

    startAutoSlider();
  }

  /// ============================================================
  /// AUTO TITLE SLIDER
  /// ============================================================
  void startAutoSlider() {
    sliderTimer?.cancel();

    sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !titlePageController.hasClients) {
        return;
      }

      int nextPage = currentTitlePage + 1;

      if (nextPage >= titleSlides.length) {
        nextPage = 0;
      }

      titlePageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    titlePageController.dispose();
    logoAnimationController.dispose();

    super.dispose();
  }

  /// ============================================================
  /// EXIT POPUP
  /// ============================================================
  Future<bool> showExitPopup() async {
    if (mypagecontroller.pageStack.length > 1) {
      mypagecontroller.goBack();

      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        contentPadding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
        actionsPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        title: NText(
          text: languagesController.tr("EXIT_APP"),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0E2340),
        ),
        content: NText(
          text: languagesController.tr("DO_YOU_WANT_TO_EXIT_APP"),
          fontSize: 14,
          height: 1.5,
          color: const Color(0xFF6F7F94),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: NText(
              text: languagesController.tr("NO"),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6F7F94),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: NText(
              text: languagesController.tr("YES"),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  /// ============================================================
  /// CONTINUE
  /// ============================================================
  void showContinueOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.40),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7E1EE),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 22),

                Container(
                  height: 66,
                  width: 66,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      "assets/icons/logo.png",
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                NText(
                  text: "Welcome to mashhorbazar",
                  color: const Color(0xFF10233F),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 7),

                NText(
                  text: "Choose how you want to continue",
                  color: const Color(0xFF78879A),
                  fontSize: 13,
                  height: 1.4,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                bottomSheetButton(
                  title: languagesController.tr("REGISTER"),
                  filled: true,
                  onTap: () {
                    Get.back();

                    Get.to(() => const SignUpScreen());
                  },
                ),

                const SizedBox(height: 12),

                bottomSheetButton(
                  title: languagesController.tr("LOGIN"),
                  filled: false,
                  onTap: () {
                    Get.back();

                    Get.offAllNamed(signinscreen);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ============================================================
  /// BOTTOM SHEET BUTTON
  /// ============================================================
  Widget bottomSheetButton({
    required String title,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: filled ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: filled
                ? null
                : Border.all(
                    color: AppColors.primaryColor.withOpacity(0.18),
                    width: 1.2,
                  ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.20),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: NText(
              text: title,
              color: filled ? Colors.white : AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.mashhorbazarBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool compact = constraints.maxHeight < 700;

              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.mashhorbazarBackground,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: compact ? 54 : 58,
                      child: _buildHeroSection(compact: compact),
                    ),
                    Expanded(
                      flex: compact ? 46 : 42,
                      child: _buildBottomSection(compact: compact),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// NEW HERO SECTION
  /// ============================================================
  Widget _buildHeroSection({required bool compact}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, compact ? 8 : 12, 16, compact ? 4 : 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(compact ? 30 : 36),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B74E5),
              AppColors.primaryColor,
              Color(0xFF003C89),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.22),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(compact ? 30 : 36),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Decorative circles
              Positioned(
                top: -85,
                right: -55,
                child: _softCircle(
                  size: 210,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -70,
                child: _softCircle(
                  size: 240,
                  color: AppColors.mashhorbazarLight.withOpacity(0.14),
                ),
              ),
              Positioned(
                top: 60,
                left: -65,
                child: _softCircle(
                  size: 150,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),

              /// Tiny decorative dots
              Positioned(top: 28, left: 30, child: _decorativeDot(8, 0.22)),
              Positioned(top: 52, left: 52, child: _decorativeDot(5, 0.14)),
              Positioned(right: 34, bottom: 40, child: _decorativeDot(7, 0.18)),

              /// Main visual
              Center(child: _logoSection(compact: compact)),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// CENTER LOGO VISUAL
  /// ============================================================
  Widget _logoSection({required bool compact}) {
    return AnimatedBuilder(
      animation: logoAnimationController,
      builder: (context, child) {
        final double canvasSize = compact ? 300 : 340;
        final double logoSize = compact ? 132 : 152;

        return SizedBox(
          height: canvasSize,
          width: canvasSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              /// Soft rings behind main logo
              Container(
                height: compact ? 214 : 238,
                width: compact ? 214 : 238,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
              ),
              Container(
                height: compact ? 176 : 196,
                width: compact ? 176 : 196,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.11),
                    width: 1,
                  ),
                ),
              ),

              /// Center glow
              Container(
                height: logoSize + 60,
                width: logoSize + 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.20),
                      Colors.white.withOpacity(0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// Center logo
              Transform.translate(
                offset: Offset(0, logoMoveAnimation.value),
                child: Transform.scale(
                  scale: logoScaleAnimation.value,
                  child: Container(
                    height: logoSize,
                    width: logoSize,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(compact ? 36 : 42),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.08),
                          blurRadius: logoGlowAnimation.value,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(compact ? 30 : 35),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(compact ? 24 : 29),
                        child: Image.asset(
                          "assets/icons/logo.png",
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ============================================================
  /// NEW BOTTOM CONTENT SECTION
  /// ============================================================
  Widget _buildBottomSection({required bool compact}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        compact ? 12 : 18,
        22,
        compact ? 16 : 22,
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: titlePageController,
              itemCount: titleSlides.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentTitlePage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = titleSlides[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NText(
                      text: item["title"] ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: const Color(0xFF10233F),
                      fontSize: compact ? 22 : 25,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: compact ? 7 : 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: NText(
                        text: item["subtitle"] ?? "",
                        textAlign: TextAlign.center,
                        maxLines: compact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xFF7B899B),
                        fontSize: compact ? 12 : 12.5,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: compact ? 6 : 10),

          /// Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(titleSlides.length, (index) {
              final isSelected = currentTitlePage == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: isSelected ? 28 : 6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),

          SizedBox(height: compact ? 14 : 20),

          /// Continue button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: showContinueOptions,
              borderRadius: BorderRadius.circular(17),
              child: Ink(
                height: compact ? 52 : 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: NText(
                            text: languagesController.tr("CONTINUE"),
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// DECORATIVE HELPERS
  /// ============================================================
  Widget _softCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _decorativeDot(double size, double opacity) {
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
