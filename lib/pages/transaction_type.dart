import 'package:mashhorbazar/controllers/dashboard_controller.dart';
import 'package:mashhorbazar/controllers/transaction_controller.dart';
import 'package:mashhorbazar/global_controller/languages_controller.dart';
import 'package:mashhorbazar/global_controller/page_controller.dart';
import 'package:mashhorbazar/screens/commission_transfer_screen.dart';
import 'package:mashhorbazar/screens/hawala_list_screen.dart';
import 'package:mashhorbazar/screens/hawala_rates_screen.dart';
import 'package:mashhorbazar/screens/loan_screen.dart';
import 'package:mashhorbazar/screens/receipts_screen.dart';
import 'package:mashhorbazar/screens/withdraw_screen.dart';
import 'package:mashhorbazar/utils/colors.dart';
import 'package:mashhorbazar/widgets/bottomsheet.dart';
import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  const TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final TransactionController transactionController =
      Get.find<TransactionController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.mashhorbazarTurquoise,
          onRefresh: () async {
            dashboardController.fetchDashboardData();

            await Future<void>.delayed(const Duration(milliseconds: 450));
          },
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
            children: [
              /// =========================================================
              /// HEADER
              /// =========================================================
              _buildHeader(),

              const SizedBox(height: 16),

              /// =========================================================
              /// TOP HERO
              /// =========================================================
              _buildHeroCard(),

              const SizedBox(height: 22),

              /// =========================================================
              /// SECTION TITLE
              /// =========================================================
              Row(
                children: [
                  Expanded(
                    child: NText(
                      text: languagesController.tr("TRANSACTIONS_TYPE"),
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.mashhorbazarTurquoise.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 18,
                      color: AppColors.mashhorbazarTurquoise,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// =========================================================
              /// ACTIONS
              /// =========================================================
              _actionTile(
                title: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
                imagePath: "assets/icons/wallet.png",
                iconBackground: const Color(0xFFE7F8F0),
                onTap: () {
                  _openProtectedPage(ReceiptsScreen());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("REQUES_LOAN_BALANCE"),
                imagePath: "assets/icons/transactionsicon.png",
                iconBackground: const Color(0xFFEAF2FF),
                onTap: () {
                  _openProtectedPage(RequestLoanScreen());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("HAWALA"),
                imagePath: "assets/icons/exchange.png",
                iconBackground: const Color(0xFFFFF2E6),
                onTap: () {
                  _openProtectedPage(HawalaListScreen());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("HAWALA_RATES"),
                imagePath: "assets/icons/exchange-rate.png",
                iconBackground: const Color(0xFFEDF0FF),
                onTap: () {
                  _openProtectedPage(HawalaCurrencyScreen());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("BALANCE_TRANSACTIONS"),
                imagePath: "assets/icons/transactionsicon.png",
                iconBackground: const Color(0xFFFFECEF),
                onTap: () {
                  _openProtectedPage(Transactions());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("TRANSFER_COMISSION_TO_BALANCE"),
                imagePath: "assets/icons/transactionsicon.png",
                iconBackground: const Color(0xFFF2ECFF),
                onTap: () {
                  _openProtectedPage(CommissionTransferScreen());
                },
              ),

              const SizedBox(height: 10),

              _actionTile(
                title: languagesController.tr("WITHDRAW"),
                imagePath: "assets/icons/wallet.png",
                iconBackground: const Color(0xFFE8FAFC),
                onTap: () {
                  _openProtectedPage(WithdrawScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// HEADER
  /// ============================================================
  Widget _buildHeader() {
    return Row(
      children: [
        Obx(() {
          final profileImageUrl = dashboardController
              .alldashboardData
              .value
              .data
              ?.userInfo
              ?.profileImageUrl;

          return Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mashhorbazarBackground,
              border: Border.all(
                color: AppColors.mashhorbazarTurquoise.withOpacity(0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              image: profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profileImageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profileImageUrl == null || profileImageUrl.isEmpty
                ? const Icon(
                    Icons.person_rounded,
                    color: AppColors.primaryColor,
                    size: 25,
                  )
                : null,
          );
        }),

        const SizedBox(width: 12),

        Expanded(
          child: NText(
            text: languagesController.tr("TRANSACTIONS_TYPE"),
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 10),

        GestureDetector(
          onTap: () {
            CustomFullScreenSheet.show(context);
          },
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.mashhorbazarBackground,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.mashhorbazarTurquoise.withOpacity(0.12),
              ),
            ),
            alignment: Alignment.center,
            child: Image.asset("assets/icons/drawericon.png", height: 25),
          ),
        ),
      ],
    );
  }

  /// ============================================================
  /// HERO
  /// ============================================================
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primarycolor2,
            AppColors.mashhorbazarTurquoise,
            AppColors.mashhorbazarAccent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mashhorbazarTurquoise.withOpacity(0.20),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -45,
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            left: -30,
            bottom: -55,
            child: Container(
              height: 135,
              width: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: languagesController.tr("TRANSACTIONS_TYPE"),
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    NText(
                      text: languagesController.tr("TRANSACTIONS"),
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// ACTION TILE
  /// ============================================================
  Widget _actionTile({
    required String title,
    required String imagePath,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.065),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.055),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: NText(
                  text: title,
                  color: AppColors.primaryColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  height: 1.25,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.mashhorbazarBackground,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.mashhorbazarTurquoise,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// DEACTIVATED CHECK + NAVIGATION
  /// ============================================================
  void _openProtectedPage(Widget page) {
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

    mypagecontroller.changePage(page, isMainPage: false);
  }
}
