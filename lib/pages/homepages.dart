import 'package:mashhorbazar/controllers/categories_controller.dart';

import 'package:mashhorbazar/controllers/company_controller.dart';

import 'package:mashhorbazar/controllers/conversation_controller.dart';

import 'package:mashhorbazar/controllers/country_list_controller.dart';

import 'package:mashhorbazar/controllers/custom_recharge_controller.dart';

import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/drawer_controller.dart';

import 'package:mashhorbazar/controllers/notifications_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/country_list_model.dart';

import 'package:mashhorbazar/pages/notification_details_page.dart';

import 'package:mashhorbazar/screens/all_notifications_page.dart';

import 'package:mashhorbazar/screens/commission_transfer_screen.dart';

import 'package:mashhorbazar/screens/country_selection.dart';

import 'package:mashhorbazar/screens/credit_transfer.dart';

import 'package:mashhorbazar/screens/financial_screen.dart';

import 'package:mashhorbazar/screens/hawala_list_screen.dart';

import 'package:mashhorbazar/screens/hawala_rates_screen.dart';

import 'package:mashhorbazar/screens/loan_screen.dart';

import 'package:mashhorbazar/screens/receipts_screen.dart';

import 'package:mashhorbazar/screens/service_screen.dart';

import 'package:mashhorbazar/screens/withdraw_screen.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/accounting_pin_pad.dart';

import 'package:mashhorbazar/widgets/bottomsheet.dart';

import 'package:mashhorbazar/widgets/contact_dialogbox.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/logoutbox.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:in_app_update/in_app_update.dart';

import 'package:intl/intl.dart';

