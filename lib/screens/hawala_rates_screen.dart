import 'package:mashhorbazar/controllers/hawala_currency_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final HawalaCurrencyController hawalaCurrencyController = Get.put(
    HawalaCurrencyController(),
  );

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

    hawalaCurrencyController.fetchcurrency();
  }

  Future<void> _refreshRates() async {
    hawalaCurrencyController.fetchcurrency();

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
            _buildRateHeader(),
            const SizedBox(height: 10),
            Expanded(child: _buildRatesList()),
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
                  text: languagesController.tr("HAWALA_RATES"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("EXCHANGE_RATE"),
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

  Widget _buildRateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
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
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.currency_exchange_rounded,
                color: AppColors.primaryColor,
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: NText(
                text: languagesController.tr("EXCHANGE_RATE"),
                color: const Color(0xFF172D49),
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  hawalaCurrencyController.fetchcurrency();
                },
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        if (hawalaCurrencyController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final rates =
            hawalaCurrencyController.allcurrencylist.value.data?.rates ?? [];

        if (rates.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _refreshRates,
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
                          Icons.currency_exchange_rounded,
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
          onRefresh: _refreshRates,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: rates.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 9);
            },
            itemBuilder: (context, index) {
              return _buildRateCard(rates[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildRateCard(dynamic data) {
    final fromName = data.fromCurrency?.name?.toString() ?? "";
    final fromSymbol = data.fromCurrency?.symbol?.toString() ?? "";
    final fromCode = data.fromCurrency?.code?.toString() ?? "";

    final toName = data.toCurrency?.name?.toString() ?? "";
    final toSymbol = data.toCurrency?.symbol?.toString() ?? "";
    final toCode = data.toCurrency?.code?.toString() ?? "";

    final amount = data.amount?.toString() ?? "";
    final buyRate = data.buyRate?.toString() ?? "";
    final sellRate = data.sellRate?.toString() ?? "";

    final fromTitle = fromName.isNotEmpty ? fromName : fromCode;

    final toTitle = toName.isNotEmpty ? toName : toCode;

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: _currencySide(
                    title: fromTitle,
                    code: fromCode,
                    symbol: fromSymbol,
                    amount: amount,
                    alignEnd: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.08),
                    ),
                  ),
                  child: const Icon(
                    Icons.compare_arrows_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: _currencySide(
                    title: toTitle,
                    code: toCode,
                    symbol: toSymbol,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFE9EEF5)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            color: const Color(0xFFF8FAFD),
            child: Row(
              children: [
                Expanded(
                  child: _rateTicket(
                    title: languagesController.tr("BUYING"),
                    value: buyRate,
                    symbol: toSymbol,
                    icon: Icons.south_west_rounded,
                    accent: const Color(0xFF19A766),
                    soft: const Color(0xFFECF9F2),
                  ),
                ),
                const SizedBox(width: 8),
                Container(height: 42, width: 1, color: const Color(0xFFE2E9F1)),
                const SizedBox(width: 8),
                Expanded(
                  child: _rateTicket(
                    title: languagesController.tr("SELLING"),
                    value: sellRate,
                    symbol: toSymbol,
                    icon: Icons.north_east_rounded,
                    accent: const Color(0xFFE09A18),
                    soft: const Color(0xFFFFF6DA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencySide({
    required String title,
    required String code,
    required String symbol,
    String? amount,
    required bool alignEnd,
  }) {
    final displayCode = code.isNotEmpty ? code : symbol;

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 30),
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: NText(
                text: displayCode,
                color: AppColors.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        NText(
          text: title,
          color: const Color(0xFF172D49),
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
        if (amount != null && amount.trim().isNotEmpty) ...[
          const SizedBox(height: 3),
          NText(
            text: "$amount $symbol".trim(),
            color: AppColors.fontColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          ),
        ],
      ],
    );
  }

  Widget _rateTicket({
    required String title,
    required String value,
    required String symbol,
    required IconData icon,
    required Color accent,
    required Color soft,
  }) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: soft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accent, size: 17),
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
                  if (symbol.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    NText(
                      text: symbol,
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
    );
  }
}
