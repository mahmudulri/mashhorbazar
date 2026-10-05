import 'package:mashhorbazar/controllers/branch_controller.dart';

import 'package:mashhorbazar/controllers/hawala_cancel_controller.dart';

import 'package:mashhorbazar/controllers/hawala_list_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/helpers/capture_image_helper.dart';

import 'package:mashhorbazar/helpers/share_image_helper.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'create_hawala_screen.dart';

class HawalaListScreen extends StatefulWidget {
  const HawalaListScreen({super.key});

  @override
  State<HawalaListScreen> createState() => _HawalaListScreenState();
}

class _HawalaListScreenState extends State<HawalaListScreen> {
  final HawalaListController hawalalistController =
      Get.find<HawalaListController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final BranchController branchController = Get.put(BranchController());

  final ScrollController scrollController = ScrollController();

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

    hawalalistController.finalList.clear();

    hawalalistController.initialpage = 1;

    hawalalistController.fetchhawala();

    branchController.fetchallbranch();

    scrollController.addListener(_loadMoreHawala);
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreHawala);

    scrollController.dispose();

    super.dispose();
  }

  void _loadMoreHawala() {
    if (!scrollController.hasClients) {
      return;
    }

    if (hawalalistController.isLoading.value) {
      return;
    }

    final pagination =
        hawalalistController.allhawalalist.value.data?.pagination;

    final totalPages = pagination?.totalPages ?? 0;

    final currentPage = hawalalistController.initialpage;

    if (totalPages <= 0 || currentPage >= totalPages) {
      return;
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80) {
      hawalalistController.initialpage++;

      hawalalistController.fetchhawala();
    }
  }

  Future<void> _refreshHawala() async {
    hawalalistController.finalList.clear();

    hawalalistController.initialpage = 1;

    hawalalistController.fetchhawala();

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
            _buildNewOrderBlock(),
            const SizedBox(height: 10),
            Expanded(child: _buildHawalaList()),
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
                  text: languagesController.tr("HAWALA_ORDER_LIST"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("NEW_ORDER"),
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

  Widget _buildNewOrderBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            mypagecontroller.changePage(HawalaScreen(), isMainPage: false);
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
                  text: languagesController.tr("NEW_ORDER"),
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

  Widget _buildHawalaList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        final list = hawalalistController.finalList;

        if (hawalalistController.isLoading.value && list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (list.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshHawala,
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
                          Icons.swap_horiz_rounded,
                          color: AppColors.primaryColor,
                          size: 31,
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
          onRefresh: _refreshHawala,
          child: ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: list.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return _buildHawalaCard(list[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildHawalaCard(dynamic data) {
    final status = data.status?.toString() ?? "";
    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);
    final statusText = _statusText(status);

    final hawalaNumber =
        data.hawalaCustomNumber?.toString().trim().isNotEmpty == true
        ? data.hawalaCustomNumber.toString()
        : data.hawalaNumber?.toString() ?? "";

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _showDetailsDialog(data);
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
                        text: languagesController.tr("HAWALA_NUMBER"),
                        color: AppColors.fontColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 3),
                      NText(
                        text: hawalaNumber,
                        color: const Color(0xFF172D49),
                        fontSize: 13.5,
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
                    languagesController.tr("SENDER_NAME"),
                    data.senderName?.toString() ?? "",
                  ),
                  const SizedBox(height: 6),
                  _detailRow(
                    languagesController.tr("RECEIVER_NAME"),
                    data.receiverName?.toString() ?? "",
                  ),
                  const SizedBox(height: 6),
                  _detailRow(
                    languagesController.tr("HAWALA_AMOUNT"),
                    data.hawalaAmount?.toString() ?? "",
                    valueColor: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 6),
                  _detailRow(
                    languagesController.tr("PAYABLE_AMOUNT"),
                    data.hawalaAmountCurrencyRate?.toString() ?? "",
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

  void _showDetailsDialog(dynamic data) {
    showDialog(
      context: context,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,

            vertical: 24,
          ),

          child: HawalaDetailsDialog(
            id: data.id?.toString(),

            hawalaNumber: data.hawalaNumber?.toString(),

            hawalaCustomNumber: data.hawalaCustomNumber?.toString(),

            status: data.status?.toString(),

            branchID: data.hawalaBranchId?.toString(),

            senderName: data.senderName?.toString(),

            receiverName: data.receiverName?.toString(),

            fatherName: data.receiverFatherName?.toString(),

            idcardnumber: data.receiverIdCardNumber?.toString(),

            amount: data.hawalaAmount?.toString(),

            hawalacurrencyRate: data.hawalaAmountCurrencyRate?.toString(),

            hawalacurrencyCode: data.hawalaAmountCurrencyCode?.toString(),

            resellercurrencyCode: data.resellerPreferedCurrencyCode?.toString(),

            resellCurrencyRate: data.resellerPreferedCurrencyRate?.toString(),

            paidbysender: data.commissionPaidBySender?.toString(),

            paidbyreceiver: data.commissionPaidByReceiver?.toString(),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFE0A51B);

      case "confirmed":
        return const Color(0xFF23B26D);

      default:
        return const Color(0xFFE05263);
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFFFF6DA);

      case "confirmed":
        return const Color(0xFFECF9F2);

      default:
        return const Color(0xFFFFF0F2);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;

      case "confirmed":
        return Icons.check_circle_outline_rounded;

      default:
        return Icons.cancel_outlined;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "confirmed":
        return languagesController.tr("CONFIRMED");

      default:
        return languagesController.tr("REJECTED");
    }
  }
}

class HawalaDetailsDialog extends StatelessWidget {
  HawalaDetailsDialog({
    super.key,

    this.id,

    this.hawalaNumber,

    this.hawalaCustomNumber,

    this.status,

    this.branchID,

    this.senderName,

    this.receiverName,

    this.fatherName,

    this.idcardnumber,

    this.amount,

    this.hawalacurrencyRate,

    this.hawalacurrencyCode,

    this.resellercurrencyCode,

    this.resellCurrencyRate,

    this.paidbysender,

    this.paidbyreceiver,
  });

  final String? id;

  final String? hawalaNumber;

  final String? hawalaCustomNumber;

  final String? status;

  final String? branchID;

  final String? senderName;

  final String? receiverName;

  final String? fatherName;

  final String? idcardnumber;

  final String? amount;

  final String? hawalacurrencyRate;

  final String? hawalacurrencyCode;

  final String? resellercurrencyCode;

  final String? resellCurrencyRate;

  final String? paidbysender;

  final String? paidbyreceiver;

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final BranchController branchController = Get.put(BranchController());

  final CancelHawalaController cancelHawalaController = Get.put(
    CancelHawalaController(),
  );

  final RxBool isOpen = true.obs;

  final GlobalKey captureKey = GlobalKey();

  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final statusValue = status?.toString() ?? "";

    final statusColor = _getStatusColor(statusValue);

    final statusBackground = _getStatusBackground(statusValue);

    final branch = _findBranch();

    final displayHawalaNumber =
        hawalaCustomNumber != null &&
            hawalaCustomNumber != "null" &&
            hawalaCustomNumber!.trim().isNotEmpty
        ? hawalaCustomNumber!
        : hawalaNumber ?? "";

    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(maxHeight: 680),

      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),

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
                  height: 42,

                  width: 42,

                  decoration: BoxDecoration(
                    color: statusBackground,

                    borderRadius: BorderRadius.circular(13),
                  ),

                  child: Icon(
                    _getStatusIcon(statusValue),

                    color: statusColor,

                    size: 22,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: NText(
                    text: _getStatusText(statusValue),

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

            RepaintBoundary(
              key: captureKey,

              child: RepaintBoundary(
                key: shareKey,

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: statusColor.withOpacity(0.18)),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.04),

                        blurRadius: 12,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Image.asset("assets/icons/logo.png", height: 46),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,

                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: statusBackground,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              _getStatusIcon(statusValue),

                              color: statusColor,

                              size: 18,
                            ),

                            const SizedBox(width: 6),

                            NText(
                              text: _getStatusText(statusValue),

                              color: statusColor,

                              fontSize: 11,

                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      _infoRow(
                        languagesController.tr("HAWALA_NUMBER"),

                        displayHawalaNumber,

                        highlight: true,
                      ),

                      const SizedBox(height: 9),

                      _infoRow(
                        languagesController.tr("HAWALA_AMOUNT"),

                        amount ?? "",

                        valueColor: AppColors.primarycolor2,
                      ),

                      const SizedBox(height: 9),

                      _infoRow(
                        languagesController.tr("SENDER_NAME"),

                        senderName ?? "",
                      ),

                      const SizedBox(height: 9),

                      _infoRow(
                        languagesController.tr("RECEIVER_NAME"),

                        receiverName ?? "",
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(11),

                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.04),

                          borderRadius: BorderRadius.circular(13),

                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.06),
                          ),
                        ),

                        child: Column(
                          children: [
                            _infoRow(
                              languagesController.tr("BRANCH"),

                              branch?.name?.toString() ?? "",

                              compact: true,
                            ),

                            const SizedBox(height: 8),

                            _infoRow(
                              languagesController.tr("ADDRESS"),

                              branch?.address?.toString() ?? "",

                              compact: true,
                            ),

                            const SizedBox(height: 8),

                            _infoRow(
                              languagesController.tr("PHONE_NUMBER"),

                              branch?.phoneNumber?.toString() ?? "",

                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    onTap: () {
                      capturePng(captureKey);
                    },

                    label: languagesController.tr("SAVE_TO_GALLERY"),

                    icon: Icons.download_rounded,

                    filled: false,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: _actionButton(
                    onTap: () {
                      captureImageFromWidgetAsFile(shareKey);
                    },

                    label: languagesController.tr("SHARE"),

                    icon: Icons.share_rounded,

                    filled: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),

                child: isOpen.value
                    ? statusValue == "pending"
                          ? GestureDetector(
                              key: const ValueKey("cancel"),

                              onTap: () {
                                isOpen.value = false;
                              },

                              child: Container(
                                height: 46,

                                width: double.infinity,

                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F2),

                                  borderRadius: BorderRadius.circular(13),

                                  border: Border.all(
                                    color: const Color(
                                      0xFFE05263,
                                    ).withOpacity(0.12),
                                  ),
                                ),

                                child: NText(
                                  text: languagesController.tr("CANCEL_ORDER"),

                                  color: const Color(0xFFE05263),

                                  fontSize: 13,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    : Row(
                        key: const ValueKey("confirm"),

                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isOpen.value = true;
                              },

                              child: Container(
                                height: 46,

                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.055,
                                  ),

                                  borderRadius: BorderRadius.circular(13),
                                ),

                                child: NText(
                                  text: languagesController.tr("NO"),

                                  color: AppColors.primaryColor,

                                  fontSize: 13,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 9),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                cancelHawalaController.cancelnow(id);

                                Navigator.pop(context);
                              },

                              child: Container(
                                height: 46,

                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  color: const Color(0xFFE05263),

                                  borderRadius: BorderRadius.circular(13),
                                ),

                                child: NText(
                                  text: languagesController.tr("YES"),

                                  color: Colors.white,

                                  fontSize: 13,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 9),

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

  dynamic _findBranch() {
    try {
      final branches =
          branchController.allbranch.value.data?.hawalabranches ?? [];

      for (final item in branches) {
        if (item.id.toString() == branchID.toString()) {
          return item;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Widget _infoRow(
    String label,

    String value, {

    bool highlight = false,

    bool compact = false,

    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          flex: 2,

          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: compact ? 10.5 : 11.5,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 3,

          child: NText(
            text: value,

            color:
                valueColor ??
                (highlight ? AppColors.primarycolor2 : AppColors.primaryColor),

            fontSize: compact ? 10.5 : 11.5,

            fontWeight: highlight ? FontWeight.w800 : FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 3,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required VoidCallback onTap,

    required String label,

    required IconData icon,

    required bool filled,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 46,

        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(
                  colors: [AppColors.primarycolor2, AppColors.primaryColor],
                )
              : null,

          color: filled ? null : Colors.white,

          borderRadius: BorderRadius.circular(13),

          border: filled
              ? null
              : Border.all(color: AppColors.primaryColor.withOpacity(0.12)),

          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.14),

                    blurRadius: 9,

                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,

              color: filled ? Colors.white : AppColors.primaryColor,

              size: 17,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: NText(
                text: label,

                color: filled ? Colors.white : AppColors.primaryColor,

                fontSize: 11.5,

                fontWeight: FontWeight.w700,

                textAlign: TextAlign.center,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String statusValue) {
    switch (statusValue.toLowerCase()) {
      case "pending":
        return const Color(0xFFE0A51B);

      case "confirmed":
        return const Color(0xFF23B26D);

      default:
        return const Color(0xFFE05263);
    }
  }

  Color _getStatusBackground(String statusValue) {
    switch (statusValue.toLowerCase()) {
      case "pending":
        return const Color(0xFFFFF6DA);

      case "confirmed":
        return const Color(0xFFECF9F2);

      default:
        return const Color(0xFFFFF0F2);
    }
  }

  IconData _getStatusIcon(String statusValue) {
    switch (statusValue.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;

      case "confirmed":
        return Icons.check_circle_outline_rounded;

      default:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusText(String statusValue) {
    switch (statusValue.toLowerCase()) {
      case "pending":
        return languagesController.tr("PENDING");

      case "confirmed":
        return languagesController.tr("CONFIRMED");

      default:
        return languagesController.tr("REJECTED");
    }
  }
}
