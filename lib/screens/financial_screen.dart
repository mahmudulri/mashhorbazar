import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/helpers/money_format_helper.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';
import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';

import '../global_controller/page_controller.dart';

class FinancialScreen extends StatelessWidget {
  FinancialScreen({super.key});

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _currencyCode() {
    final value = box.read('currency_code');

    final code = value?.toString().trim() ?? '';

    if (code.isEmpty || code.toLowerCase() == 'null') {
      return '--';
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      backgroundColor: AppColors.mashhorbazarBackground,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final dashboardData = dashboardController.alldashboardData.value.data;

          final currencyCode = _currencyCode();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildTopHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildOverviewCard(
                      formattedDate: formattedDate,
                      currencyCode: currencyCode,
                      balance:
                          dashboardController.userBalanceController.balance,
                    ),
                    const SizedBox(height: 14),
                    _buildSectionHeader(),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = (constraints.maxWidth - 10) / 2;

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: _FinancialMetricCard(
                                icon: Icons.shopping_bag_outlined,
                                label: languagesController.tr('SALE'),
                                amount: dashboardData?.totalSoldAmount,
                                currencyCode: currencyCode,
                                accentColor: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _FinancialMetricCard(
                                icon: Icons.call_made_rounded,
                                label: languagesController.tr('DEBIT'),
                                amount: dashboardData?.totalSoldAmount,
                                currencyCode: currencyCode,
                                accentColor: const Color(0xFFE05263),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _FinancialMetricCard(
                                icon: Icons.trending_up_rounded,
                                label: languagesController.tr('PROFIT'),
                                amount: dashboardData?.totalRevenue,
                                currencyCode: currencyCode,
                                accentColor: const Color(0xFF19A766),
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _FinancialMetricCard(
                                icon: Icons.account_balance_outlined,
                                label: languagesController.tr('LOAN_BALANCE'),
                                amount: dashboardData?.loanBalance,
                                currencyCode: currencyCode,
                                accentColor: const Color(0xFF7C5CD6),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 11),
                    _buildCommissionCard(
                      amount: dashboardData?.userInfo?.totalearning,
                      currencyCode: currencyCode,
                    ),
                    const SizedBox(height: 28),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
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
            top: -55,
            right: -45,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            children: [
              _topHeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: mypagecontroller.goBack,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: languagesController.tr('FINANCIAL_REPORT'),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    NText(
                      text: languagesController.tr('BALANCE'),
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              _topHeaderButton(
                icon: Icons.menu_rounded,
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
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

  Widget _buildOverviewCard({
    required String formattedDate,
    required String currencyCode,
    required dynamic balance,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primaryColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: languagesController.tr('BALANCE'),
                  color: const Color(0xFF172D49),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: NText(
                  text: currencyCode,
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NText(
            text: '${formatMoney(balance)} $currencyCode',
            color: const Color(0xFF10233F),
            fontSize: 27,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _overviewMeta(
                    icon: Icons.calendar_today_outlined,
                    label: languagesController.tr('DATE'),
                    value: formattedDate,
                  ),
                ),
                Container(
                  height: 30,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: const Color(0xFFE1E8F0),
                ),
                Expanded(
                  child: _overviewMeta(
                    icon: Icons.currency_exchange_rounded,
                    label: languagesController.tr('CURRENCY'),
                    value: currencyCode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewMeta({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 14, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NText(
                text: label,
                color: AppColors.fontColor,
                fontSize: 7.5,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              NText(
                text: value,
                color: const Color(0xFF263B54),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
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
            Icons.analytics_outlined,
            size: 17,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: NText(
            text: languagesController.tr('FINANCIAL_REPORT'),
            color: const Color(0xFF172D49),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionCard({
    required dynamic amount,
    required String currencyCode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: NText(
              text: languagesController.tr('COMISSION'),
              color: const Color(0xFF172D49),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: NText(
              text: '${formatMoney(amount)} $currencyCode',
              color: AppColors.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialMetricCard extends StatelessWidget {
  const _FinancialMetricCard({
    required this.icon,

    required this.label,

    required this.amount,

    required this.currencyCode,

    required this.accentColor,
  });

  final IconData icon;

  final String label;

  final dynamic amount;

  final String currencyCode;

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 106),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.03),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 17),
          ),
          const SizedBox(height: 10),
          NText(
            text: label,
            color: AppColors.fontColor,
            fontSize: 8.7,
            fontWeight: FontWeight.w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          NText(
            text: formatMoney(amount),
            color: const Color(0xFF172D49),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          NText(
            text: currencyCode,
            color: accentColor,
            fontSize: 8,
            fontWeight: FontWeight.w700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
