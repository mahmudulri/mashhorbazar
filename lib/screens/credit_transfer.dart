import 'package:mashhorbazar/controllers/company_controller.dart';

import 'package:mashhorbazar/controllers/conversation_controller.dart';

import 'package:mashhorbazar/controllers/currency_controller.dart';

import 'package:mashhorbazar/controllers/custom_history_controller.dart';

import 'package:mashhorbazar/controllers/custom_recharge_controller.dart';

import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/recharge_config_controller.dart';

import 'package:mashhorbazar/global_controller/afghan_recharge_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';

class CreditTransfer extends StatefulWidget {
  const CreditTransfer({super.key});

  @override
  State<CreditTransfer> createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
  final CustomHistoryController customhistoryController =
      Get.find<CustomHistoryController>();

  final CurrencyController currencyController = Get.find<CurrencyController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final CompanyController companyController = Get.find<CompanyController>();

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  final AfghanRechargeController controller =
      Get.find<AfghanRechargeController>();

  final RechargeConfigController configController =
      Get.find<RechargeConfigController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final ScrollController scrollController = ScrollController();

  final RxList<bool> expandedIndices = <bool>[].obs;

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

    configController.fetchrechargeConfig();

    controller.reset();

    conversationController.resetConversion();

    customRechargeController.amountController.clear();

    customRechargeController.numberController.clear();

    currencyController.fetchCurrencyList();

    customhistoryController.finalList.clear();

    customhistoryController.initialpage = 1;

    customhistoryController.fetchHistory();

    scrollController.addListener(_loadMoreHistory);

    customRechargeController.numberController.addListener(
      _matchCompanyFromPhone,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreHistory);

    scrollController.dispose();

    customRechargeController.numberController.removeListener(
      _matchCompanyFromPhone,
    );

