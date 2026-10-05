import 'package:mashhorbazar/controllers/add_commsion_group_controller.dart';

import 'package:mashhorbazar/controllers/commission_group_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

class CommissionGroupScreen extends StatefulWidget {
  const CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CommissionGroupController commissionlistController =
      Get.find<CommissionGroupController>();

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

    commissionlistController.fetchGrouplist();
  }

  Future<void> _refreshGroups() async {
    commissionlistController.fetchGrouplist();

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
            Expanded(child: _buildGroupList()),
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
                      text: languagesController.tr("COMMISSION_GROUP"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("COMMISSION_TYPE"),
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

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF153C68).withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
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
                  onTap: _showCreateGroupDialog,
                  borderRadius: BorderRadius.circular(13),
                  child: Ink(
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

  Widget _buildGroupList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (commissionlistController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final groups =
            commissionlistController.allgrouplist.value.data?.groups ?? [];

        if (groups.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshGroups,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 80),
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
                          Icons.groups_2_outlined,
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
          onRefresh: _refreshGroups,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: groups.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 7);
            },
            itemBuilder: (context, index) {
              return _buildGroupCard(groups[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildGroupCard(dynamic data) {
    final commissionType = data.commissionType?.toString() ?? "";

    final commissionText = commissionType == "percentage"
        ? languagesController.tr("PERCENTAGE")
        : commissionType;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
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
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NText(
                  text: data.groupName?.toString() ?? "",
                  color: const Color(0xFF172D49),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _detailRow(
                  languagesController.tr("AMOUNT"),
                  data.amount?.toString() ?? "",
                  valueColor: AppColors.primaryColor,
                ),
                const SizedBox(height: 3),
                _detailRow(
                  languagesController.tr("COMMISSION_TYPE"),
                  commissionText,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.percent_rounded,
              color: AppColors.primaryColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: 10.5,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: NText(
            text: value,

            color: valueColor ?? AppColors.primaryColor,

            fontSize: 10.8,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: EdgeInsets.symmetric(horizontal: 22),

          child: CreateGroupBox(),
        );
      },
    );
  }
}

class CreateGroupBox extends StatefulWidget {
  const CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  late final List<Map<String, String>> commissionType;

  @override
  void initState() {
    super.initState();

    commissionType = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 17, 14, 16),
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
                      Icons.groups_2_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NText(
                      text: languagesController.tr("COMMISSION_GROUP"),
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: _closeDialog,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(languagesController.tr("GROUP_NAME")),
                  const SizedBox(height: 7),
                  Authtextfield(
                    hinttext: languagesController.tr("ENTER_GROUP_NAME"),
                    controller: addCommsionGroupController.nameController,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel(languagesController.tr("COMMISSION_TYPE")),
                  const SizedBox(height: 7),
                  _buildCommissionSelector(),
                  const SizedBox(height: 14),
                  _fieldLabel(languagesController.tr("AMOUNT")),
                  const SizedBox(height: 7),
                  Authtextfield(
                    hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
                    controller: addCommsionGroupController.amountController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _closeDialog,
                          child: Container(
                            height: 48,
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
                            onTap: addCommsionGroupController.isLoading.value
                                ? null
                                : _createGroup,
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    addCommsionGroupController.isLoading.value
                                    ? AppColors.primaryColor.withOpacity(0.45)
                                    : AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: addCommsionGroupController.isLoading.value
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
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_circle_outline_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        NText(
                                          text: languagesController.tr(
                                            "CREATE_NOW",
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
  }

  Widget _fieldLabel(String label) {
    return NText(
      text: label,
      color: const Color(0xFF42556D),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildCommissionSelector() {
    return GestureDetector(
      onTap: _showCommissionTypeDialog,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          border: Border.all(color: const Color(0xFFE2E9F1)),
          borderRadius: BorderRadius.circular(13),
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
                Icons.percent_rounded,
                color: AppColors.primaryColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final value = addCommsionGroupController.commitype.value
                    .toString();

                return NText(
                  text: value.isEmpty
                      ? languagesController.tr("COMMISSION_TYPE")
                      : value,
                  color: value.isEmpty
                      ? AppColors.fontColor
                      : const Color(0xFF263B54),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  void _showCommissionTypeDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 30),

          child: Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(18),
            ),

            child: ListView.separated(
              shrinkWrap: true,

              itemCount: commissionType.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },

              itemBuilder: (context, index) {
                final item = commissionType[index];

                return GestureDetector(
                  onTap: () {
                    addCommsionGroupController.commitype.value =
                        item["name"] ?? "";

                    addCommsionGroupController.commissiontype.value =
                        item["value"] ?? "";

                    Navigator.pop(dialogContext);
                  },

                  child: Container(
                    height: 48,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.04),

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.07),
                      ),
                    ),

                    child: NText(
                      text: item["name"] ?? "",

                      color: AppColors.primaryColor,

                      fontSize: 13,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _createGroup() {
    final hasName = addCommsionGroupController.nameController.text.isNotEmpty;

    final hasAmount =
        addCommsionGroupController.amountController.text.isNotEmpty;

    final hasCommissionType =
        addCommsionGroupController.commissiontype.value.isNotEmpty;

    if (hasName && hasAmount && hasCommissionType) {
      addCommsionGroupController.createnow();
    }
  }

  void _closeDialog() {
    addCommsionGroupController.amountController.clear();

    addCommsionGroupController.nameController.clear();

    addCommsionGroupController.commissiontype.value = "";

    addCommsionGroupController.commitype.value = "";

    Navigator.pop(context);
  }
}
