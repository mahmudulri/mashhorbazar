import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mashhorbazarBackground,

        statusBarIconBrightness: Brightness.dark,

        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: AppColors.mashhorbazarBackground,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  String _safeValue(dynamic value) {
    final text = value?.toString() ?? "";

    if (text == "null") {
      return "";
    }

    return text;
  }

  String _moneyValue(dynamic value) {
    final currencyCode = box.read("currency_code")?.toString() ?? "";

    final amount = _safeValue(value);

    if (amount.isEmpty) {
      return currencyCode;
    }

    if (currencyCode.isEmpty) {
      return amount;
    }

    return "$amount $currencyCode";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dashboardData = dashboardController.alldashboardData.value.data;

      final userInfo = dashboardData?.userInfo;

      final profileImageUrl = userInfo?.profileImageUrl?.toString();

      final hasProfileImage =
          profileImageUrl != null &&
          profileImageUrl != "null" &&
          profileImageUrl.trim().isNotEmpty;

      return Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerWidget(),
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.mashhorbazarBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 28),
                  children: [
                    _buildProfileHero(
                      profileImageUrl: profileImageUrl,
                      hasProfileImage: hasProfileImage,
                      resellerName: _safeValue(userInfo?.resellerName),
                      email: _safeValue(userInfo?.email),
                      phone: _safeValue(userInfo?.phone),
                    ),
                    const SizedBox(height: 14),
                    _buildSectionLabel(languagesController.tr("BALANCE")),
                    const SizedBox(height: 9),
                    ProfileBox(
                      icon: Icons.account_balance_wallet_outlined,
                      boxName: languagesController.tr("BALANCE"),
                      data: _moneyValue(userInfo?.balance),
                      highlight: true,
                    ),
                    ProfileBox(
                      icon: Icons.account_balance_outlined,
                      boxName: languagesController.tr("LOAN_BALANCE"),
                      data: _moneyValue(userInfo?.loanBalance),
                    ),
                    ProfileBox(
                      icon: Icons.trending_up_rounded,
                      boxName: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                      data: _moneyValue(dashboardData?.totalSoldAmount),
                    ),
                    ProfileBox(
                      icon: Icons.show_chart_rounded,
                      boxName: languagesController.tr("TOTAL_REVENUE"),
                      data: _moneyValue(dashboardData?.totalRevenue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C78E8),
            AppColors.primaryColor,
            Color(0xFF004494),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -46,
            top: -60,
            child: Container(
              height: 145,
              width: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            children: [
              _headerButton(
                onTap: () {
                  mypagecontroller.goBack();
                },
                icon: Icons.arrow_back_rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("PROFILE"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("BALANCE"),
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _headerButton(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icons.menu_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton({required VoidCallback onTap, required IconData icon}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
      ),
    );
  }

  Widget _buildProfileHero({
    required String? profileImageUrl,
    required bool hasProfileImage,
    required String resellerName,
    required String email,
    required String phone,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 82,
            width: 82,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.10),
              ),
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: hasProfileImage
                  ? Image.network(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _profilePlaceholder();
                      },
                    )
                  : _profilePlaceholder(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                NText(
                  text: resellerName,
                  color: const Color(0xFF172D49),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _businessCardInfo(icon: Icons.email_outlined, value: email),
                ],
                if (phone.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _businessCardInfo(icon: Icons.phone_outlined, value: phone),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _businessCardInfo({required IconData icon, required String value}) {
    return Row(
      children: [
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 14),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: NText(
            text: value,
            color: AppColors.fontColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      color: AppColors.secondaryColor,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.primaryColor,
        size: 44,
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primaryColor,
            size: 17,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: NText(
            text: title,
            color: const Color(0xFF172D49),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class ProfileBox extends StatelessWidget {
  const ProfileBox({
    super.key,

    required this.boxName,

    required this.data,

    required this.icon,

    this.highlight = false,
  });

  final String boxName;

  final String data;

  final IconData icon;

  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final background = highlight ? AppColors.secondaryColor : Colors.white;

    final iconBackground = highlight
        ? AppColors.primaryColor
        : AppColors.secondaryColor;

    final iconColor = highlight ? Colors.white : AppColors.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: highlight
              ? AppColors.primaryColor.withOpacity(0.10)
              : const Color(0xFFE9EEF5),
        ),
        boxShadow: highlight
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF153C68).withOpacity(0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: NText(
              text: boxName,
              color: AppColors.fontColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: NText(
              text: data,
              color: const Color(0xFF172D49),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
