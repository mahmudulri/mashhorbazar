import 'dart:async';

import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/drawer_controller.dart';

import 'package:mashhorbazar/controllers/order_list_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/helpers/capture_image_helper.dart';

import 'package:mashhorbazar/helpers/localtime_helper.dart';

import 'package:mashhorbazar/helpers/share_image_helper.dart';

import 'package:mashhorbazar/screens/order_details_screen.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/contact_dialogbox.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/logoutbox.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../widgets/drawer.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final OrderlistController orderlistController =
      Get.find<OrderlistController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final GetStorage box = GetStorage();

  final ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final RxString selectedDate = ''.obs;

  late LanguagesController languagesController;

  Timer? _debounce;

  String defaultValue = "";

  List<Map<String, String>> orderStatus = [];

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

    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},

      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},

      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];

    box.write("date", "");

    box.write("orderstatus", "");

    box.write("search_target", "");

    orderlistController.finalList.clear();

    orderlistController.initialpage = 1;

    orderlistController.fetchOrderlistdata();

    scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _debounce?.cancel();

    scrollController.removeListener(_loadMore);

    scrollController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,

      initialDate: selectedDate.value.isEmpty
          ? DateTime.now()
          : DateTime.tryParse(selectedDate.value) ?? DateTime.now(),

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

    final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

    selectedDate.value = formattedDate;

    box.write("date", "selected_date=$formattedDate");

    await _reloadOrders();
  }

  Future<void> _reloadOrders() async {
    orderlistController.finalList.clear();

    orderlistController.initialpage = 1;

    orderlistController.fetchOrderlistdata();

    await Future<void>.delayed(const Duration(milliseconds: 450));
  }

  void _loadMore() {
    if (!scrollController.hasClients) {
      return;
    }

    if (orderlistController.isLoading.value) {
      return;
    }

    final totalItems =
        orderlistController.allorderlist.value.payload?.pagination.totalItems ??
        0;

    if (orderlistController.finalList.length >= totalItems) {
      return;
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80) {
      orderlistController.initialpage++;

      orderlistController.fetchOrderlistdata();
    }
  }

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
                child: _buildFilterBlock(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: _reloadOrders,
                    child: _buildOrdersList(),
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
                          text: languagesController.tr("ORDERS"),
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        NText(
                          text: languagesController.tr("ORDERS"),
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
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NText(
                        text: languagesController.tr("ORDERS"),
                        color: Colors.white.withOpacity(0.86),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.receipt_long_outlined,
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

  Widget _buildFilterBlock() {
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
                  Icons.tune_rounded,
                  color: AppColors.primaryColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: languagesController.tr("ORDERS"),
                  color: const Color(0xFF172D49),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: _clearFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: NText(
                    text: languagesController.tr("REMOVE_FILTER"),
                    color: AppColors.primaryColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(child: _statusDropdown()),
              const SizedBox(width: 9),
              Expanded(child: _dateField()),
            ],
          ),
          const SizedBox(height: 9),
          _searchField(),
        ],
      ),
    );
  }

  Widget _statusDropdown() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: defaultValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primaryColor,
            size: 21,
          ),
          items: [
            DropdownMenuItem<String>(
              value: "",
              child: NText(
                text: languagesController.tr("ALL"),
                color: AppColors.fontColor,
                fontSize: 12.5,
              ),
            ),
            ...orderStatus.map((data) {
              return DropdownMenuItem<String>(
                value: data["value"],
                child: NText(
                  text: data["title"] ?? "",
                  color: const Color(0xFF263B54),
                  fontSize: 12.5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: (value) async {
            final selected = value ?? "";

            setState(() {
              defaultValue = selected;
            });

            box.write("orderstatus", selected);

            await _reloadOrders();
          },
        ),
      ),
    );
  }

  Widget _dateField() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
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
              height: 31,
              width: 31,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primaryColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(
                () => NText(
                  text: selectedDate.value.isEmpty
                      ? languagesController.tr("DATE")
                      : selectedDate.value,
                  color: selectedDate.value.isEmpty
                      ? AppColors.fontColor
                      : const Color(0xFF263B54),
                  fontSize: 11.8,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          Container(
            height: 31,
            width: 31,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF263B54),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 700), () async {
                  box.write("search_target", value.trim());

                  await _reloadOrders();
                });
              },
              decoration: InputDecoration(
                hintText: languagesController.tr("SEARCH_BY_PHOENUMBER"),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearFilters() async {
    setState(() {
      defaultValue = "";
    });

    selectedDate.value = "";

    box.write("date", "");

    box.write("orderstatus", "");

    box.write("search_target", "");

    await _reloadOrders();
  }

  Widget _buildOrdersList() {
    return Obx(() {
      if (orderlistController.isLoading.value &&
          orderlistController.finalList.isEmpty) {
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

      if (orderlistController.finalList.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 2),
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
                    height: 68,
                    width: 68,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Image.asset(
                      "assets/icons/empty.png",
                      fit: BoxFit.contain,
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
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 110),
        itemCount:
            orderlistController.finalList.length +
            (orderlistController.isLoading.value ? 1 : 0),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          if (index >= orderlistController.finalList.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final data = orderlistController.finalList[index];

          return _buildOrderCard(data);
        },
      );
    });
  }

  Widget _buildOrderCard(dynamic data) {
    final status = data.status.toString();

    final Color accentColor = status == "0"
        ? const Color(0xFFE0A51B)
        : status == "1"
        ? const Color(0xFF23B26D)
        : const Color(0xFFE05263);

    final Color softColor = status == "0"
        ? const Color(0xFFFFF6DA)
        : status == "1"
        ? const Color(0xFFECF9F2)
        : const Color(0xFFFFF0F2);

    final String statusText = status == "0"
        ? languagesController.tr("PENDING")
        : status == "1"
        ? languagesController.tr("CONFIRMED")
        : languagesController.tr("REJECTED");

    final buyingPrice =
        double.tryParse(data.bundle?.buyingPrice.toString() ?? "0") ?? 0;

    final sellingPrice =
        double.tryParse(data.bundle?.sellingPrice.toString() ?? "0") ?? 0;

    String createdDate = "";

    try {
      createdDate = DateFormat(
        "dd MMM yyyy",
      ).format(DateTime.parse(data.createdAt.toString()));
    } catch (_) {
      createdDate = data.createdAt?.toString() ?? "";
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              createDate: data.createdAt.toString(),

              status: data.status.toString(),

              rejectReason: data.rejectReason.toString(),

              companyName:
                  data.bundle?.service?.company?.companyName?.toString() ?? "",

              bundleTitle: data.bundle?.bundleTitle?.toString() ?? "",

              rechargebleAccount: data.rechargebleAccount?.toString() ?? "",

              validityType: data.bundle?.validityType?.toString() ?? "",

              sellingPrice: data.bundle?.sellingPrice?.toString() ?? "",

              buyingPrice: data.bundle?.buyingPrice?.toString() ?? "",

              orderID: data.id?.toString() ?? "",

              resellerName:
                  dashboardController
                      .alldashboardData
                      .value
                      .data
                      ?.userInfo
                      ?.contactName
                      ?.toString() ??
                  "",

              resellerPhone:
                  dashboardController
                      .alldashboardData
                      .value
                      .data
                      ?.userInfo
                      ?.phone
                      ?.toString() ??
                  "",

              companyLogo:
                  data.bundle?.service?.company?.companyLogo?.toString() ?? "",
            ),
          ),
        );
      },

      child: Container(
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
                    status == "0"
                        ? Icons.schedule_rounded
                        : status == "1"
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
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
                        text:
                            "${languagesController.tr("ORDER_ID")} #${data.id}",
                        color: const Color(0xFF172D49),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Color(0xFF8B98A9),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: NText(
                              text: createdDate,
                              color: AppColors.fontColor,
                              fontSize: 10.8,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: softColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: NText(
                    text: statusText,
                    color: accentColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Container(height: 1, color: const Color(0xFFEDF1F6)),
            const SizedBox(height: 12),
            _detailRow(
              languagesController.tr("RECHARGEABLE_ACCOUNT"),
              data.rechargebleAccount?.toString() ?? "",
              valueWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _priceBox(
                    label: languagesController.tr("BUY"),
                    value: buyingPrice,
                    color: const Color(0xFF7559D9),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _priceBox(
                    label: languagesController.tr("SELL"),
                    value: sellingPrice,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  height: 7,
                  width: 7,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: NText(
                    text: statusText,
                    color: accentColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
    String label,

    String value, {

    FontWeight valueWeight = FontWeight.w600,
  }) {
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

            color: AppColors.primaryColor,

            fontSize: 12,

            fontWeight: valueWeight,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _priceBox({
    required String label,
    required double value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          NText(
            text: label,
            color: AppColors.fontColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
          const Spacer(),
          Flexible(
            child: NText(
              text: NumberFormat.currency(
                locale: 'en_US',
                symbol: '',
                decimalDigits: 2,
              ).format(value),
              color: const Color(0xFF263B54),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          NText(
            text: box.read("currency_code")?.toString() ?? "",
            color: color,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  Widget _buildDeactivatedScreen() {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  height: 82,

                  width: 82,

                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.block_rounded,

                    color: Colors.redAccent,

                    size: 40,
                  ),
                ),

                const SizedBox(height: 20),

                NText(
                  text: dashboardController.deactiveStatus.toString(),

                  textAlign: TextAlign.center,

                  color: AppColors.primaryColor,

                  fontSize: 19,

                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 9),

                NText(
                  text: dashboardController.deactivateMessage.toString(),

                  textAlign: TextAlign.center,

                  color: AppColors.fontColor,

                  fontSize: 14,

                  height: 1.45,
                ),

                const SizedBox(height: 24),

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
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.mashhorbazarTurquoise,

                          AppColors.mashhorbazarAccent,
                        ],
                      ),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Image.asset(
                          "assets/icons/whatsapp.png",

                          height: 25,

                          color: Colors.white,
                        ),

                        const SizedBox(width: 10),

                        NText(
                          text: languagesController.tr("CONTACTUS"),

                          color: Colors.white,

                          fontWeight: FontWeight.w600,
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

                      vertical: 9,
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
    );
  }
}

class DetailsDialog extends StatelessWidget {
  DetailsDialog({
    super.key,

    this.status,

    this.bundletitle,

    this.phoneNumber,

    this.sellingPrice,

    this.orderId,

    this.imagelink,

    this.date,
  });

  final String? status;

  final String? bundletitle;

  final String? phoneNumber;

  final String? sellingPrice;

  final String? orderId;

  final String? imagelink;

  final String? date;

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  final GlobalKey catpureKey = GlobalKey();

  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final dialogStatus = status.toString();

    final statusColor = dialogStatus == "0"
        ? const Color(0xFFE0A51B)
        : dialogStatus == "1"
        ? const Color(0xFF23B26D)
        : const Color(0xFFE05263);

    final statusSoftColor = dialogStatus == "0"
        ? const Color(0xFFFFF6DA)
        : dialogStatus == "1"
        ? const Color(0xFFECF9F2)
        : const Color(0xFFFFF0F2);

    final statusText = dialogStatus == "0"
        ? languagesController.tr("PENDING")
        : dialogStatus == "1"
        ? languagesController.tr("CONFIRMED")
        : languagesController.tr("REJECTED");

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 640),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 23, 20, 20),
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
                              height: 62,
                              width: 62,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Image.asset(
                                dialogStatus == "0"
                                    ? "assets/icons/pending.png"
                                    : dialogStatus == "1"
                                    ? "assets/icons/successful.png"
                                    : "assets/icons/rejected.png",
                              ),
                            ),
                            const SizedBox(height: 11),
                            NText(
                              text: statusText,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: NText(
                                text:
                                    "${languagesController.tr("ORDER_ID")} #${orderId.toString()}",
                                color: Colors.white.withOpacity(0.90),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _dialogRow(
                              languagesController.tr("BUNDLE_TITLE"),
                              bundletitle.toString(),
                            ),
                            const SizedBox(height: 12),
                            _dialogRow(
                              languagesController.tr("PHONENUMBER"),
                              phoneNumber.toString(),
                            ),
                            const SizedBox(height: 12),
                            _dialogRow(
                              languagesController.tr("SELLING_PRICE"),
                              "${sellingPrice.toString()} ${box.read("currency_code")?.toString() ?? ""}",
                            ),
                            const SizedBox(height: 12),
                            _dialogRow(
                              languagesController.tr("ORDER_ID"),
                              orderId.toString(),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: statusSoftColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  if (imagelink != null &&
                                      imagelink!.trim().isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: Image.network(
                                        imagelink!,
                                        height: 46,
                                        width: 46,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const SizedBox(
                                                height: 46,
                                                width: 46,
                                              );
                                            },
                                      ),
                                    ),
                                  if (imagelink != null &&
                                      imagelink!.trim().isNotEmpty)
                                    const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _dialogRow(
                                          languagesController.tr("DATE"),
                                          convertToDate(date.toString()),
                                        ),
                                        const SizedBox(height: 7),
                                        _dialogRow(
                                          languagesController.tr("TIME"),
                                          convertToLocalTime(date.toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: statusSoftColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  NText(
                                    text: statusText,
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          capturePng(catpureKey);
                        },
                        child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: NText(
                            text: languagesController.tr("SAVE_TO_GALLERY"),
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: NText(
                            text: languagesController.tr("SHARE"),
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 44,
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
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String value) {
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

            color: AppColors.primaryColor,

            fontSize: 12,

            fontWeight: FontWeight.w600,

            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
