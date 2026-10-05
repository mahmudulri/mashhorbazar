import 'package:mashhorbazar/controllers/payments_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/screens/create_payments_screen.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final PaymentsController paymentsController = Get.put(PaymentsController());

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
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

    paymentsController.fetchpayments();
  }

  Future<void> _refreshPayments() async {
    paymentsController.fetchpayments();

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
            _buildCreateReceiptAction(),
            const SizedBox(height: 10),
            Expanded(child: _buildReceiptList()),
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
                  text: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("ADD_NEW_RECEIPT"),
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

  Widget _buildCreateReceiptAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            mypagecontroller.changePage(
              CreatePaymentsScreen(),
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
                    Icons.add_rounded,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 8),
                NText(
                  text: languagesController.tr("ADD_NEW_RECEIPT"),
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

  Widget _buildReceiptList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (paymentsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final payments =
            paymentsController.allpaymentslist.value.data?.payments ?? [];

        if (payments.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshPayments,
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
                          Icons.receipt_long_outlined,
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
          onRefresh: _refreshPayments,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: payments.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return _buildReceiptCard(payments[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildReceiptCard(dynamic data) {
    final status = data.status?.toString() ?? "";

    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);
    final statusText = _statusText(status);

    final paymentMethod = data.paymentMethod?.methodName?.toString() ?? "";

    final performedBy = data.performedByName?.toString() ?? "";

    final notes = data.notes?.toString() ?? "";
    final amount = data.amount?.toString() ?? "";
    final currencySymbol = data.currency?.symbol?.toString() ?? "";
    final paymentDate = _formatDate(data.paymentDate?.toString());

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _showPaymentDialog(data);
      },
      child: Container(
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
                  child: Icon(
                    _statusIcon(status),
                    color: statusColor,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NText(
                        text: paymentMethod,
                        color: const Color(0xFF172D49),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      NText(
                        text: performedBy,
                        color: AppColors.fontColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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
                    languagesController.tr("AMOUNT"),
                    "$amount $currencySymbol".trim(),
                    valueColor: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 6),
                  _detailRow(languagesController.tr("DATE"), paymentDate),
                  if (notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _detailRow(languagesController.tr("NOTES"), notes),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  Expanded(
                    child: _receiptImage(data.paymentImageUrl?.toString()),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _receiptImage(data.extraImage1Url?.toString()),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _receiptImage(data.extraImage2Url?.toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _receiptImage(String? imageUrl) {
    final hasImage =
        imageUrl != null && imageUrl != "null" && imageUrl.trim().isNotEmpty;

    return Container(
      height: 72,

      decoration: BoxDecoration(
        color: AppColors.mashhorbazarBackground,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),

      clipBehavior: Clip.antiAlias,

      child: hasImage
          ? Image.network(
              imageUrl,

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/icons/no_image.png",

                  fit: BoxFit.contain,
                );
              },
            )
          : Image.asset("assets/icons/no_image.png", fit: BoxFit.contain),
    );
  }

  void _showPaymentDialog(dynamic data) {
    showDialog(
      context: context,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,

            vertical: 28,
          ),

          child: PaymentDialog(
            status: data.status,

            paymentMethod: data.paymentMethod?.methodName,

            amount: data.amount,

            performedByName: data.performedByName,

            currency: data.currency?.code,

            notes: data.notes,

            date: data.paymentDate,

            image1: data.paymentImageUrl,

            image2: data.extraImage1Url,

            image3: data.extraImage2Url,
          ),
        );
      },
    );
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
        return Icons.cancel_outlined;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "completed":
        return languagesController.tr("COMPLETED");

      default:
        return languagesController.tr("REJECTED");
    }
  }
}

class PaymentDialog extends StatelessWidget {
  const PaymentDialog({
    super.key,

    this.status,

    this.paymentMethod,

    this.amount,

    this.performedByName,

    this.notes,

    this.currency,

    this.date,

    this.image1,

    this.image2,

    this.image3,
  });

  final dynamic status;

  final dynamic paymentMethod;

  final dynamic amount;

  final dynamic performedByName;

  final dynamic notes;

  final dynamic currency;

  final dynamic date;

  final dynamic image1;

  final dynamic image2;

  final dynamic image3;

  @override
  Widget build(BuildContext context) {
    final statusValue = status?.toString() ?? "";

    final statusColor = _statusColor(statusValue);

    final statusBackground = _statusBackground(statusValue);

    final statusText = _statusText(statusValue);

    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(maxHeight: 620),

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
      ),

      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 44,

                  width: 44,

                  decoration: BoxDecoration(
                    color: statusBackground,

                    borderRadius: BorderRadius.circular(13),
                  ),

                  child: Icon(
                    _statusIcon(statusValue),

                    color: statusColor,

                    size: 22,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: NText(
                    text: statusText,

                    color: statusColor,

                    fontSize: 15,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    height: 34,

                    width: 34,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.close_rounded,

                      color: AppColors.primaryColor,

                      size: 19,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 88,

              child: Row(
                children: [
                  Expanded(child: _dialogImage(image1?.toString())),

                  const SizedBox(width: 7),

                  Expanded(child: _dialogImage(image2?.toString())),

                  const SizedBox(width: 7),

                  Expanded(child: _dialogImage(image3?.toString())),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.035),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Column(
                children: [
                  _dialogDetailRow(
                    languagesController.tr("PAYMENT_METHOD"),

                    paymentMethod?.toString() ?? "",
                  ),

                  const SizedBox(height: 9),

                  _dialogDetailRow(
                    languagesController.tr("AMOUNT"),

                    "${amount?.toString() ?? ""} ${currency?.toString() ?? ""}"
                        .trim(),

                    valueColor: AppColors.primarycolor2,
                  ),

                  const SizedBox(height: 9),

                  _dialogDetailRow(
                    languagesController.tr("PERFORMED_BY"),

                    performedByName?.toString() ?? "",
                  ),

                  if (notes != null &&
                      notes.toString() != "null" &&
                      notes.toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 9),

                    _dialogDetailRow(
                      languagesController.tr("NOTES"),

                      notes.toString(),
                    ),
                  ],

                  const SizedBox(height: 9),

                  _dialogDetailRow(
                    languagesController.tr("DATE"),

                    _formatDate(date?.toString()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },

              child: Container(
                height: 46,

                width: double.infinity,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.055),

                  borderRadius: BorderRadius.circular(13),
                ),

                child: NText(
                  text: languagesController.tr("CLOSE"),

                  color: AppColors.primaryColor,

                  fontSize: 13,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: 11.5,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: NText(
            text: value,

            color: valueColor ?? AppColors.primaryColor,

            fontSize: 11.5,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 3,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _dialogImage(String? imageUrl) {
    final hasImage =
        imageUrl != null && imageUrl != "null" && imageUrl.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mashhorbazarBackground,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),

      clipBehavior: Clip.antiAlias,

      child: hasImage
          ? Image.network(
              imageUrl,

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/icons/no_image.png",

                  fit: BoxFit.contain,
                );
              },
            )
          : Image.asset("assets/icons/no_image.png", fit: BoxFit.contain),
    );
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate == "null" || rawDate.trim().isEmpty) {
      return "";
    }

    final parsed = DateTime.tryParse(rawDate);

    if (parsed == null) {
      return rawDate;
    }

    return DateFormat("dd MMM yyyy").format(parsed);
  }

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFE0A51B);

      case "completed":
        return const Color(0xFF23B26D);

      default:
        return const Color(0xFFE05263);
    }
  }

  static Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFFFF6DA);

      case "completed":
        return const Color(0xFFECF9F2);

      default:
        return const Color(0xFFFFF0F2);
    }
  }

  static IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;

      case "completed":
        return Icons.check_circle_outline_rounded;

      default:
        return Icons.cancel_outlined;
    }
  }

  static String _statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "completed":
        return languagesController.tr("COMPLETED");

      default:
        return languagesController.tr("REJECTED");
    }
  }
}

final LanguagesController languagesController = Get.put(LanguagesController());