import '../widgets/drawer.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final CategorisListController categorisListController =
      Get.find<CategorisListController>();

  final CompanyController companyController = Get.find<CompanyController>();

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  final CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final NumberFormat _balanceFormatter = NumberFormat.currency(
    locale: 'en_US',

    symbol: '',

    decimalDigits: 2,
  );

  final List<Color> serviceIconBackgrounds = const [
    Color(0xFFF2ECFF),

    Color(0xFFFFECEC),

    Color(0xFFEAF2FF),

    Color(0xFFE8F8F2),

    Color(0xFFE8FAFC),

    Color(0xFFFFF4DC),
  ];

  final List<String> fallbackServiceIcons = const [
    "assets/icons/sim.png",

    "assets/icons/social-bundles.png",

    "assets/icons/dataplan.png",

    "assets/icons/credit-transfer.png",

    "assets/icons/callsmsplan.png",
  ];

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

    _checkForUpdate();

    notificationController.fetchData();

    companyController.fetchCompany();

    countryListController.fetchCountryData();

    dashboardController.fetchDashboardData();

    categorisListController.fetchcategories();
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await _update();
      }
    } catch (error) {
      debugPrint("Update check error: $error");
    }
  }

  Future<void> _update() async {
    try {
      await InAppUpdate.startFlexibleUpdate();

      await InAppUpdate.completeFlexibleUpdate();
    } catch (error) {
      debugPrint("Update error: $error");
    }
  }

  String get _formattedDate {
    return DateFormat("dd MMM yyyy").format(DateTime.now());
  }

  String get _formattedBalance {
    final rawBalance = dashboardController.userBalanceController.balance
        .toString();

    final value = double.tryParse(rawBalance) ?? 0;

    return _balanceFormatter.format(value);
  }

  String get _currencyCode {
    return box.read("currency_code")?.toString() ?? "";
  }

  String _translateOrFallback(String key, String fallback) {
    final translated = languagesController.tr(key).trim();

    if (translated.isEmpty || translated == key) {
      return fallback;
    }

    return translated;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return const Scaffold(
          backgroundColor: AppColors.mashhorbazarBackground,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      if (dashboardController.deactiveStatus.value.trim().toLowerCase() ==
          "deactivated") {
        return _buildDeactivatedScreen(context, screenWidth);
      }

      return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        backgroundColor: AppColors.mashhorbazarBackground,
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: () async {
              dashboardController.fetchDashboardData();
              notificationController.fetchData();

              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverToBoxAdapter(
                  child: _buildBalanceCard(screenWidth, _formattedDate),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(child: _buildRechargeAction(screenWidth)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: _buildTransactionActionsBlock()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: _buildServicesBlock()),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
            blurRadius: 28,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            top: -70,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -55,
            bottom: -90,
            child: Container(
              height: 170,
              width: 170,
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
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.30),
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
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person_rounded,
                                color: AppColors.primaryColor,
                              ),
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final userInfo = dashboardController
                          .alldashboardData
                          .value
                          .data
                          ?.userInfo;

                      final resellerGroup = dashboardController
                          .alldashboardData
                          .value
                          .data
                          ?.resellerGroup;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NText(
                            text: userInfo?.resellerName?.toString() ?? "",
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (resellerGroup != null &&
                              resellerGroup.toString() != "null" &&
                              resellerGroup.toString().trim().isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: NText(
                                text: resellerGroup.toString(),
                                color: Colors.white.withOpacity(0.82),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                  ),
                  Obx(() {
                    final unreadCount =
                        notificationController.unreadlength.value;

                    return _topIconButton(
                      onTap: () {
                        showNotificationPopup(context);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: -7,
                              top: -7,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 17,
                                  minHeight: 17,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4D67),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.4,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: NText(
                                  text: unreadCount > 99
                                      ? "99+"
                                      : unreadCount.toString(),
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  _topIconButton(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: NText(
                      text: _translateOrFallback(
                        "WELCOME_BACK",
                        "Welcome back",
                      ),
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: NText(
                      text: _formattedDate,
                      color: Colors.white.withOpacity(0.86),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topIconButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double screenWidth, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          mypagecontroller.changePage(FinancialScreen(), isMainPage: false);
        },
        child: Container(
          width: screenWidth,
          padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.07)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF153C68).withOpacity(0.07),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 43,
                    width: 43,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Image.asset(
                      "assets/icons/wallet.png",
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NText(
                          text: languagesController.tr("BALANCE"),
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 3),
                        NText(
                          text: _translateOrFallback(
                            "AVAILABLE_BALANCE",
                            "Available balance",
                          ),
                          color: const Color(0xFF203650),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.mashhorbazarBackground,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryColor,
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: NText(
                      text: _formattedBalance,
                      color: const Color(0xFF10233F),
                      fontWeight: FontWeight.w800,
                      fontSize: 29,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_currencyCode.trim().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: NText(
                        text: _currencyCode,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              Container(height: 1, color: const Color(0xFFE9EEF5)),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: NText(
                      text: languagesController.tr("FINANCIAL_REPORT"),
                      color: const Color(0xFF43556C),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                  NText(
                    text: formattedDate,
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRechargeAction(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openAfghanistanRecharge,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.20),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NText(
                        text: languagesController.tr("AFGHANISTAN_RECHARGE"),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 3),
                      NText(
                        text: _translateOrFallback(
                          "RECHARGE_NOW",
                          "Recharge quickly and securely",
                        ),
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.68),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionActionsBlock() {
    final items = <_HomeAction>[
      _HomeAction(
        title: languagesController.tr("MY_ACCOUNTING"),

        iconData: Icons.account_balance_outlined,

        accentColor: AppColors.mashhorbazarTurquoise,

        iconBackground: const Color(0xFFE8FAFC),

        onTap: () {
          AccountingPinPad.show(context);

          // dashboardController.fetchDashboardData();
        },
      ),

      _HomeAction(
        title: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),

        imagePath: "assets/icons/wallet.png",

        accentColor: const Color(0xFF0FB26C),

        iconBackground: const Color(0xFFE8F8F2),

        onTap: () {
          _openProtectedPage(ReceiptsScreen());
        },
      ),

      _HomeAction(
        title: languagesController.tr("REQUES_LOAN_BALANCE"),

        imagePath: "assets/icons/transactionsicon.png",

        accentColor: const Color(0xFF3D86E9),

        iconBackground: const Color(0xFFEAF2FF),

        onTap: () {
          _openProtectedPage(RequestLoanScreen());
        },
      ),

      _HomeAction(
        title: languagesController.tr("HAWALA"),

        imagePath: "assets/icons/exchange.png",

        accentColor: const Color(0xFFEF9C28),

        iconBackground: const Color(0xFFFFF4DC),

        onTap: () {
          _openProtectedPage(HawalaListScreen());
        },
      ),

      _HomeAction(
        title: languagesController.tr("HAWALA_RATES"),

        imagePath: "assets/icons/exchange-rate.png",

        accentColor: const Color(0xFF536DE5),

        iconBackground: const Color(0xFFEDF0FF),

        onTap: () {
          _openProtectedPage(HawalaCurrencyScreen());
        },
      ),

      _HomeAction(
        title: languagesController.tr("ACTIVE_CARD"),

        imagePath: "assets/icons/transactionsicon.png",

        accentColor: const Color(0xFFE35366),

        iconBackground: const Color(0xFFFFECEF),

        onTap: () {
          // _openProtectedPage(Transactions());
        },
      ),

      _HomeAction(
        title: languagesController.tr("TRANSFER_COMISSION_TO_BALANCE"),

        imagePath: "assets/icons/transactionsicon.png",

        accentColor: const Color(0xFF8A59D5),

        iconBackground: const Color(0xFFF2ECFF),

        onTap: () {
          _openProtectedPage(CommissionTransferScreen());
        },
      ),

      _HomeAction(
        title: languagesController.tr("WITHDRAW"),

        imagePath: "assets/icons/wallet.png",

        accentColor: AppColors.primarycolor2,

        iconBackground: AppColors.secondaryColor.withOpacity(0.55),

        onTap: () {
          _openProtectedPage(WithdrawScreen());
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 15),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 9),
                NText(
                  text: _translateOrFallback("QUICK_ACTIONS", "Quick Actions"),
                  color: const Color(0xFF172D49),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
            const SizedBox(height: 15),
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                return _buildHomeActionItem(items[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeActionItem(_HomeAction item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: item.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 58,
            width: 58,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: item.accentColor.withOpacity(0.10)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(7),
              child: item.iconData != null
                  ? Icon(item.iconData, color: item.accentColor, size: 22)
                  : Image.asset(
                      item.imagePath!,
                      fit: BoxFit.contain,
                      color: item.imagePath!.contains("transactionsicon")
                          ? item.accentColor
                          : null,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.apps_rounded,
                          color: item.accentColor,
                          size: 22,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: NText(
                text: item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: const Color(0xFF334961),
                fontSize: 10.2,
                fontWeight: FontWeight.w600,
                height: 1.18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.widgets_outlined,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: NText(
                    text: languagesController.tr("SERVICES"),
                    color: const Color(0xFF172D49),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (categorisListController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              final list =
                  categorisListController
                      .allcategorieslist
                      .value
                      .data
                      ?.servicecategories ??
                  [];

              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: NText(
                      text: languagesController.tr("SERVICES"),
                      color: AppColors.fontColor,
                      fontSize: 13,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final data = list[index];

                  final iconBackground =
                      serviceIconBackgrounds[index %
                          serviceIconBackgrounds.length];

                  final fallbackIcon =
                      fallbackServiceIcons[index % fallbackServiceIcons.length];

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _openService(data);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconBackground,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.05),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.78),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                data.categoryImageUrl.toString() == "null" ||
                                    data.categoryImageUrl
                                        .toString()
                                        .trim()
                                        .isEmpty
                                ? Image.asset(fallbackIcon, fit: BoxFit.contain)
                                : Image.network(
                                    data.categoryImageUrl.toString(),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        fallbackIcon,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Center(
                            child: NText(
                              text: data.categoryName.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xFF334961),
                              fontSize: 10.2,
                              fontWeight: FontWeight.w700,
                              height: 1.18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openAfghanistanRecharge() {
    Country? afghanistan;

    if (countryListController.finalCountryList.isNotEmpty) {
      try {
        afghanistan = countryListController.finalCountryList.firstWhere(
          (country) =>
              country.countryName?.trim().toLowerCase() == "afghanistan",
        );
      } catch (_) {
        afghanistan = null;
      }

      if (afghanistan != null) {
        box.write("country_id", afghanistan.id);

        box.write("countryName", afghanistan.countryName ?? "Afghanistan");

        box.write("maxlength", afghanistan.phoneNumberLength ?? "10");

        box.write("enable_operator_lookup", afghanistan.enableOperatorLookup);

        box.write("validity_type", "");

        box.write("company_id", "");

        box.write("search_tag", "");
      }
    }

    mypagecontroller.changePage(CreditTransfer(), isMainPage: false);
  }

  void _openProtectedPage(Widget page) {
    if (dashboardController.deactiveStatus.value.trim().toLowerCase() ==
        "deactivated") {
      Get.snackbar(
        dashboardController.deactiveStatus.toString(),

        dashboardController.deactivateMessage.toString(),

        snackPosition: SnackPosition.TOP,

        backgroundColor: Colors.redAccent,

        colorText: Colors.white,

        margin: const EdgeInsets.all(12),

        duration: const Duration(seconds: 1),

        icon: const Icon(Icons.block_rounded, color: Colors.white),
      );

      return;
    }

    mypagecontroller.changePage(page, isMainPage: false);
  }

  void _openService(dynamic data) {
    box.write("service_category_id", data.id);

    if (data.type.toString() == "nonsocial") {
      mypagecontroller.changePage(InternetPack(), isMainPage: false);

      return;
    }

    box.write("validity_type", "");

    box.write("search_tag", "");

    box.write("service_category_id", data.id);

    box.write("country_id", "");

    box.write("company_id", "");

    mypagecontroller.changePage(ServiceScreen(), isMainPage: false);
  }

  Widget _buildDeactivatedScreen(BuildContext context, double screenWidth) {
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

                    size: 41,
                  ),
                ),

                const SizedBox(height: 20),

                NText(
                  text: dashboardController.deactiveStatus.toString(),

                  fontSize: 19,

                  fontWeight: FontWeight.w700,

                  color: AppColors.primaryColor,

                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 9),

                NText(
                  text: dashboardController.deactivateMessage.toString(),

                  fontSize: 14,

                  color: AppColors.fontColor,

                  textAlign: TextAlign.center,

                  height: 1.45,
                ),

                const SizedBox(height: 25),

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

                    width: screenWidth,

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

                const SizedBox(height: 13),

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
                      horizontal: 19,

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

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    dashboardController.fetchDashboardData();
                  },

                  child: Container(
                    height: 44,

                    width: 44,

                    decoration: const BoxDecoration(
                      color: AppColors.mashhorbazarBackground,

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.refresh_rounded,

                      color: AppColors.primaryColor,

                      size: 25,
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

  void showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,

      barrierColor: Colors.black.withOpacity(0.30),

      builder: (context) {
        return Dialog(
          alignment: Alignment.topRight,

          insetPadding: const EdgeInsets.only(
            top: 70,

            right: 15,

            left: 25,

            bottom: 30,
          ),

          backgroundColor: Colors.transparent,

          child: Container(
            width: MediaQuery.of(context).size.width,

            constraints: const BoxConstraints(maxHeight: 480),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.08),
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.13),

                  blurRadius: 24,

                  spreadRadius: 2,

                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Obx(() {
              final isLoading = notificationController.isLoading.value;

              final notifications =
                  notificationController
                      .allnotificationlist
                      .value
                      .data
                      ?.notifications ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 15, 10, 11),

                    child: Row(
                      children: [
                        Container(
                          height: 39,

                          width: 39,

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primarycolor2,

                                AppColors.mashhorbazarTurquoise,
                              ],
                            ),

                            borderRadius: BorderRadius.circular(11),
                          ),

                          child: const Icon(
                            Icons.notifications_none_rounded,

                            color: Colors.white,

                            size: 21,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: NText(
                            text: languagesController.tr("NOTIFICATIONS"),

                            fontSize: 17,

                            fontWeight: FontWeight.w700,

                            color: AppColors.primaryColor,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Get.back();
                          },

                          icon: const Icon(
                            Icons.close_rounded,

                            color: AppColors.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,

                    thickness: 1,

                    color: AppColors.primaryColor.withOpacity(0.06),
                  ),

                  if (isLoading)
                    const SizedBox(
                      height: 250,

                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  else if (notifications.isEmpty)
                    SizedBox(
                      height: 250,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),

                            decoration: const BoxDecoration(
                              color: AppColors.mashhorbazarBackground,

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.notifications_off_outlined,

                              size: 39,

                              color: AppColors.fontColor,
                            ),
                          ),

                          const SizedBox(height: 13),

                          NText(
                            text: languagesController.tr("NO_NOTIFICATIONS"),

                            fontSize: 14,

                            color: AppColors.fontColor,

                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,

                        padding: EdgeInsets.zero,

                        itemCount: notifications.length > 10
                            ? 10
                            : notifications.length,

                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,

                            thickness: 1,

                            indent: 70,

                            color: AppColors.primaryColor.withOpacity(0.055),
                          );
                        },

                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          final unread = notification.isRead == false;

                          return InkWell(
                            onTap: () async {
                              Get.back();

                              await Get.to(
                                () => NotificationDetailsPage(
                                  notification: notification,
                                ),
                              );

                              await notificationController.fetchData();
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                color: unread
                                    ? AppColors.mashhorbazarBackground
                                    : Colors.white,

                                border: unread
                                    ? const Border(
                                        left: BorderSide(
                                          color:
                                              AppColors.mashhorbazarTurquoise,

                                          width: 3,
                                        ),
                                      )
                                    : null,
                              ),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,

                                vertical: 13,
                              ),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,

                                    children: [
                                      Container(
                                        height: 43,

                                        width: 43,

                                        decoration: BoxDecoration(
                                          color: unread
                                              ? AppColors.secondaryColor
                                              : AppColors
                                                    .mashhorbazarBackground,

                                          shape: BoxShape.circle,
                                        ),

                                        child: Icon(
                                          Icons.notifications_rounded,

                                          size: 21,

                                          color: unread
                                              ? AppColors.primarycolor2
                                              : AppColors.fontColor,
                                        ),
                                      ),

                                      if (unread)
                                        Positioned(
                                          right: 1,

                                          top: 1,

                                          child: Container(
                                            height: 9,

                                            width: 9,

                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,

                                              shape: BoxShape.circle,

                                              border: Border.all(
                                                color: Colors.white,

                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        NText(
                                          text: notification.title ?? "",

                                          maxLines: 1,

                                          overflow: TextOverflow.ellipsis,

                                          fontSize: 14,

                                          fontWeight: unread
                                              ? FontWeight.w700
                                              : FontWeight.w600,

                                          color: AppColors.primaryColor,
                                        ),

                                        const SizedBox(height: 4),

                                        NText(
                                          text: notification.message ?? "",

                                          maxLines: 2,

                                          overflow: TextOverflow.ellipsis,

                                          fontSize: 12,

                                          height: 1.4,

                                          color: AppColors.fontColor,
                                        ),

                                        const SizedBox(height: 6),

                                        NText(
                                          text: notification.createdAt == null
                                              ? ""
                                              : DateFormat(
                                                  "dd MMM yyyy, hh:mm a",
                                                ).format(
                                                  notification.createdAt!
                                                      .toLocal(),
                                                ),

                                          fontSize: 10,

                                          color: AppColors.fontColor
                                              .withOpacity(0.80),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  Divider(
                    height: 1,

                    thickness: 1,

                    color: AppColors.primaryColor.withOpacity(0.06),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),

                    child: SizedBox(
                      width: double.infinity,

                      height: 46,

                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();

                          await Get.to(() => const AllNotificationsPage());

                          await notificationController.fetchData();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,

                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: NText(
                          text: languagesController.tr("VIEW_ALL"),

                          color: Colors.white,

                          fontSize: 14,

                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
}

class _HomeAction {
  final String title;

  final String? imagePath;

  final IconData? iconData;

  final Color accentColor;

  final Color iconBackground;

  final VoidCallback onTap;

  const _HomeAction({
    required this.title,

    this.imagePath,

    this.iconData,

    required this.accentColor,

    required this.iconBackground,

    required this.onTap,
  });
}
