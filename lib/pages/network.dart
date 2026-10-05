import 'package:mashhorbazar/controllers/change_status_controller.dart';

import 'package:mashhorbazar/controllers/commission_group_controller.dart';

import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/delete_sub_resellercontroller.dart';

import 'package:mashhorbazar/controllers/drawer_controller.dart';

import 'package:mashhorbazar/controllers/set_commission_group_controller.dart';

import 'package:mashhorbazar/controllers/sub_reseller_controller.dart';

import 'package:mashhorbazar/controllers/subreseller_details_controller.dart';

import 'package:mashhorbazar/global_controller/font_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/screens/add_new_user.dart';

import 'package:mashhorbazar/screens/change_balance.dart';

import 'package:mashhorbazar/screens/set_password.dart';

import 'package:mashhorbazar/screens/set_subreseller_pin.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../widgets/contact_dialogbox.dart';

import '../widgets/logoutbox.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

final SubresellerController subresellercontroller =
    Get.find<SubresellerController>();

final LanguagesController languagesController = Get.put(LanguagesController());

final SubresellerDetailsController detailsController =
    Get.find<SubresellerDetailsController>();

final DeleteSubResellerController deleteSubResellerController = Get.put(
  DeleteSubResellerController(),
);

final ChangeStatusController changeStatusController = Get.put(
  ChangeStatusController(),
);

final CommissionGroupController commissionlistController =
    Get.find<CommissionGroupController>();

final SetCommissionGroupController commissionGroupController = Get.put(
  SetCommissionGroupController(),
);

class _NetworkState extends State<Network> {
  final GetStorage box = GetStorage();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final TextEditingController phoneSearchController = TextEditingController();

  final TextEditingController nameSearchController = TextEditingController();

  final Set<int> expandedIndices = {};

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

    subresellercontroller.fetchSubReseller();

