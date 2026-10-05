import 'package:mashhorbazar/controllers/add_hawala_controller.dart';

import 'package:mashhorbazar/controllers/branch_controller.dart';

import 'package:mashhorbazar/controllers/conversation_controller.dart';

import 'package:mashhorbazar/controllers/currency_controller.dart';

import 'package:mashhorbazar/controllers/hawala_currency_controller.dart';

import 'package:mashhorbazar/controllers/sign_in_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class HawalaScreen extends StatefulWidget {
  const HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final AddHawalaController addHawalaController = Get.put(
    AddHawalaController(),
  );

  final SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final BranchController branchController = Get.put(BranchController());

  final HawalaCurrencyController hawalaCurrencyController = Get.put(
    HawalaCurrencyController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  final GetStorage box = GetStorage();

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

    _resetForm();

    hawalaCurrencyController.fetchcurrency();

    currencyController.fetchCurrencyList();

    branchController.fetchallbranch();
  }

  void _resetForm() {
    addHawalaController.amountController.clear();

    addHawalaController.currency.value = "";

    addHawalaController.finalAmount.value = "";

    conversationController.selectedCurrency.value = "";

    addHawalaController.senderNameController.clear();

    addHawalaController.receiverNameController.clear();

    addHawalaController.fatherNameController.clear();

    addHawalaController.idcardController.clear();

    addHawalaController.currencyID.value = "";

    addHawalaController.paidbyreceiver.value = "";

    addHawalaController.paidbysender.value = "";

    addHawalaController.branchId.value = "";

    addHawalaController.currency2.value = "";

    addHawalaController.branch.value = "";

    addHawalaController.selectedRate.value = null;
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
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 28),
                children: [_buildFormCard()],
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
                  text: languagesController.tr("CREATE_HAWALA"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("HAWALA_AMOUNT"),
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

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.swap_horiz_rounded,
                  color: AppColors.primaryColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: languagesController.tr("CREATE_HAWALA"),
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _fieldLabel(languagesController.tr("SENDER_NAME")),
          const SizedBox(height: 7),
          Authtextfield(
            hinttext: "",
            controller: addHawalaController.senderNameController,
          ),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("RECEIVER_NAME")),
          const SizedBox(height: 7),
          Authtextfield(
            hinttext: "",
            controller: addHawalaController.receiverNameController,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _fieldLabel(languagesController.tr("HAWALA_AMOUNT")),
              ),
              const SizedBox(width: 10),
              Expanded(child: _fieldLabel(languagesController.tr("CURRENCY"))),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(flex: 2, child: _buildAmountField()),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencySelector()),
            ],
          ),
          const SizedBox(height: 14),
          _buildFinalAmountCard(),
          const SizedBox(height: 8),
          NText(
            text: languagesController.tr(
              "FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE",
            ),
            color: AppColors.fontColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
          const SizedBox(height: 16),
          _fieldLabel(languagesController.tr("BRANCH")),
          const SizedBox(height: 7),
          _buildBranchSelector(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
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

  Widget _buildAmountField() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.payments_outlined,
            color: AppColors.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: addHawalaController.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF263B54),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: languagesController.tr("ENTER_AMOUNT"),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                ),
              ),
              onChanged: (_) {
                _recalculateFinalAmount();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return GestureDetector(
      onTap: _showCurrencyDialog,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE2E9F1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => NText(
                  text: addHawalaController.currency.value,
                  color: addHawalaController.currency.value.isEmpty
                      ? AppColors.fontColor
                      : const Color(0xFF263B54),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C78E8),
            AppColors.primaryColor,
            Color(0xFF004494),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => NText(
                text: addHawalaController.finalAmount.value.isEmpty
                    ? "0.00"
                    : addHawalaController.finalAmount.value,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          NText(
            text: box.read("currency_code")?.toString() ?? "",
            color: Colors.white.withOpacity(0.88),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSelector() {
    return GestureDetector(
      onTap: _showBranchDialog,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
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
                Icons.location_on_outlined,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final value = addHawalaController.branch.value;

                return NText(
                  text: value.isEmpty
                      ? languagesController.tr("BRANCH")
                      : value,
                  color: value.isEmpty
                      ? AppColors.fontColor
                      : const Color(0xFF263B54),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => GestureDetector(
        onTap: addHawalaController.isLoading.value ? null : _submitHawala,
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: addHawalaController.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: addHawalaController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: addHawalaController.isLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    NText(
                      text: languagesController.tr("PLEASE_WAIT"),
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    NText(
                      text: languagesController.tr("CONFIRM_AND_SUBMIT"),
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _recalculateFinalAmount() {
    final selected = addHawalaController.selectedRate.value;

    if (selected == null || addHawalaController.currency.value.isEmpty) {
      addHawalaController.finalAmount.value = "0.00";

      return;
    }

    final input = _toDouble(addHawalaController.amountController.text.trim());

    final dAmount = _toDouble(selected.amount);

    final sRate = _toDouble(selected.sellRate);

    var result = 0.0;

    if (dAmount > 0 && sRate > 0) {
      result = (input / dAmount) * sRate;
    }

    addHawalaController.finalAmount.value = result.toStringAsFixed(2);
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> _uniqueRates() {
    final List<dynamic> rates =
        (hawalaCurrencyController.hawalafilteredcurrency.value.data?.rates
            as List?) ??
        <dynamic>[];

    final Map<String, dynamic> uniqueByToId = {};

    for (final rate in rates) {
      final toId = ((rate?.toCurrency?.id) ?? "").toString();

      if (toId.isEmpty) {
        continue;
      }

      uniqueByToId.putIfAbsent(toId, () => rate);
    }

    return uniqueByToId;
  }

  void _showCurrencyDialog() {
    hawalaCurrencyController.fetchcurrency();

    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            constraints: const BoxConstraints(maxHeight: 430),

            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,

                      width: 38,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primarycolor2,

                            AppColors.primaryColor,
                          ],
                        ),

                        borderRadius: BorderRadius.circular(11),
                      ),

                      child: const Icon(
                        Icons.currency_exchange_rounded,

                        color: Colors.white,

                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: NText(
                        text: languagesController.tr("CURRENCY"),

                        color: AppColors.primaryColor,

                        fontSize: 16,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
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

                const SizedBox(height: 12),

                Expanded(
                  child: Obx(() {
                    if (hawalaCurrencyController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final uniqueRates = _uniqueRates();

                    final entries = uniqueRates.entries.toList();

                    if (entries.isEmpty) {
                      return Center(
                        child: NText(
                          text: languagesController.tr("NO_DATA_FOUND"),

                          color: AppColors.fontColor,

                          fontSize: 13,

                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),

                      itemCount: entries.length,

                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },

                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        final rate = entry.value;

                        final symbol = ((rate?.toCurrency?.symbol) ?? "")
                            .toString();

                        final code = ((rate?.toCurrency?.code) ?? "")
                            .toString();

                        final sellRate = (rate?.sellRate ?? "").toString();

                        final amount = (rate?.amount ?? "").toString();

                        final isSelected =
                            addHawalaController.currencyID.value == entry.key;

                        return GestureDetector(
                          onTap: () {
                            addHawalaController.currencyID.value = entry.key;

                            addHawalaController.currency.value = symbol;

                            addHawalaController.selectedRate.value = rate;

                            _recalculateFinalAmount();

                            Navigator.pop(dialogContext);
                          },

                          child: Container(
                            padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(0.07)
                                  : AppColors.primaryColor.withOpacity(0.035),

                              borderRadius: BorderRadius.circular(13),

                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.primaryColor.withOpacity(0.07),
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  height: 36,

                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                  ),

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),

                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),

                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: NText(
                                    text: symbol,

                                    color: AppColors.primaryColor,

                                    fontSize: 11,

                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      NText(
                                        text: code.isEmpty ? symbol : code,

                                        color: AppColors.primaryColor,

                                        fontSize: 13,

                                        fontWeight: FontWeight.w700,

                                        maxLines: 1,

                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 3),

                                      NText(
                                        text: "$amount / $sellRate",

                                        color: AppColors.fontColor,

                                        fontSize: 10,

                                        fontWeight: FontWeight.w500,

                                        maxLines: 1,

                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,

                                    color: AppColors.primaryColor,

                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBranchDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            constraints: const BoxConstraints(maxHeight: 430),

            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 38,

                      width: 38,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primarycolor2,

                            AppColors.primaryColor,
                          ],
                        ),

                        borderRadius: BorderRadius.circular(11),
                      ),

                      child: const Icon(
                        Icons.location_on_outlined,

                        color: Colors.white,

                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: NText(
                        text: languagesController.tr("BRANCH"),

                        color: AppColors.primaryColor,

                        fontSize: 16,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
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

                const SizedBox(height: 12),

                Expanded(
                  child: Obx(() {
                    if (branchController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final branches =
                        branchController.allbranch.value.data?.hawalabranches ??
                        [];

                    if (branches.isEmpty) {
                      return Center(
                        child: NText(
                          text: languagesController.tr("NO_DATA_FOUND"),

                          color: AppColors.fontColor,

                          fontSize: 13,

                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),

                      itemCount: branches.length,

                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },

                      itemBuilder: (context, index) {
                        final data = branches[index];

                        final isSelected =
                            addHawalaController.branchId.value ==
                            data.id.toString();

                        return GestureDetector(
                          onTap: () {
                            addHawalaController.branch.value = data.name
                                .toString();

                            addHawalaController.branchId.value = data.id
                                .toString();

                            Navigator.pop(dialogContext);
                          },

                          child: Container(
                            padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(0.07)
                                  : AppColors.primaryColor.withOpacity(0.035),

                              borderRadius: BorderRadius.circular(13),

                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.primaryColor.withOpacity(0.07),
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  height: 36,

                                  width: 36,

                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),

                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: const Icon(
                                    Icons.location_city_outlined,

                                    color: AppColors.primaryColor,

                                    size: 18,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      NText(
                                        text: data.name.toString(),

                                        color: AppColors.primaryColor,

                                        fontSize: 13,

                                        fontWeight: FontWeight.w700,

                                        maxLines: 2,

                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      if (data.address != null &&
                                          data.address
                                              .toString()
                                              .trim()
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 3),

                                        NText(
                                          text: data.address.toString(),

                                          color: AppColors.fontColor,

                                          fontSize: 10,

                                          fontWeight: FontWeight.w500,

                                          maxLines: 2,

                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,

                                    color: AppColors.primaryColor,

                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitHawala() async {
    final hasSender = addHawalaController.senderNameController.text.isNotEmpty;

    final hasReceiver =
        addHawalaController.receiverNameController.text.isNotEmpty;

    final hasAmount = addHawalaController.amountController.text.isNotEmpty;

    final hasBranch = addHawalaController.branchId.value.isNotEmpty;

    final hasCurrency = addHawalaController.currencyID.value.isNotEmpty;

    if (!hasSender ||
        !hasReceiver ||
        !hasAmount ||
        !hasBranch ||
        !hasCurrency) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.TOP,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.red,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    final success = await addHawalaController.createhawala();

    if (success) {
      Get.find<Mypagecontroller>().goBack();
    }
  }
}
