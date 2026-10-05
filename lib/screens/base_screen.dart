import 'package:mashhorbazar/services/dashboard_service.dart';
import 'package:mashhorbazar/utils/colors.dart';
import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import 'receipts_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final List<String> namesKeys = const [
    "HOME",
    "TRANSACTIONS",
    "ORDERS",
    "NETWORK",
  ];

  final List<String> imagedata = const [
    "assets/icons/home.png",
    "assets/icons/transactiontype.png",
    "assets/icons/orders.png",
    "assets/icons/network.png",
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mashhorbazarBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    mypagecontroller.setUpdateIndexCallback((index) {
      if (!mounted) return;

      setState(() {
        selectedIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (mypagecontroller.pageStack.length > 1) {
          mypagecontroller.goBack();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.mashhorbazarBackground,
          extendBody: true,
          body: mypagecontroller.pageStack.last,

          /// ============================================================
          /// CENTER RECEIPT ACTION
          /// ============================================================
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openReceipts,
                borderRadius: BorderRadius.circular(100),
                child: Ink(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.28),
                        blurRadius: 24,
                        offset: const Offset(0, 9),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 27,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          /// ============================================================
          /// NEW BOTTOM NAVIGATION
          /// ============================================================
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              height: 78,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF183A64).withOpacity(0.10),
                    blurRadius: 26,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildNavItem(0)),
                  const SizedBox(width: 3),
                  Expanded(child: _buildNavItem(1)),

                  /// Space for center receipt action
                  const SizedBox(width: 54),

                  Expanded(child: _buildNavItem(2)),
                  const SizedBox(width: 3),
                  Expanded(child: _buildNavItem(3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// NAV ITEM
  /// ============================================================
  Widget _buildNavItem(int index) {
    final bool isSelected = mypagecontroller.lastSelectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        mypagecontroller.goToMainPageByIndex(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              height: 30,
              width: isSelected ? 34 : 30,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                imagedata[index],
                width: 19,
                height: 19,
                color: isSelected
                    ? Colors.white
                    : AppColors.fontColor.withOpacity(0.82),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 13,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: NText(
                  text: languagesController.tr(namesKeys[index]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  fontSize: 10.3,
                  height: 1.0,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.fontColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// RECEIPTS ACTION
  /// ============================================================
  void _openReceipts() {
    if (dashboardController.deactiveStatus.value.trim().toLowerCase() ==
        "deactivated") {
      Get.snackbar(
        dashboardController.deactiveStatus.toString(),
        dashboardController.deactivateMessage.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 1),
        icon: const Icon(Icons.block_rounded, color: Colors.white),
      );

      return;
    }

    mypagecontroller.changePage(const ReceiptsScreen(), isMainPage: false);
  }
}
