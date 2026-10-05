import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/helpers/capture_image_helper.dart';

import 'package:mashhorbazar/helpers/localtime_helper.dart';

import 'package:mashhorbazar/helpers/share_image_helper.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,

    this.createDate,

    this.status,

    this.rejectReason,

    this.companyName,

    this.bundleTitle,

    this.rechargebleAccount,

    this.validityType,

    this.sellingPrice,

    this.buyingPrice,

    this.orderID,

    this.resellerName,

    this.resellerPhone,

    this.companyLogo,

    this.amount,
  });

  final String? createDate;

  final String? status;

  final String? rejectReason;

  final String? companyName;

  final String? bundleTitle;

  final String? rechargebleAccount;

  final String? validityType;

  final String? sellingPrice;

  final String? buyingPrice;

  final String? orderID;

  final String? resellerName;

  final String? resellerPhone;

  final String? companyLogo;

  final String? amount;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  final GlobalKey _captureKey = GlobalKey();

  final GlobalKey shareKey = GlobalKey();

  bool showPrice = false;

  String get currencyCode {
    return box.read("currency_code")?.toString() ?? "";
  }

  bool get isPending {
    return widget.status.toString() == "0";
  }

  bool get isConfirmed {
    return widget.status.toString() == "1";
  }

  Color get statusColor {
    if (isPending) {
      return const Color(0xFFE0A51B);
    }

    if (isConfirmed) {
      return const Color(0xFF23B26D);
    }

    return const Color(0xFFE05263);
  }

  Color get statusSoftColor {
    if (isPending) {
      return const Color(0xFFFFF6DA);
    }

    if (isConfirmed) {
      return const Color(0xFFECF9F2);
    }

    return const Color(0xFFFFF0F2);
  }

  String get statusText {
    if (isPending) {
      return languagesController.tr("PENDING");
    }

    if (isConfirmed) {
      return languagesController.tr("CONFIRMED");
    }

    return languagesController.tr("REJECTED");
  }

  String get statusIconPath {
    if (isPending) {
      return "assets/icons/info-circle.png";
    }

    if (isConfirmed) {
      return "assets/icons/confirmed.png";
    }

    return "assets/icons/close-circle.png";
  }

  String get validityText {
    switch (widget.validityType.toString()) {
      case "yearly":
        return languagesController.tr("YEARLY");

      case "unlimited":
        return languagesController.tr("UNLIMITED");

      case "monthly":
        return languagesController.tr("MONTHLY");

      case "weekly":
        return languagesController.tr("WEEKLY");

      case "daily":
        return languagesController.tr("DAILY");

      case "hourly":
        return languagesController.tr("HOURLY");

      case "nightly":
        return languagesController.tr("NIGHTLY");

      default:
        return "";
    }
  }

  String get formattedSellingPrice {
    final value = double.tryParse(widget.sellingPrice.toString()) ?? 0;

    return NumberFormat.currency(
      locale: 'en_US',

      symbol: '',

      decimalDigits: 2,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mashhorbazarBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
                child: RepaintBoundary(
                  key: _captureKey,
                  child: RepaintBoundary(
                    key: shareKey,
                    child: _buildReceiptCard(),
                  ),
                ),
              ),
            ),
            _buildBottomActions(),
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
              _headerAction(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    NText(
                      text: languagesController.tr("ORDER_DETAILS"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: statusText,
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _headerAction(
                icon: showPrice
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                onTap: () {
                  setState(() {
                    showPrice = !showPrice;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerAction({required IconData icon, required VoidCallback onTap}) {
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

  Widget _buildReceiptCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.055),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.rotate(
                  angle: -0.45,
                  child: Opacity(
                    opacity: 0.025,
                    child: NText(
                      text: "Mashhor Bazar",
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildStatusSection(),
              _buildBundleSection(),
              _buildCustomerSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
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
      child: Column(
        children: [
          Container(
            height: 58,
            width: 58,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset("assets/icons/logo.png", fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Image.asset(statusIconPath, fit: BoxFit.contain),
              ),
              const SizedBox(width: 7),
              NText(
                text: statusText,
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),
          if (!isPending &&
              !isConfirmed &&
              widget.rejectReason.toString().trim().isNotEmpty &&
              widget.rejectReason.toString() != "null") ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: NText(
                text: widget.rejectReason.toString(),
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBundleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    widget.companyLogo != null &&
                        widget.companyLogo!.trim().isNotEmpty &&
                        widget.companyLogo != "null"
                    ? Image.network(
                        widget.companyLogo!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.business_rounded,
                            color: AppColors.primaryColor,
                            size: 21,
                          );
                        },
                      )
                    : const Icon(
                        Icons.business_rounded,
                        color: AppColors.primaryColor,
                        size: 21,
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: widget.bundleTitle.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13,
                      color: const Color(0xFF172D49),
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 3),
                    NText(
                      text: widget.companyName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 10.5,
                      color: AppColors.fontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              if (validityText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: NText(
                    text: validityText,
                    color: AppColors.primaryColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 13),
          Divider(height: 1, color: const Color(0xFFE9EEF5)),
          const SizedBox(height: 12),
          _detailRow(
            languagesController.tr("ORDER_ID"),
            "AP#- ${widget.orderID}",
          ),
          const SizedBox(height: 9),
          _detailRow(
            languagesController.tr("DATE"),
            convertToDate(widget.createDate.toString()),
          ),
          const SizedBox(height: 9),
          _detailRow(
            languagesController.tr("TIME"),
            convertToLocalTime(widget.createDate.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: const BoxDecoration(color: Color(0xFFF8FAFD)),
      child: Column(
        children: [
          _detailRow(
            languagesController.tr("PHONE_NUMBER"),
            widget.rechargebleAccount.toString(),
            valueWeight: FontWeight.w800,
          ),
          const SizedBox(height: 9),
          _detailRow(
            languagesController.tr("SENDER"),
            widget.resellerName.toString(),
          ),
          if (widget.resellerPhone != null &&
              widget.resellerPhone.toString().trim().isNotEmpty &&
              widget.resellerPhone.toString() != "null") ...[
            const SizedBox(height: 9),
            _detailRow(
              languagesController.tr("PHONE_NUMBER"),
              widget.resellerPhone.toString(),
            ),
          ],
          if (showPrice) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFE2E9F1)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      color: AppColors.primaryColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: NText(
                      text: languagesController.tr("PRICE"),
                      color: AppColors.fontColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  NText(
                    text: formattedSellingPrice,
                    color: const Color(0xFF172D49),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(width: 4),
                  NText(
                    text: currencyCode,
                    color: AppColors.primaryColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,

    String value, {

    FontWeight valueWeight = FontWeight.w600,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: NText(
            text: label,

            fontSize: 12,

            color: AppColors.fontColor,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: NText(
            text: value,

            fontSize: 12.5,

            color: AppColors.primaryColor,

            fontWeight: valueWeight,

            textAlign: TextAlign.end,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            height: 1.25,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE9EEF5))),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    capturePng(_captureKey);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.download_rounded,
                          color: AppColors.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: NText(
                            text: languagesController.tr("SAVE_TO_GALLERY"),
                            fontSize: 11.5,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    captureImageFromWidgetAsFile(shareKey);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        NText(
                          text: languagesController.tr("SHARE"),
                          fontSize: 11.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 43,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFE2E9F1)),
              ),
              alignment: Alignment.center,
              child: NText(
                text: languagesController.tr("CLOSE"),
                fontSize: 12.5,
                color: const Color(0xFF42556D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