    commissionlistController.fetchGrouplist();
  }

  @override
  void dispose() {
    phoneSearchController.dispose();

    nameSearchController.dispose();

    super.dispose();
  }

  Future<void> _refreshNetwork() async {
    subresellercontroller.fetchSubReseller();

    commissionlistController.fetchGrouplist();

    await Future<void>.delayed(const Duration(milliseconds: 450));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final deactivated =
          dashboardController.deactiveStatus.value.trim().toLowerCase() ==
          "deactivated";

      if (deactivated) {
        return _buildDeactivatedScreen();
      }

      return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.mashhorbazarBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildControlBlock(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: _refreshNetwork,
                    child: _buildNetworkList(),
                  ),
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
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
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
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -55,
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -95,
            left: -60,
            child: Container(
              height: 165,
              width: 165,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Obx(() {
                    final profileImageUrl = dashboardController
                        .alldashboardData
                        .value
                        .data
                        ?.userInfo
                        ?.profileImageUrl;

                    final hasImage =
                        profileImageUrl != null && profileImageUrl.isNotEmpty;

                    return Container(
                      height: 48,
                      width: 48,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.26),
                        ),
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: hasImage
                            ? Image.network(
                                profileImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person_rounded,
                                    color: AppColors.primaryColor,
                                    size: 23,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person_rounded,
                                color: AppColors.primaryColor,
                                size: 23,
                              ),
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NText(
                          text: languagesController.tr("NETWORK"),
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        NText(
                          text: languagesController.tr("NETWORK"),
                          color: Colors.white.withOpacity(0.68),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      borderRadius: BorderRadius.circular(13),
                      child: Ink(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.14),
                          ),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.groups_2_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NText(
                        text: languagesController.tr("NETWORK"),
                        color: Colors.white.withOpacity(0.86),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.hub_outlined,
                      color: Colors.white70,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                mypagecontroller.changePage(AddNewUser(), isMainPage: false);
              },
              borderRadius: BorderRadius.circular(15),
              child: Ink(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 9),
                    NText(
                      text: languagesController.tr("ADD_USER"),
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          _searchField(
            controller: phoneSearchController,
            hint: languagesController.tr("SEARCH_BY_PHOENUMBER"),
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 9),
          _searchField(
            controller: nameSearchController,
            hint: languagesController.tr("SEARCH_BY_NAME"),
            icon: Icons.person_search_outlined,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _searchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
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
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(
                color: const Color(0xFF263B54),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkList() {
    return Obx(() {
      if (subresellercontroller.isLoading.value) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 260,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      }

      final resellers =
          subresellercontroller.allsubresellerData.value.data?.resellers ?? [];

      if (resellers.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
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
                      Icons.group_outlined,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 13),
                  NText(
                    text: languagesController.tr("NO_DATA_FOUND"),
                    color: AppColors.fontColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 110),
        itemCount: resellers.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          final data = resellers[index];
          return _buildResellerCard(data, index);
        },
      );
    });
  }

  Widget _buildResellerCard(dynamic data, int index) {
    final bool isExpanded = expandedIndices.contains(index);
    final bool isActive = data.status.toString() == "1";
    final String profileImageUrl = data.profileImageUrl?.toString() ?? "";

    final Color statusColor = isActive
        ? const Color(0xFF19A766)
        : const Color(0xFFE05263);

    final Color statusSoft = isActive
        ? const Color(0xFFECF9F2)
        : const Color(0xFFFFF0F2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                expandedIndices.add(index);
                detailsController.fetchSubResellerDetails(data.id.toString());
              } else {
                expandedIndices.remove(index);
              }
            });
          },
          tilePadding: const EdgeInsets.fromLTRB(13, 7, 9, 7),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 13),
          leading: Container(
            height: 47,
            width: 47,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.07),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: profileImageUrl.isNotEmpty && profileImageUrl != "null"
                  ? Image.network(
                      profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_rounded,
                          color: AppColors.primaryColor,
                          size: 24,
                        );
                      },
                    )
                  : const Icon(
                      Icons.person_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
            ),
          ),
          title: NText(
            text: data.contactName?.toString() ?? "",
            color: const Color(0xFF172D49),
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Flexible(
                  child: NText(
                    text: data.phone?.toString() ?? "",
                    color: AppColors.fontColor,
                    fontSize: 10.8,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      NText(
                        text: isActive
                            ? languagesController.tr("ACTIVE")
                            : languagesController.tr("DEACTIVE"),
                        color: statusColor,
                        fontSize: 8.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _showActionDialog(data);
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primaryColor,
                  size: 21,
                ),
              ),
            ],
          ),
          children: [_buildExpandedDetails()],
        ),
      ),
    );
  }

  Widget _buildExpandedDetails() {
    return Obx(() {
      if (detailsController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      final reseller =
          detailsController.allsubresellerDetailsData.value.data?.reseller;

      if (reseller == null) {
        return const SizedBox();
      }

      final currency = box.read("currency_code")?.toString() ?? "";

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE9EEF5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    languagesController.tr("TODAY_ORDER"),
                    reseller.todayOrders.toString(),
                    Icons.today_outlined,
                    const Color(0xFF3D86E9),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statCard(
                    languagesController.tr("TOTAL_SALE"),
                    "${reseller.totalSale} $currency",
                    Icons.trending_up_rounded,
                    const Color(0xFF23B26D),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statCard(
                    languagesController.tr("TODAY_SALE"),
                    "${reseller.todaySale} $currency",
                    Icons.payments_outlined,
                    AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    languagesController.tr("TOTAL_ORDER"),
                    reseller.totalOrders.toString(),
                    Icons.receipt_long_outlined,
                    const Color(0xFF536DE5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statCard(
                    languagesController.tr("TOTAL_PROFIT"),
                    "${reseller.totalProfit} $currency",
                    Icons.account_balance_wallet_outlined,
                    const Color(0xFF8A59D5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statCard(
                    languagesController.tr("TODAY_PROFIT"),
                    "${reseller.todayProfit} $currency",
                    Icons.auto_graph_rounded,
                    const Color(0xFFE0A51B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: NText(
                      text: languagesController.tr("ACCOUNT_BALANCE"),
                      color: Colors.white.withOpacity(0.86),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  NText(
                    text: "${reseller.balance} $currency",
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 94),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.09)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          NText(
            text: label,
            color: AppColors.fontColor,
            fontSize: 8.7,
            fontWeight: FontWeight.w500,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            height: 1.1,
          ),
          const SizedBox(height: 4),
          NText(
            text: value,
            color: const Color(0xFF263B54),
            fontSize: 9.8,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showActionDialog(dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isActive = data.status.toString() == "1";

        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10233F).withOpacity(0.14),
                  blurRadius: 28,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.fontColor.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: NText(
                          text: data.contactName?.toString() ?? "",
                          color: const Color(0xFF172D49),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _actionTile(
                  iconPath: "assets/icons/usdicon.png",
                  title: languagesController.tr("CHANGE_BALANCE"),
                  onTap: () {
                    Navigator.pop(context);
                    mypagecontroller.changePage(
                      ChangeBalance(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                ),
                _actionTile(
                  iconPath: "assets/icons/padlock.png",
                  title: languagesController.tr("SET_PASSWORD"),
                  onTap: () {
                    Navigator.pop(context);
                    mypagecontroller.changePage(
                      SetPassword(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                ),
                _actionTile(
                  iconPath: "assets/icons/discount.png",
                  title: languagesController.tr("SET_COMMISSION_GROUP"),
                  iconColor: const Color(0xFF23B26D),
                  onTap: () {
                    Navigator.pop(context);
                    _showCommissionGroups(data);
                  },
                ),
                _actionTile(
                  iconPath: "assets/icons/key.png",
                  title: languagesController.tr("SET_PIN"),
                  onTap: () {
                    Navigator.pop(context);
                    mypagecontroller.changePage(
                      SetSubresellerPin(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                ),
                _actionTile(
                  iconPath: isActive
                      ? "assets/icons/pause.png"
                      : "assets/icons/active.png",
                  title: isActive
                      ? languagesController.tr("DEACTIVE")
                      : languagesController.tr("ACTIVE"),
                  onTap: () {
                    Navigator.pop(context);
                    changeStatusController.channgestatus(data.id.toString());
                  },
                ),
                _actionTile(
                  iconPath: "assets/icons/delete.png",
                  title: languagesController.tr("DELETE"),
                  isDanger: true,
                  onTap: () {
                    Navigator.pop(context);
                    deleteSubResellerController.deletesub(data.id.toString());
                  },
                ),
                const SizedBox(height: 7),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
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
      },
    );
  }

  Widget _actionTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    bool isDanger = false,
  }) {
    final color = isDanger ? const Color(0xFFE05263) : const Color(0xFF263B54);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDanger ? const Color(0xFFFFF7F8) : const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: isDanger
                      ? const Color(0xFFFFE9EC)
                      : AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Image.asset(
                  iconPath,
                  color:
                      iconColor ??
                      (isDanger
                          ? const Color(0xFFE05263)
                          : AppColors.primaryColor),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: NText(
                  text: title,
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDanger
                    ? const Color(0xFFE05263).withOpacity(0.55)
                    : AppColors.primaryColor.withOpacity(0.45),
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommissionGroups(dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Obx(() {
              if (commissionlistController.isLoading.value) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              final groups =
                  commissionlistController.allgrouplist.value.data?.groups ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 42,
                    decoration: BoxDecoration(
                      color: AppColors.fontColor.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.percent_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NText(
                          text: languagesController.tr("SET_COMMISSION_GROUP"),
                          color: const Color(0xFF172D49),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: groups.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 7);
                      },
                      itemBuilder: (context, index) {
                        final group = groups[index];

                        final selected =
                            data.subResellerCommissionGroupId.toString() ==
                            group.id.toString();

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);

                              await commissionGroupController.setgroup(
                                data.id.toString(),
                                group.id.toString(),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.secondaryColor
                                    : const Color(0xFFF8FAFD),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primaryColor.withOpacity(0.16)
                                      : const Color(0xFFE9EEF5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NText(
                                          text: group.groupName ?? "",
                                          color: const Color(0xFF263B54),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        const SizedBox(height: 3),
                                        NText(
                                          text:
                                              "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                          color: AppColors.fontColor,
                                          fontSize: 11,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primaryColor,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildDeactivatedScreen() {
    return Scaffold(
      backgroundColor: AppColors.mashhorbazarBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFFE9EEF5)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF153C68).withOpacity(0.07),
                    blurRadius: 22,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: const Icon(
                      Icons.block_rounded,
                      color: Colors.redAccent,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 18),
                  NText(
                    text: dashboardController.deactiveStatus.toString(),
                    textAlign: TextAlign.center,
                    color: const Color(0xFF172D49),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 9),
                  NText(
                    text: dashboardController.deactivateMessage.toString(),
                    textAlign: TextAlign.center,
                    color: AppColors.fontColor,
                    fontSize: 14,
                    height: 1.45,
                  ),
                  const SizedBox(height: 23),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            contentPadding: EdgeInsets.zero,
                            content: ContactDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/whatsapp.png",
                            height: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 9),
                          NText(
                            text: languagesController.tr("CONTACTUS"),
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: LogoutDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: NText(
                        text: languagesController.tr("LOGOUT"),
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
