import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/transaction_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final RxString selectedOrderStatus = "".obs;

  final RxString selectedCategoryType = "".obs;

  final RxString selectedPurposeType = "".obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);

  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final List<Map<String, String>> orderStatus = const [
    {"titleKey": "CREDIT", "value": "credit"},

    {"titleKey": "DEBIT", "value": "debit"},
  ];

  final List<Map<String, String>> categoryType = const [
    {"titleKey": "ADMIN_TO_RESELLER", "value": "admin-reseller"},

    {"titleKey": "RESELLER_TO_ADMIN", "value": "reseller-subreseller"},
  ];

  final List<Map<String, String>> purposeType = const [
    {"titleKey": "ORDER", "value": "order"},

    {"titleKey": "MONEY_TRANSFER", "value": "money"},
  ];

  final GetStorage box = GetStorage();

  final TransactionController transactionController =
      Get.find<TransactionController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final NumberFormat amountFormatter = NumberFormat.currency(
    locale: 'en_US',

    symbol: '',

    decimalDigits: 2,
  );

  bool isFilterOpen = false;

  @override
  void initState() {
    super.initState();

    box.write("transactiontype", "");

    box.write("category", "");

    box.write("purpose", "");

    box.write("startdate", "");

    box.write("enddate", "");

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mashhorbazarBackground,

        statusBarIconBrightness: Brightness.dark,

        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: AppColors.mashhorbazarBackground,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    transactionController.fetchTransactionData();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,

      initialDate: startDate.value ?? DateTime.now(),

      firstDate: DateTime(2000),

      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,

              onPrimary: Colors.white,

              surface: Colors.white,

              onSurface: AppColors.primaryColor,
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    startDate.value = picked;

    final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

    box.write("startdate", "&filter_startdate=$formattedDate");

    if (endDate.value != null && endDate.value!.isBefore(picked)) {
      endDate.value = null;

      box.write("enddate", "");
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (startDate.value == null) {
      Get.snackbar(
        languagesController.tr("WARNING"),

        languagesController.tr("SELECT_START_DATE_FIRST"),

        snackPosition: SnackPosition.TOP,

        backgroundColor: AppColors.primaryColor,

        colorText: Colors.white,

        margin: const EdgeInsets.all(12),
      );

      return;
    }

    final picked = await showDatePicker(
      context: context,

      initialDate: endDate.value ?? startDate.value!,

      firstDate: startDate.value!,

      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,

              onPrimary: Colors.white,

              surface: Colors.white,

              onSurface: AppColors.primaryColor,
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    endDate.value = picked;

    final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

    box.write("enddate", "&filter_enddate=$formattedDate");
  }

  @override
  Widget build(BuildContext context) {
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
              child: _buildFilterSection(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    transactionController.fetchTransactionData();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 450),
                    );
                  },
                  child: _buildTransactionList(),
                ),
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
            right: -55,
            top: -70,
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
            left: -60,
            bottom: -90,
            child: Container(
              height: 160,
              width: 160,
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
                          text: languagesController.tr("TRANSACTIONS"),
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        NText(
                          text: languagesController.tr("TRANSACTION_HISTORY"),
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
                        Icons.receipt_long_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NText(
                        text: languagesController.tr("TRANSACTIONS"),
                        color: Colors.white.withOpacity(0.86),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.swipe_down_alt_rounded,
                      color: Colors.white70,
                      size: 18,
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

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFilterOpen = !isFilterOpen;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primaryColor,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NText(
                              text: languagesController.tr(
                                "FILTER_TRANSACTION",
                              ),
                              color: const Color(0xFF172D49),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(height: 2),
                            NText(
                              text: languagesController.tr("TRANSACTIONS"),
                              color: AppColors.fontColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: isFilterOpen
                              ? AppColors.primaryColor
                              : AppColors.mashhorbazarBackground,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: AnimatedRotation(
                          turns: isFilterOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 220),
                          child: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: isFilterOpen
                                ? Colors.white
                                : AppColors.primaryColor,
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 240),
              crossFadeState: isFilterOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFD),
                  border: Border(top: BorderSide(color: Color(0xFFE9EEF5))),
                ),
                padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
                child: Column(
                  children: [
                    _filterLabel(languagesController.tr("TYPE")),
                    const SizedBox(height: 7),
                    _buildDropdown(
                      selectedValue: selectedOrderStatus,
                      items: orderStatus,
                      onChanged: (value) {
                        selectedOrderStatus.value = value ?? "";
                        box.write(
                          "transactiontype",
                          value == null || value.isEmpty
                              ? ""
                              : "&filter_transactiontype=$value",
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _filterLabel(languagesController.tr("SELECT_CATEGORY")),
                    const SizedBox(height: 7),
                    _buildDropdown(
                      selectedValue: selectedCategoryType,
                      items: categoryType,
                      onChanged: (value) {
                        selectedCategoryType.value = value ?? "";
                        box.write(
                          "category",
                          value == null || value.isEmpty
                              ? ""
                              : "&filter_transactioncategory=$value",
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _filterLabel(languagesController.tr("SELECT_PURPOSE")),
                    const SizedBox(height: 7),
                    _buildDropdown(
                      selectedValue: selectedPurposeType,
                      items: purposeType,
                      onChanged: (value) {
                        selectedPurposeType.value = value ?? "";
                        box.write(
                          "purpose",
                          value == null || value.isEmpty
                              ? ""
                              : "&filter_transactionpurpose=$value",
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _dateBox(
                            date: startDate,
                            placeholder: languagesController.tr("START_DATE"),
                            onTap: () => pickStartDate(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dateBox(
                            date: endDate,
                            placeholder: languagesController.tr("END_DATE"),
                            onTap: () => pickEndDate(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              transactionController.fetchTransactionData();
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.18,
                                    ),
                                    blurRadius: 13,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: NText(
                                text: languagesController.tr("APPLY_FILTER"),
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: _removeFilter,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.13,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: NText(
                                text: languagesController.tr("REMOVE_FILTER"),
                                color: AppColors.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,

      child: NText(
        text: text,

        color: AppColors.primaryColor,

        fontSize: 12.5,

        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDropdown({
    required RxString selectedValue,

    required List<Map<String, String>> items,

    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 52,

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),

      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue.value.isEmpty ? null : selectedValue.value,

            isExpanded: true,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(13),

            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,

              color: AppColors.primaryColor,

              size: 21,
            ),

            hint: NText(
              text: languagesController.tr("ALL"),

              color: AppColors.fontColor,

              fontSize: 13.5,
            ),

            items: [
              DropdownMenuItem<String>(
                value: "",

                child: NText(
                  text: languagesController.tr("ALL"),

                  color: AppColors.primaryColor,

                  fontSize: 13.5,
                ),
              ),

              ...items.map(
                (data) => DropdownMenuItem<String>(
                  value: data["value"],

                  child: NText(
                    text: languagesController.tr(data["titleKey"]!),

                    color: AppColors.primaryColor,

                    fontSize: 13.5,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],

            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _dateBox({
    required Rx<DateTime?> date,

    required String placeholder,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 52,

        padding: const EdgeInsets.symmetric(horizontal: 11),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(13),

          border: Border.all(color: const Color(0xFFE2E9F1)),
        ),

        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => NText(
                  text: date.value == null
                      ? placeholder
                      : DateFormat('yyyy/MM/dd').format(date.value!),

                  color: date.value == null
                      ? AppColors.fontColor
                      : AppColors.primaryColor,

                  fontSize: 12.5,

                  fontWeight: FontWeight.w500,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.calendar_month_rounded,

              color: AppColors.primaryColor,

              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  void _removeFilter() {
    selectedOrderStatus.value = "";

    selectedCategoryType.value = "";

    selectedPurposeType.value = "";

    startDate.value = null;

    endDate.value = null;

    box.write("transactiontype", "");

    box.write("category", "");

    box.write("purpose", "");

    box.write("startdate", "");

    box.write("enddate", "");

    transactionController.fetchTransactionData();
  }

  Widget _buildTransactionList() {
    return Obx(() {
      if (transactionController.isLoading.value) {
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

      final transactions =
          transactionController
              .alltransactionlist
              .value
              .data
              ?.resellerBalanceTransactions ??
          [];

      if (transactions.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: EdgeInsets.zero,

          children: [
            Container(
              width: double.infinity,

              margin: const EdgeInsets.only(top: 2),

              padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),

              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FC),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.05),
                ),
              ),

              child: Column(
                children: [
                  Container(
                    height: 58,

                    width: 58,

                    decoration: BoxDecoration(
                      color: AppColors.mashhorbazarTurquoise.withOpacity(0.09),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.receipt_long_outlined,

                      color: AppColors.primaryColor,

                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 12),

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

        padding: const EdgeInsets.only(bottom: 24),

        itemCount: transactions.length,

        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },

        itemBuilder: (context, index) {
          return _buildTransactionCard(transactions[index]);
        },
      );
    });
  }

  Widget _buildTransactionCard(dynamic data) {
    final isDebit = data.status.toString().toLowerCase() == "debit";

    final accentColor = isDebit
        ? const Color(0xFFE05263)
        : const Color(0xFF19A766);

    final softColor = isDebit
        ? const Color(0xFFFFF0F2)
        : const Color(0xFFECF9F2);

    final resellerName = data.reseller?.resellerName?.toString() ?? "";

    final dateText = _formatTransactionDate(data.createdAt);
    final timeText = _formatTransactionTime(data.createdAt);
    final amount = double.tryParse(data.amount.toString()) ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showTransactionDialog(data),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isDebit
                          ? Icons.north_east_rounded
                          : Icons.south_west_rounded,
                      color: accentColor,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NText(
                          text: resellerName.isEmpty
                              ? languagesController.tr("TRANSACTIONS")
                              : resellerName,
                          color: const Color(0xFF172D49),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        NText(
                          text: "$dateText  •  $timeText",
                          color: AppColors.fontColor,
                          fontSize: 10.8,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NText(
                            text: isDebit ? "-" : "+",
                            color: accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                          NText(
                            text: amountFormatter.format(amount),
                            color: const Color(0xFF172D49),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      NText(
                        text: box.read("currency_code")?.toString() ?? "",
                        color: AppColors.fontColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Container(height: 1, color: const Color(0xFFEDF1F6)),
              const SizedBox(height: 11),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: softColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: NText(
                      text: isDebit
                          ? languagesController.tr("DEBIT")
                          : languagesController.tr("CREDIT"),
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryColor,
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTransactionDate(dynamic createdAt) {
    if (createdAt == null || createdAt.toString().isEmpty) {
      return "-";
    }

    try {
      final parsedDate = DateTime.parse(createdAt.toString()).toLocal();

      return DateFormat("dd MMM yyyy").format(parsedDate);
    } catch (_) {
      return createdAt.toString();
    }
  }

  String _formatTransactionTime(dynamic createdAt) {
    if (createdAt == null || createdAt.toString().isEmpty) {
      return "-";
    }

    try {
      final parsedDate = DateTime.parse(createdAt.toString()).toLocal();

      return DateFormat("hh:mm a").format(parsedDate);
    } catch (_) {
      return "-";
    }
  }

  void _showTransactionDialog(dynamic data) {
    final isDebit = data.status.toString().toLowerCase() == "debit";

    final accentColor = isDebit
        ? const Color(0xFFE05263)
        : const Color(0xFF23B26D);

    final softColor = isDebit
        ? const Color(0xFFFFF0F2)
        : const Color(0xFFECF9F2);

    final resellerName = data.reseller?.resellerName?.toString() ?? "";

    final amount = double.tryParse(data.amount.toString()) ?? 0;

    final currencyCode = box.read("currency_code")?.toString() ?? "";

    final dateText = _formatTransactionDate(data.createdAt);

    final timeText = _formatTransactionTime(data.createdAt);

    showDialog(
      context: context,

      barrierDismissible: true,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 22),

          child: Container(
            width: double.infinity,

            constraints: const BoxConstraints(maxWidth: 420),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(22),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),

                  blurRadius: 24,

                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),

                  decoration: BoxDecoration(
                    color: softColor,

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),

                      topRight: Radius.circular(22),
                    ),
                  ),

                  child: Column(
                    children: [
                      Container(
                        height: 54,

                        width: 54,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.12),

                              blurRadius: 12,

                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Icon(
                          isDebit
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,

                          color: accentColor,

                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        mainAxisSize: MainAxisSize.min,

                        children: [
                          NText(
                            text: amountFormatter.format(amount),

                            color: accentColor,

                            fontSize: 23,

                            fontWeight: FontWeight.w800,
                          ),

                          if (currencyCode.isNotEmpty) ...[
                            const SizedBox(width: 6),

                            NText(
                              text: currencyCode,

                              color: accentColor,

                              fontSize: 12,

                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,

                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.09),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: NText(
                          text: isDebit
                              ? languagesController.tr("DEBIT")
                              : languagesController.tr("CREDIT"),

                          color: accentColor,

                          fontSize: 10.5,

                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),

                  child: Column(
                    children: [
                      _buildDialogRow(
                        icon: Icons.person_outline_rounded,

                        label: languagesController.tr("NAME"),

                        value: resellerName.isEmpty ? "-" : resellerName,
                      ),

                      _dialogDivider(),

                      _buildDialogRow(
                        icon: Icons.calendar_today_outlined,

                        label: languagesController.tr("DATE"),

                        value: dateText,
                      ),

                      _dialogDivider(),

                      _buildDialogRow(
                        icon: Icons.access_time_rounded,

                        label: languagesController.tr("TIME"),

                        value: timeText,
                      ),

                      _dialogDivider(),

                      _buildDialogRow(
                        icon: Icons.swap_horiz_rounded,

                        label: languagesController.tr("TRANSACTION_TYPE"),

                        value: isDebit
                            ? languagesController.tr("DEBIT")
                            : languagesController.tr("CREDIT"),

                        valueColor: accentColor,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),

                  child: SizedBox(
                    width: double.infinity,

                    height: 46,

                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),

                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.mashhorbazarBackground,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),

                      child: NText(
                        text: languagesController.tr("CLOSE"),

                        color: AppColors.primaryColor,

                        fontSize: 13,

                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _dialogDivider() {
    return Divider(
      height: 22,

      thickness: 0.6,

      color: AppColors.primaryColor.withOpacity(0.07),
    );
  }

  Widget _buildDialogRow({
    required IconData icon,

    required String label,

    required String value,

    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          height: 32,

          width: 32,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: AppColors.mashhorbazarBackground,

            borderRadius: BorderRadius.circular(9),
          ),

          child: Icon(icon, size: 16, color: AppColors.mashhorbazarTurquoise),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),

            child: NText(
              text: label,

              color: AppColors.fontColor,

              fontSize: 12,

              fontWeight: FontWeight.w500,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),

            child: NText(
              text: value,

              color: valueColor ?? AppColors.primaryColor,

              fontSize: 12.5,

              fontWeight: FontWeight.w700,

              textAlign: TextAlign.end,

              maxLines: 3,

              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
