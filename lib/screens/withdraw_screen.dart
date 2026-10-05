import 'package:mashhorbazar/controllers/withdrawlist_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'create_withdraw_screen.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final WithdrawlistController withdrawlistController = Get.put(
    WithdrawlistController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

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

    withdrawlistController.fetchlist();
  }

  Future<void> _refreshWithdrawals() async {
    withdrawlistController.fetchlist();

    await Future<void>.delayed(const Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 10),
            _buildCreateWithdrawBlock(),
            const SizedBox(height: 10),
            Expanded(child: _buildWithdrawList()),
          ],
        ),
      ),
    );
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
      child: Row(
        children: [
          _headerButton(
            onTap: mypagecontroller.goBack,
            icon: Icons.arrow_back_rounded,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                NText(
                  text: languagesController.tr("WITHDRAW"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("NEW_WITHDRAW_REQUEST"),
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildCreateWithdrawBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            mypagecontroller.changePage(
              CreateWithdrawScreen(),
              isMainPage: false,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.07),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF153C68).withOpacity(0.045),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.add_card_rounded,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                NText(
                  text: languagesController.tr("NEW_WITHDRAW_REQUEST"),
                  color: const Color(0xFF172D49),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (withdrawlistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final requests =
            withdrawlistController
                .allwithdrawlist
                .value
                .data
                ?.withdrawRequests ??
            [];

        if (requests.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshWithdrawals,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 70),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 38,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 13),
                      NText(
                        text: languagesController.tr("NO_DATA_FOUND"),
                        color: AppColors.fontColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: Colors.white,
          onRefresh: _refreshWithdrawals,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 9),
            itemBuilder: (context, index) =>
                _buildWithdrawCard(requests[index]),
          ),
        );
      }),
    );
  }

  Widget _buildWithdrawCard(dynamic request) {
    final status = request.status?.toString() ?? "";
    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);

    final amount = request.amount?.toString() ?? "0";
    final commission = request.commissionAmount?.toString() ?? "0";
    final netAmount = request.netAmount?.toString() ?? "0";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0C78E8),
                  AppColors.primaryColor,
                  Color(0xFF004494),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NText(
                        text: languagesController.tr("NET_AMOUNT"),
                        color: Colors.white.withOpacity(0.68),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 2),
                      NText(
                        text: netAmount,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: NText(
                    text: _statusText(status),
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _amountBox(
                        label: languagesController.tr("AMOUNT"),
                        value: amount,
                        icon: Icons.payments_outlined,
                        accentColor: AppColors.primaryColor,
                        backgroundColor: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _amountBox(
                        label: languagesController.tr("COMMISSION"),
                        value: commission,
                        icon: Icons.percent_rounded,
                        accentColor: const Color(0xFFE09A18),
                        backgroundColor: const Color(0xFFFFF6DA),
                      ),
                    ),
                  ],
                ),
                if (request.bankDetails != null) ...[
                  const SizedBox(height: 10),
                  _buildBankDetails(request),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountBox({
    required String label,

    required String value,

    required IconData icon,

    required Color accentColor,

    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(13),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                height: 28,

                width: 28,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: Icon(icon, color: accentColor, size: 15),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: NText(
                  text: label,

                  color: AppColors.fontColor,

                  fontSize: 10,

                  fontWeight: FontWeight.w600,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          NText(
            text: value,

            color: accentColor,

            fontSize: 13.5,

            fontWeight: FontWeight.w800,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetails(dynamic request) {
    final bank = request.bankDetails;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(11, 11, 11, 11),

      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.035),

        borderRadius: BorderRadius.circular(13),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 30,

                width: 30,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Icon(
                  Icons.account_balance_rounded,

                  color: AppColors.primaryColor,

                  size: 16,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: NText(
                  text: languagesController.tr("BANK_DETAILS"),

                  color: AppColors.primaryColor,

                  fontSize: 11.5,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _detailRow(
            languagesController.tr("BANK_NAME"),

            bank.bankName?.toString() ?? "N/A",
          ),

          const SizedBox(height: 7),

          _detailRow(
            languagesController.tr("ACCOUNT_HOLDER"),

            bank.accountHolderName?.toString() ?? "N/A",
          ),

          const SizedBox(height: 7),

          _detailRow(
            languagesController.tr("ACCOUNT_NUMBER"),

            bank.accountNumber?.toString() ?? "N/A",
          ),

          if (bank.iban != null && bank.iban.toString().trim().isNotEmpty) ...[
            const SizedBox(height: 7),

            _detailRow(languagesController.tr("IBAN"), bank.iban.toString()),
          ],

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _dateBox(
                  icon: Icons.calendar_today_outlined,

                  label: languagesController.tr("CREATED"),

                  date: _formatDate(request.createdAt),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _dateBox(
                  icon: Icons.update_rounded,

                  label: languagesController.tr("UPDATED"),

                  date: _formatDate(request.updatedAt),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: 10.3,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: NText(
            text: value,

            color: AppColors.primaryColor,

            fontSize: 10.6,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _dateBox({
    required IconData icon,

    required String label,

    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(11),

        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),

      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColor),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                NText(
                  text: label,

                  color: AppColors.fontColor,

                  fontSize: 8.5,

                  fontWeight: FontWeight.w500,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                NText(
                  text: date,

                  color: AppColors.primaryColor,

                  fontSize: 9.5,

                  fontWeight: FontWeight.w700,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return "N/A";
    }

    if (value is DateTime) {
      return DateFormat("dd MMM yyyy").format(value);
    }

    final parsed = DateTime.tryParse(value.toString());

    if (parsed == null) {
      return value.toString();
    }

    return DateFormat("dd MMM yyyy").format(parsed);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
      case "completed":
        return const Color(0xFF23B26D);

      case "pending":
        return const Color(0xFFE0A51B);

      case "rejected":
      case "cancelled":
      case "canceled":
        return const Color(0xFFE05263);

      default:
        return AppColors.primarycolor2;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "approved":
      case "completed":
        return const Color(0xFFECF9F2);

      case "pending":
        return const Color(0xFFFFF6DA);

      case "rejected":
      case "cancelled":
      case "canceled":
        return const Color(0xFFFFF0F2);

      default:
        return AppColors.secondaryColor.withOpacity(0.55);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "approved":
      case "completed":
        return Icons.check_circle_outline_rounded;

      case "pending":
        return Icons.schedule_rounded;

      case "rejected":
      case "cancelled":
      case "canceled":
        return Icons.cancel_outlined;

      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String _statusText(String status) {
    if (status.isEmpty) {
      return "";
    }

    switch (status.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "completed":
        return languagesController.tr("COMPLETED");

      case "rejected":
        return languagesController.tr("REJECTED");

      default:
        return status.toUpperCase();
    }
  }
}
