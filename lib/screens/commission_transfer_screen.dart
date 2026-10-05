import 'package:mashhorbazar/controllers/transferlist_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'create_transfer_screen.dart';

class CommissionTransferScreen extends StatefulWidget {
  const CommissionTransferScreen({super.key});

  @override
  State<CommissionTransferScreen> createState() =>
      _CommissionTransferScreenState();
}

class _CommissionTransferScreenState extends State<CommissionTransferScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final TransferlistController transferlistController = Get.put(
    TransferlistController(),
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

    transferlistController.fetchdata();
  }

  Future<void> _refreshTransfers() async {
    transferlistController.fetchdata();

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
            _buildControlBar(),
            const SizedBox(height: 10),
            Expanded(child: _buildTransferList()),
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
                  text: languagesController.tr("TRANSFER_COMISSION"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("CREATE_NEW"),
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

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF153C68).withOpacity(0.045),
              blurRadius: 13,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFE2E9F1)),
                ),
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  style: const TextStyle(
                    color: Color(0xFF263B54),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 19,
                    ),
                    hintText: languagesController.tr("SEARCH"),
                    hintStyle: TextStyle(
                      color: AppColors.fontColor.withOpacity(0.72),
                      fontSize: 12.5,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    mypagecontroller.changePage(
                      CreateTransferScreen(),
                      isMainPage: false,
                    );
                  },
                  borderRadius: BorderRadius.circular(13),
                  child: Ink(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: NText(
                            text: languagesController.tr("CREATE_NEW"),
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildTransferList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (transferlistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final requests =
            transferlistController.alltransferlist.value.data?.requests ?? [];

        if (requests.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshTransfers,
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
          onRefresh: _refreshTransfers,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 9),
            itemBuilder: (context, index) =>
                _buildTransferCard(requests[index]),
          ),
        );
      }),
    );
  }

  Widget _buildTransferCard(dynamic data) {
    final status = data.status?.toString() ?? "";
    final notes = data.adminNotes?.toString() ?? "";
    final statusColor = _statusColor(status);
    final statusBackground = _statusBackground(status);
    final amount = data.amount?.toString() ?? "";

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 6, color: statusColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 11, 11, 11),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _statusIcon(status),
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NText(
                              text: languagesController.tr("AMOUNT"),
                              color: AppColors.fontColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 2),
                            NText(
                              text: amount,
                              color: const Color(0xFF172D49),
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
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: NText(
                          text: _statusText(status),
                          color: statusColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (notes.isNotEmpty && notes.toLowerCase() != "null") ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.notes_rounded,
                              color: AppColors.primaryColor,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NText(
                                  text: languagesController.tr("NOTES"),
                                  color: AppColors.fontColor,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 2),
                                NText(
                                  text: notes,
                                  color: const Color(0xFF42556D),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.35,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFE0A51B);

      case "completed":
      case "approved":
      case "confirmed":
      case "success":
      case "successful":
        return const Color(0xFF23B26D);

      case "rejected":
      case "cancelled":
      case "canceled":
      case "failed":
        return const Color(0xFFE05263);

      default:
        return AppColors.primarycolor2;
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFFFF6DA);

      case "completed":
      case "approved":
      case "confirmed":
      case "success":
      case "successful":
        return const Color(0xFFECF9F2);

      case "rejected":
      case "cancelled":
      case "canceled":
      case "failed":
        return const Color(0xFFFFF0F2);

      default:
        return AppColors.secondaryColor.withOpacity(0.55);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule_rounded;

      case "completed":
      case "approved":
      case "confirmed":
      case "success":
      case "successful":
        return Icons.check_circle_outline_rounded;

      case "rejected":
      case "cancelled":
      case "canceled":
      case "failed":
        return Icons.cancel_outlined;

      default:
        return Icons.swap_horiz_rounded;
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

      case "confirmed":
        return languagesController.tr("CONFIRMED");

      case "rejected":
        return languagesController.tr("REJECTED");

      default:
        return status;
    }
  }
}
