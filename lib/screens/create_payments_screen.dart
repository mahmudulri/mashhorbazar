import 'dart:io';

import 'package:mashhorbazar/controllers/add_payment_controller.dart';

import 'package:mashhorbazar/controllers/currency_controller.dart';

import 'package:mashhorbazar/controllers/payment_method_controller.dart';

import 'package:mashhorbazar/controllers/payment_type_controller.dart';

import 'package:mashhorbazar/controllers/sign_in_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/payment_method_model.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

class CreatePaymentsScreen extends StatefulWidget {
  const CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );

  final PaymentTypeController paymentTypeController = Get.put(
    PaymentTypeController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final AddPaymentController addPaymentController = Get.put(
    AddPaymentController(),
  );

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Rx<DateTime?> mydate;

  final RxString selectedMethod = "".obs;

  final RxString selectedType = "".obs;

  final RxString selectedcurrency = "".obs;

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

    final now = DateTime.now();

    mydate = Rx<DateTime?>(now);

    addPaymentController.selectedDate.value = DateFormat(
      "yyyy-MM-dd",
    ).format(now);

    paymentMethodController.fetchmethods();

    currencyController.fetchCurrencyList();

    paymentTypeController.fetchtypes();

    selectedcurrency.value = (box.read("currency_code") ?? "").toString();

    addPaymentController.currencyID.value = (box.read("countryID") ?? "")
        .toString();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,

      initialDate: mydate.value ?? DateTime.now(),

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

    mydate.value = picked;

    addPaymentController.selectedDate.value = DateFormat(
      "yyyy-MM-dd",
    ).format(picked);
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
                  text: languagesController.tr("ADD_NEW_RECEIPT"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("PAYMENT_METHOD"),
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
                  Icons.receipt_long_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: languagesController.tr("ADD_NEW_RECEIPT"),
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _fieldLabel(languagesController.tr("PAYMENT_METHOD")),
          const SizedBox(height: 7),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _fieldLabel(languagesController.tr("AMOUNT")),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _fieldLabel(languagesController.tr("CURRENCY")),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(flex: 3, child: _buildAmountField()),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _buildCurrencySelector()),
            ],
          ),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("PAYMENT_DATE")),
          const SizedBox(height: 7),
          _buildDateField(),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("TRACKING_CODE")),
          const SizedBox(height: 7),
          Authtextfield(
            hinttext: "",
            controller: addPaymentController.trackingCodeController,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _fieldLabel(languagesController.tr("NOTES")),
              const SizedBox(width: 6),
              NText(
                text: "(${languagesController.tr("OPTIONAL")})",
                color: AppColors.fontColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Authtextfield(
            hinttext: "",
            controller: addPaymentController.noteController,
          ),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("PAYMENT_TYPE")),
          const SizedBox(height: 7),
          _buildPaymentTypeSelector(),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("UPLOAD_IMAGES")),
          const SizedBox(height: 8),
          _buildImageUploaders(),
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

  Widget _buildPaymentMethodSelector() {
    return GestureDetector(
      onTap: showPaymentMethodBottomSheet,
      child: Container(
        height: 52,
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
                Icons.account_balance_wallet_outlined,
                color: AppColors.primaryColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final value = selectedMethod.value;

                return NText(
                  text: value.isEmpty
                      ? languagesController.tr("PAYMENT_METHOD")
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
            Obx(
              () => Icon(
                selectedMethod.value.isEmpty
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.edit_outlined,
                color: AppColors.primaryColor,
                size: 21,
              ),
            ),
          ],
        ),
      ),
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
              controller: addPaymentController.amountController,
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
                hintText: languagesController.tr("AMOUNT"),
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
                  text: selectedcurrency.value,
                  color: selectedcurrency.value.isEmpty
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

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () {
        pickStartDate(context);
      },
      child: Container(
        height: 52,
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
                Icons.calendar_month_rounded,
                color: AppColors.primaryColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => NText(
                  text: addPaymentController.selectedDate.value,
                  color: const Color(0xFF263B54),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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

  Widget _buildPaymentTypeSelector() {
    return GestureDetector(
      onTap: _showPaymentTypeDialog,
      child: Container(
        height: 52,
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
                Icons.category_outlined,
                color: AppColors.primaryColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => NText(
                  text: selectedType.value.isEmpty
                      ? languagesController.tr("PAYMENT_TYPE")
                      : selectedType.value,
                  color: selectedType.value.isEmpty
                      ? AppColors.fontColor
                      : const Color(0xFF263B54),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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

  Widget _buildImageUploaders() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      physics: const BouncingScrollPhysics(),

      child: Row(
        children: [
          buildImageUploaderBox(
            context,

            languagesController.tr("IMAGE_ONE"),

            addPaymentController.paymentImagePath,

            () => addPaymentController.pickImage("payment"),
          ),

          const SizedBox(width: 10),

          buildImageUploaderBox(
            context,

            languagesController.tr("IMAGE_TOW"),

            addPaymentController.extraImage1Path,

            () => addPaymentController.pickImage("extra1"),
          ),

          const SizedBox(width: 10),

          buildImageUploaderBox(
            context,

            languagesController.tr("IMAGE_THREE"),

            addPaymentController.extraImage2Path,

            () => addPaymentController.pickImage("extra2"),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => GestureDetector(
        onTap: addPaymentController.isLoading.value ? null : _submitPayment,
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: addPaymentController.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: addPaymentController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: addPaymentController.isLoading.value
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
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    NText(
                      text: languagesController.tr("ADD_NOW"),
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

  void _submitPayment() {
    final invalid =
        addPaymentController.payment_method_id.value.isEmpty ||
        addPaymentController.amountController.text.isEmpty ||
        addPaymentController.currencyID.value.isEmpty ||
        addPaymentController.selectedDate.value.isEmpty ||
        addPaymentController.trackingCodeController.text.isEmpty;

    if (invalid) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    addPaymentController.addNow();
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            constraints: const BoxConstraints(maxHeight: 420),

            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [
                Row(
                  children: [
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
                    if (currencyController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final currencies =
                        currencyController
                            .allcurrencylist
                            .value
                            .data
                            ?.currencies ??
                        [];

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),

                      itemCount: currencies.length,

                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },

                      itemBuilder: (context, index) {
                        final data = currencies[index];

                        return GestureDetector(
                          onTap: () {
                            addPaymentController.currencyID.value = data.id
                                .toString();

                            selectedcurrency.value = data.code.toString();

                            Navigator.pop(dialogContext);
                          },

                          child: Container(
                            height: 48,

                            padding: const EdgeInsets.symmetric(horizontal: 12),

                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.035),

                              borderRadius: BorderRadius.circular(12),

                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.07),
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  height: 30,

                                  constraints: const BoxConstraints(
                                    minWidth: 30,
                                  ),

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                  ),

                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),

                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  child: NText(
                                    text: data.symbol.toString(),

                                    color: AppColors.primaryColor,

                                    fontSize: 11,

                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: NText(
                                    text: data.code.toString(),

                                    color: AppColors.primaryColor,

                                    fontSize: 13,

                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios_rounded,

                                  color: AppColors.fontColor,

                                  size: 13,
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

  void _showPaymentTypeDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            constraints: const BoxConstraints(maxHeight: 380),

            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: NText(
                        text: languagesController.tr("PAYMENT_TYPE"),

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
                    if (paymentTypeController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final types =
                        paymentTypeController
                            .alltypes
                            .value
                            .data
                            ?.paymentTypes ??
                        [];

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),

                      itemCount: types.length,

                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },

                      itemBuilder: (context, index) {
                        final data = types[index];

                        return GestureDetector(
                          onTap: () {
                            addPaymentController.payment_type_id.value = data.id
                                .toString();

                            selectedType.value = data.name.toString();

                            Navigator.pop(dialogContext);
                          },

                          child: Container(
                            constraints: const BoxConstraints(minHeight: 48),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,

                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.035),

                              borderRadius: BorderRadius.circular(12),

                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.07),
                              ),
                            ),

                            child: Row(
                              children: [
                                Container(
                                  height: 30,

                                  width: 30,

                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),

                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  child: const Icon(
                                    Icons.category_outlined,

                                    color: AppColors.primaryColor,

                                    size: 16,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: NText(
                                    text: data.name.toString(),

                                    color: AppColors.primaryColor,

                                    fontSize: 13,

                                    fontWeight: FontWeight.w700,

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,
                                  ),
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

  void showPaymentMethodBottomSheet() {
    final RxString selectedFilter = "All".obs;

    final RxString temporarySelectedId =
        addPaymentController.payment_method_id.value.obs;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      useSafeArea: true,

      backgroundColor: Colors.transparent,

      barrierColor: Colors.black.withOpacity(0.35),

      builder: (sheetContext) {
        final screenHeight = MediaQuery.of(sheetContext).size.height;

        return SafeArea(
          child: Container(
            height: screenHeight * 0.78,

            decoration: const BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),

            child: Column(
              children: [
                const SizedBox(height: 10),

                Container(
                  width: 46,

                  height: 5,

                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),

                    borderRadius: BorderRadius.circular(50),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),

                  child: Row(
                    children: [
                      Container(
                        height: 40,

                        width: 40,

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primarycolor2,

                              AppColors.primaryColor,
                            ],
                          ),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.account_balance_wallet_outlined,

                          color: Colors.white,

                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: NText(
                          text: languagesController.tr("PAYMENT_METHOD"),

                          color: AppColors.primaryColor,

                          fontSize: 17,

                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetContext);
                        },

                        child: Container(
                          height: 36,

                          width: 36,

                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.05),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.close_rounded,

                            color: AppColors.primaryColor,

                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: Obx(() {
                    if (paymentMethodController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    final List<PaymentMethod> allMethods =
                        paymentMethodController
                            .allmethods
                            .value
                            .data
                            ?.paymentMethods ??
                        <PaymentMethod>[];

                    if (allMethods.isEmpty) {
                      return Center(
                        child: NText(
                          text: languagesController.tr("NO_DATA_FOUND"),

                          color: AppColors.fontColor,

                          fontSize: 13,

                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }

                    final methodNames = <String>[];

                    for (final method in allMethods) {
                      final name = method.methodName?.trim() ?? "";

                      if (name.isNotEmpty && !methodNames.contains(name)) {
                        methodNames.add(name);
                      }
                    }

                    final filters = ["All", ...methodNames];

                    final filteredMethods = selectedFilter.value == "All"
                        ? allMethods
                        : allMethods.where((element) {
                            return element.methodName?.trim() ==
                                selectedFilter.value;
                          }).toList();

                    return Column(
                      children: [
                        SizedBox(
                          height: 42,

                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),

                            scrollDirection: Axis.horizontal,

                            itemCount: filters.length,

                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 8);
                            },

                            itemBuilder: (context, index) {
                              final filter = filters[index];

                              final isSelected = selectedFilter.value == filter;

                              return GestureDetector(
                                onTap: () {
                                  selectedFilter.value = filter;
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,

                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.primaryColor.withOpacity(
                                            0.04,
                                          ),

                                    borderRadius: BorderRadius.circular(22),

                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                              0.08,
                                            ),
                                    ),
                                  ),

                                  alignment: Alignment.center,

                                  child: NText(
                                    text: filter,

                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryColor,

                                    fontSize: 11.5,

                                    fontWeight: FontWeight.w600,

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: filteredMethods.isEmpty
                              ? Center(
                                  child: NText(
                                    text: languagesController.tr(
                                      "NO_DATA_FOUND",
                                    ),

                                    color: AppColors.fontColor,

                                    fontSize: 13,

                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,

                                    vertical: 4,
                                  ),

                                  itemCount: filteredMethods.length,

                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 9);
                                  },

                                  itemBuilder: (context, index) {
                                    final data = filteredMethods[index];

                                    return Obx(() {
                                      final isSelected =
                                          temporarySelectedId.value ==
                                          data.id?.toString();

                                      return PaymentMethodSelectionCard(
                                        paymentMethod: data,

                                        isSelected: isSelected,

                                        onTap: () {
                                          temporarySelectedId.value =
                                              data.id?.toString() ?? "";
                                        },
                                      );
                                    });
                                  },
                                ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),

                          child: Obx(() {
                            final canContinue =
                                temporarySelectedId.value.isNotEmpty;

                            return GestureDetector(
                              onTap: !canContinue
                                  ? null
                                  : () {
                                      PaymentMethod? selectedPaymentMethod;

                                      for (final method in allMethods) {
                                        if (method.id?.toString() ==
                                            temporarySelectedId.value) {
                                          selectedPaymentMethod = method;

                                          break;
                                        }
                                      }

                                      if (selectedPaymentMethod == null) {
                                        return;
                                      }

                                      addPaymentController
                                              .payment_method_id
                                              .value =
                                          selectedPaymentMethod.id
                                              ?.toString() ??
                                          "";

                                      selectedMethod.value =
                                          selectedPaymentMethod.methodName ??
                                          "";

                                      Navigator.pop(sheetContext);
                                    },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),

                                width: double.infinity,

                                height: 50,

                                decoration: BoxDecoration(
                                  gradient: canContinue
                                      ? const LinearGradient(
                                          colors: [
                                            AppColors.primarycolor2,

                                            AppColors.primaryColor,
                                          ],
                                        )
                                      : null,

                                  color: canContinue
                                      ? null
                                      : AppColors.primaryColor.withOpacity(
                                          0.08,
                                        ),

                                  borderRadius: BorderRadius.circular(14),
                                ),

                                alignment: Alignment.center,

                                child: NText(
                                  text: "Continue",

                                  color: canContinue
                                      ? Colors.white
                                      : AppColors.fontColor,

                                  fontSize: 13.5,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
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
}

Widget buildImageUploaderBox(
  BuildContext context,

  String label,

  RxString imagePath,

  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,

          child: Container(
            width: 145,

            height: 132,

            decoration: BoxDecoration(
              color: Colors.white,

              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.13),
              ),

              borderRadius: BorderRadius.circular(14),
            ),

            clipBehavior: Clip.antiAlias,

            child: imagePath.value.isNotEmpty
                ? Image.file(
                    File(imagePath.value),

                    width: 145,

                    height: 132,

                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        height: 42,

                        width: 42,

                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.08),

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.add_photo_alternate_outlined,

                          color: AppColors.primaryColor,

                          size: 21,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),

                        child: NText(
                          text: label,

                          fontSize: 11,

                          color: AppColors.fontColor,

                          fontWeight: FontWeight.w600,

                          textAlign: TextAlign.center,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 6,

            right: 6,

            child: GestureDetector(
              onTap: () {
                imagePath.value = "";
              },

              child: Container(
                height: 28,

                width: 28,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.close_rounded,

                  size: 17,

                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class PaymentMethodSelectionCard extends StatelessWidget {
  const PaymentMethodSelectionCard({
    super.key,

    required this.paymentMethod,

    required this.isSelected,

    required this.onTap,
  });

  final PaymentMethod paymentMethod;

  final bool isSelected;

  final VoidCallback onTap;

  bool _hasValue(String? value) {
    if (value == null) {
      return false;
    }

    final text = value.trim();

    return text.isNotEmpty && text.toLowerCase() != "null" && text != ".";
  }

  String _getPrimaryNumber() {
    if (_hasValue(paymentMethod.accountNumber)) {
      return paymentMethod.accountNumber!.trim();
    }

    if (_hasValue(paymentMethod.cardNumber)) {
      return paymentMethod.cardNumber!.trim();
    }

    if (_hasValue(paymentMethod.accountHolderName)) {
      return paymentMethod.accountHolderName!.trim();
    }

    return "";
  }

  bool _shouldShowShebaWarning() {
    if (!_hasValue(paymentMethod.shebaNumber)) {
      return false;
    }

    final sheba = paymentMethod.shebaNumber!.trim();

    if (sheba == paymentMethod.accountNumber?.trim()) {
      return false;
    }

    if (sheba == paymentMethod.cardNumber?.trim()) {
      return false;
    }

    return true;
  }

  bool _hasUsableImage() {
    final image = paymentMethod.accountImage?.trim() ?? "";

    if (image.isEmpty || !image.startsWith("http")) {
      return false;
    }

    final uri = Uri.tryParse(image);

    if (uri == null || uri.pathSegments.isEmpty) {
      return false;
    }

    final lastSegment = uri.pathSegments.last.trim();

    return lastSegment.contains(".");
  }

  Future<void> _copyValue(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    Fluttertoast.showToast(
      msg: "Copied",

      toastLength: Toast.LENGTH_SHORT,

      gravity: ToastGravity.BOTTOM,

      backgroundColor: Colors.black87,

      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryNumber = _getPrimaryNumber();

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.035)
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.07),

            width: isSelected ? 1.4 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.035),

              blurRadius: 10,

              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: 56,

              height: 56,

              decoration: BoxDecoration(
                color: AppColors.mashhorbazarBackground,

                borderRadius: BorderRadius.circular(14),
              ),

              clipBehavior: Clip.antiAlias,

              child: _hasUsableImage()
                  ? Image.network(
                      paymentMethod.accountImage!,

                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: SizedBox(
                            width: 20,

                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,

                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.account_balance_wallet_outlined,

                          color: AppColors.primaryColor,

                          size: 27,
                        );
                      },
                    )
                  : const Icon(
                      Icons.account_balance_wallet_outlined,

                      color: AppColors.primaryColor,

                      size: 27,
                    ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: NText(
                          text: paymentMethod.methodName ?? "",

                          color: AppColors.primaryColor,

                          fontSize: 13.5,

                          fontWeight: FontWeight.w700,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      if (_hasValue(paymentMethod.bankName))
                        Container(
                          constraints: const BoxConstraints(maxWidth: 110),

                          margin: const EdgeInsets.only(left: 6),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,

                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.08),

                            borderRadius: BorderRadius.circular(7),
                          ),

                          child: NText(
                            text: paymentMethod.bankName!,

                            color: AppColors.primaryColor,

                            fontSize: 9.5,

                            fontWeight: FontWeight.w600,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),

                  if (_hasValue(paymentMethod.accountHolderName)) ...[
                    const SizedBox(height: 5),

                    NText(
                      text: paymentMethod.accountHolderName!,

                      color: AppColors.fontColor,

                      fontSize: 11,

                      fontWeight: FontWeight.w500,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  if (primaryNumber.isNotEmpty) ...[
                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Expanded(
                          child: NText(
                            text: primaryNumber,

                            color: AppColors.primaryColor,

                            fontSize: 11.5,

                            fontWeight: FontWeight.w600,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _copyValue(primaryNumber);
                          },

                          child: Container(
                            height: 30,

                            width: 30,

                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),

                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: const Icon(
                              Icons.copy_rounded,

                              color: AppColors.primaryColor,

                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_shouldShowShebaWarning()) ...[
                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,

                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6DA),

                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,

                            color: Color(0xFFE0A51B),

                            size: 17,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: NText(
                              text: paymentMethod.shebaNumber!,

                              color: const Color(0xFF8A6817),

                              fontSize: 10.5,

                              fontWeight: FontWeight.w500,

                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_hasValue(paymentMethod.accountDetails)) ...[
                    const SizedBox(height: 7),

                    NText(
                      text: paymentMethod.accountDetails!,

                      color: AppColors.fontColor,

                      fontSize: 10.5,

                      fontWeight: FontWeight.w500,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      height: 1.35,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 9),

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              width: 32,

              height: 32,

              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,

                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.16),

                  width: 1.3,
                ),
              ),

              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,

                      color: Colors.white,

                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