    super.dispose();
  }

  void _matchCompanyFromPhone() {
    companyController.matchCompanyByPhoneNumber(
      customRechargeController.numberController.text,
    );
  }

  void _loadMoreHistory() {
    if (!scrollController.hasClients) {
      return;
    }

    if (customhistoryController.isLoading.value) {
      return;
    }

    final pagination =
        customhistoryController.allorderlist.value.payload?.pagination;

    final totalPages = pagination?.totalPages ?? 0;

    final currentPage = customhistoryController.initialpage;

    if (totalPages <= 0 || currentPage >= totalPages) {
      return;
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80) {
      customhistoryController.initialpage++;

      customhistoryController.fetchHistory();
    }
  }

  Future<void> _refreshHistory() async {
    customhistoryController.finalList.clear();

    customhistoryController.initialpage = 1;

    customhistoryController.fetchHistory();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildRechargeForm(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildHistorySection(),
              ),
            ),
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
            right: -40,
            top: -54,
            child: Container(
              height: 130,
              width: 130,
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
                      text: languagesController.tr("AFGHANISTAN_RECHARGE"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: "AFN",
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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

  Widget _buildRechargeForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E9F1)),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/afnflag.jpg"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: languagesController.tr("AFGHANISTAN_RECHARGE"),
                      color: const Color(0xFF172D49),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 3),
                    NText(
                      text: "AFN",
                      color: AppColors.primaryColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _buildPhoneField(),
          const SizedBox(height: 9),
          _buildAmountField(),
          const SizedBox(height: 10),
          _buildPriceCards(),
          const SizedBox(height: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 11),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.phone_outlined,
              color: AppColors.primaryColor,
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              maxLength: 10,
              keyboardType: TextInputType.phone,
              controller: customRechargeController.numberController,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF263B54),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: languagesController.tr("PHONENUMBER"),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Obx(() {
            final company = companyController.matchedCompany.value;

            return Container(
              height: 38,
              width: 44,
              margin: const EdgeInsets.only(right: 7),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E9F1)),
              ),
              child: company == null
                  ? const Icon(
                      Icons.sim_card_outlined,
                      color: AppColors.fontColor,
                      size: 19,
                    )
                  : Image.network(
                      company.companyLogo ?? "",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sim_card_outlined,
                          color: AppColors.fontColor,
                          size: 19,
                        );
                      },
                    ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
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
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: controller.calculate,
              controller: customRechargeController.amountController,
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
                hintText: languagesController.tr("AMOUNT"),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: NText(
              text: "AFN",
              color: AppColors.primaryColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCards() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EEF5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _priceCard(
                title: languagesController.tr("BUYING"),
                value: controller.buyingPrice.value.toStringAsFixed(2),
                icon: Icons.south_west_rounded,
                accent: const Color(0xFFE09A18),
                softColor: const Color(0xFFFFF6DA),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _priceCard(
                title: languagesController.tr("SELLING"),
                value: controller.sellingPrice.value.toStringAsFixed(2),
                icon: Icons.north_east_rounded,
                accent: const Color(0xFF19A766),
                softColor: const Color(0xFFECF9F2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
    required Color softColor,
  }) {
    final currency = box.read("currency_symbol")?.toString() ?? "";

    return Container(
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NText(
                  text: title,
                  color: AppColors.fontColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: NText(
                        text: value,
                        color: const Color(0xFF172D49),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (currency.isNotEmpty) ...[
                      const SizedBox(width: 3),
                      NText(
                        text: currency,
                        color: accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _submitRecharge,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 7),
              NText(
                text: languagesController.tr("SEND_TO_DESTINATION"),
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRecharge() {
    if (customRechargeController.numberController.text.isEmpty ||
        customRechargeController.amountController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("ENTER_REQUIRED_DATA"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Obx(() {
              if (customRechargeController.isLoading.value) {
                return SizedBox(
                  height: 230,
                  child: Center(
                    child: Lottie.asset(
                      "assets/loties/recharge.json",
                      height: 170,
                    ),
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
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
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(height: 10),
                        NText(
                          text: languagesController.tr(
                            "ARE_YOU_SURE_TO_TRANSFER",
                          ),
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          textAlign: TextAlign.center,
                          height: 1.35,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    child: Row(
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
                          child: GestureDetector(
                            onTap: () {
                              customRechargeController.placeOrder(
                                dialogContext,
                              );
                            },
                            child: Container(
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 6),
                                  NText(
                                    text: languagesController.tr(
                                      "CONFIRMATION",
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
                      ],
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

  Widget _buildHistorySection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
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
                    Icons.history_rounded,
                    color: AppColors.primaryColor,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: NText(
                    text: languagesController.tr("TRANSACTIONS"),
                    color: const Color(0xFF172D49),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE9EEF5)),
          Expanded(
            child: Obx(() {
              final list = customhistoryController.finalList;

              if (customhistoryController.isLoading.value && list.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (list.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: _refreshHistory,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.history_toggle_off_rounded,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          NText(
                            text: languagesController.tr("NO_DATA_FOUND"),
                            color: AppColors.fontColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              if (expandedIndices.length != list.length) {
                expandedIndices.assignAll(
                  List<bool>.generate(list.length, (index) => false),
                );
              }

              return RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: Colors.white,
                onRefresh: _refreshHistory,
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 18),
                  itemCount: list.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    return _buildHistoryCard(list[index], index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(dynamic data, int index) {
    final status = data.status.toString();

    final Color statusColor = status == "0"
        ? const Color(0xFFE0A51B)
        : status == "1"
        ? const Color(0xFF23B26D)
        : const Color(0xFFE05263);

    final Color statusSoftColor = status == "0"
        ? const Color(0xFFFFF6DA)
        : status == "1"
        ? const Color(0xFFECF9F2)
        : const Color(0xFFFFF0F2);

    final String statusText = status == "0"
        ? languagesController.tr("PENDING")
        : status == "1"
        ? languagesController.tr("SUCCESS")
        : languagesController.tr("REJECTED");

    final createdAt = DateTime.tryParse(data.createdAt.toString());

    final companyLogo = data.bundle?.service?.company?.companyLogo?.toString();

    final title = data.bundle?.bundleTitle?.toString() ?? "";

    final account = data.rechargebleAccount?.toString() ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.035),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: expandedIndices[index],
          onExpansionChanged: (expanded) {
            expandedIndices[index] = expanded;
          },
          tilePadding: const EdgeInsets.fromLTRB(10, 5, 9, 5),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          leading: Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child:
                companyLogo != null &&
                    companyLogo != "null" &&
                    companyLogo.trim().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      companyLogo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sim_card_outlined,
                          color: AppColors.primaryColor,
                          size: 20,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.sim_card_outlined,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
          ),
          title: NText(
            text: title,
            color: const Color(0xFF172D49),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 12,
                  color: AppColors.fontColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: NText(
                    text: account,
                    color: AppColors.fontColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: statusSoftColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: NText(
              text: statusText,
              color: statusColor,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _historyDetailRow(
                    languagesController.tr("TRANSFER_STATUS"),
                    statusText,
                    valueColor: statusColor,
                  ),
                  const SizedBox(height: 7),
                  _historyDetailRow(
                    languagesController.tr("AMOUNT"),
                    "${data.bundle?.amount ?? ""} "
                    "${box.read("currency_code") ?? ""}",
                  ),
                  const SizedBox(height: 7),
                  _historyDetailRow(
                    languagesController.tr("DATE"),
                    createdAt == null
                        ? ""
                        : DateFormat("yyyy-MM-dd").format(createdAt),
                  ),
                  const SizedBox(height: 7),
                  _historyDetailRow(
                    languagesController.tr("TIME"),
                    createdAt == null
                        ? ""
                        : DateFormat("hh:mm a").format(createdAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
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

            maxLines: 2,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
