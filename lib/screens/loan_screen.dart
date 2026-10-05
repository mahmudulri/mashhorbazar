import 'package:mashhorbazar/controllers/loanlist_controller.dart';

import 'package:mashhorbazar/controllers/request_loan_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

class RequestLoanScreen extends StatefulWidget {
  const RequestLoanScreen({super.key});

  @override
  State<RequestLoanScreen> createState() => _RequestLoanScreenState();
}

class _RequestLoanScreenState extends State<RequestLoanScreen> {
  final LoanlistController loanlistController = Get.put(LoanlistController());

  final RequestLoanController requestLoanController = Get.put(
    RequestLoanController(),
  );

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

    loanlistController.fetchLoan();
  }

  Future<void> _refreshLoans() async {
    loanlistController.fetchLoan();

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
            _buildCreateRequestBlock(),
            const SizedBox(height: 10),
            Expanded(child: _buildLoanList()),
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
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -58,
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
              _headerButton(
                onTap: mypagecontroller.goBack,
                icon: Icons.arrow_back_rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("LOAN_REQUEST"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("ADD_NEW_REQUEST"),
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

  Widget _buildCreateRequestBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLoanRequestDialog,
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
                    Icons.add_rounded,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 8),
                NText(
                  text: languagesController.tr("ADD_NEW_REQUEST"),
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

  Widget _buildLoanList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (loanlistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final loans =
            loanlistController.allloanlist.value.data?.balances?.data ?? [];

        if (loans.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshLoans,
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
          onRefresh: _refreshLoans,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: loans.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return _buildLoanCard(loans[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoanCard(dynamic data) {
    final status = data.status?.toString() ?? "";
    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);
    final statusText = _statusText(status);

    final amount = data.amount?.toString() ?? "";
    final symbol = data.currency?.symbol?.toString() ?? "";
    final remainingBalance = data.remainingBalance?.toString() ?? "";
    final currencyCode = data.currency?.code?.toString() ?? "";
    final transactionType = data.transactionType?.toString() ?? "";
    final description = data.description?.toString() ?? "";
    final createdAt = _formatDate(data.createdAt?.toString());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.035),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(status), color: statusColor, size: 21),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: languagesController.tr("AMOUNT"),
                      color: AppColors.fontColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 3),
                    NText(
                      text: "$amount $symbol".trim(),
                      color: const Color(0xFF172D49),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: NText(
                  text: statusText,
                  color: statusColor,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _detailRow(
                  languagesController.tr("TRANSACTION_TYPE"),
                  transactionType,
                ),
                const SizedBox(height: 6),
                _detailRow(
                  languagesController.tr("REMAINING_BALANCE"),
                  "$remainingBalance $currencyCode".trim(),
                  valueColor: AppColors.primaryColor,
                ),
                if (description.isNotEmpty &&
                    description.toLowerCase() != "null") ...[
                  const SizedBox(height: 6),
                  _detailRow(languagesController.tr("NOTES"), description),
                ],
                const SizedBox(height: 6),
                _detailRow(languagesController.tr("DATE"), createdAt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: 10.5,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: NText(
            text: value,

            color: valueColor ?? AppColors.primaryColor,

            fontSize: 10.8,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showLoanRequestDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 14, 15),
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
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NText(
                          text: languagesController.tr("ENTER_LOAN_AMOUNT"),
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                        child: Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Column(
                    children: [
                      Container(
                        height: 52,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: const Color(0xFFE2E9F1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.payments_outlined,
                              color: AppColors.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller:
                                    requestLoanController.amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                cursorColor: AppColors.primaryColor,
                                style: const TextStyle(
                                  color: Color(0xFF263B54),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: languagesController.tr(
                                    "ENTER_AMOUNT",
                                  ),
                                  hintStyle: TextStyle(
                                    color: AppColors.fontColor.withOpacity(
                                      0.72,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: NText(
                                text:
                                    box.read("currency_code")?.toString() ?? "",
                                color: AppColors.primaryColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Container(
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: NText(
                                  text: languagesController.tr("CANCEL"),
                                  color: AppColors.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Obx(
                              () => GestureDetector(
                                onTap: requestLoanController.isLoading.value
                                    ? null
                                    : _submitLoanRequest,
                                child: Container(
                                  height: 46,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: requestLoanController.isLoading.value
                                        ? AppColors.primaryColor.withOpacity(
                                            0.45,
                                          )
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: requestLoanController.isLoading.value
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 17,
                                              width: 17,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            NText(
                                              text: languagesController.tr(
                                                "PLEASE_WAIT",
                                              ),
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.send_rounded,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 6),
                                            NText(
                                              text: languagesController.tr(
                                                "SUBMIT",
                                              ),
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitLoanRequest() {
    if (requestLoanController.amountController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.TOP,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.red,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    requestLoanController.requestloan();
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate == "null" || rawDate.trim().isEmpty) {
      return "";
    }

    final parsed = DateTime.tryParse(rawDate);

    if (parsed == null) {
      return rawDate;
    }

    return DateFormat("dd MMM yyyy").format(parsed);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFE0A51B);

      case "completed":
        return const Color(0xFF23B26D);

      default:
        return const Color(0xFFE05263);
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFFFF6DA);

      case "completed":
        return const Color(0xFFECF9F2);

      default:
        return const Color(0xFFFFF0F2);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;

      case "completed":
        return Icons.check_circle_outline_rounded;

      default:
        return Icons.undo_rounded;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "completed":
        return languagesController.tr("COMPLETED");

      default:
        return languagesController.tr("ROLLBACKED");
    }
  }
}
