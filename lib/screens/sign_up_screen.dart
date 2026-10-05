import 'dart:io';

import 'package:mashhorbazar/controllers/currency_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/socialbuttonbox.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:url_launcher/url_launcher.dart';

import '../controllers/country_list_controller.dart';

import '../controllers/district_controller.dart';

import '../controllers/province_controller.dart';

import '../controllers/sign_up_controller.dart';

import '../models/currency_model.dart';

import '../widgets/bottomsheet.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final SignUpController signUpController = Get.put(SignUpController());

  final box = GetStorage();

  final String phoneNumber = "+93708488200";

  String selectedCountry = "";

  String selectedProvince = "";

  String selectedDistrict = "";

  bool isPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: Brightness.light,

        statusBarBrightness: Brightness.dark,

        systemNavigationBarColor: AppColors.mashhorbazarBackground,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    countryListController.fetchCountryData();

    districtController.fetchDistrict();

    provinceController.fetchProvince();

    currencyController.fetchCurrencyList();
  }

  bool get isRtl {
    final direction = box.read("direction")?.toString().toLowerCase();

    return direction == "rtl";
  }

  Alignment get fieldAlignment =>
      isRtl ? Alignment.centerRight : Alignment.centerLeft;

  TextAlign get fieldTextAlign => isRtl ? TextAlign.right : TextAlign.left;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.mashhorbazarBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppColors.mashhorbazarBackground),
          ),

          /// =========================================================
          /// BLUE HERO HEADER
          /// =========================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D78E8),
                    AppColors.primaryColor,
                    Color(0xFF00469B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(46),
                  bottomRight: Radius.circular(46),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -90,
                    right: -70,
                    child: _heroCircle(220, 0.07),
                  ),
                  Positioned(top: 80, left: -95, child: _heroCircle(210, 0.05)),
                  Positioned(right: 34, bottom: 42, child: _heroDot(8, 0.20)),
                  Positioned(right: 57, bottom: 66, child: _heroDot(5, 0.13)),
                ],
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 34),
              children: [
                /// =====================================================
                /// TOP BAR
                /// =====================================================
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.20),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 8),

                /// =====================================================
                /// HEADER LOGO + TITLE
                /// =====================================================
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 76,
                        width: 76,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/icons/logo.png",
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      NText(
                        text: languagesController.tr("REGISTER"),
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// =====================================================
                /// REGISTRATION CARD
                /// =====================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE8EEF5)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF173B66).withOpacity(0.10),
                        blurRadius: 34,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sectionTitle(
                        icon: Icons.person_outline_rounded,
                        title: languagesController.tr("PERSONAL_INFORMATION"),
                        fallbackTitle: "Personal information",
                      ),
                      const SizedBox(height: 18),

                      _fieldLabel(languagesController.tr("FULL_NAME")),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.resellerNameController,
                        hintText: languagesController.tr(
                          "ENTER_YOUR_FULL_NAME",
                        ),
                        icon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(languagesController.tr("CONTACT_NAME")),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.contactNameController,
                        hintText: languagesController.tr("ENTER_CONTACT_NAME"),
                        icon: Icons.badge_outlined,
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(languagesController.tr("PHONE_NUMBER")),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.phoneController,
                        hintText: languagesController.tr("ENTER_PHONE_NUMBER"),
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(
                        languagesController.tr("EMAIL"),
                        optional: true,
                      ),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.emailController,
                        hintText: languagesController.tr("EMAIL_ADDRESS"),
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 26),
                      _softDivider(),
                      const SizedBox(height: 22),

                      _sectionTitle(
                        icon: Icons.public_rounded,
                        title: languagesController.tr("LOCATION"),
                        fallbackTitle: "Location & currency",
                      ),
                      const SizedBox(height: 18),

                      _fieldLabel(languagesController.tr("CURRENCY")),
                      const SizedBox(height: 7),
                      _currencyDropdown(screenHeight),

                      const SizedBox(height: 15),

                      _fieldLabel(
                        languagesController.tr("COUNTRY_OF_RESIDENCE"),
                      ),
                      const SizedBox(height: 7),
                      _countryDropdown(screenHeight),

                      const SizedBox(height: 15),

                      _fieldLabel(
                        languagesController.tr("PROVINCE"),
                        optional: true,
                      ),
                      const SizedBox(height: 7),
                      _provinceDropdown(screenHeight),

                      const SizedBox(height: 15),

                      _fieldLabel(
                        languagesController.tr("DISTRICT"),
                        optional: true,
                      ),
                      const SizedBox(height: 7),
                      _districtDropdown(screenHeight),

                      const SizedBox(height: 26),
                      _softDivider(),
                      const SizedBox(height: 22),

                      _sectionTitle(
                        icon: Icons.cloud_upload_outlined,
                        title: languagesController.tr("DOCUMENTS"),
                        fallbackTitle: "Documents",
                      ),
                      const SizedBox(height: 18),

                      _fieldLabel(
                        languagesController.tr("UPLOAD_PHOTO"),
                        optional: true,
                      ),
                      const SizedBox(height: 10),

                      Center(
                        child: Obx(
                          () => GestureDetector(
                            onTap: () async {
                              await signUpController.uploadImage();

                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: DottedBorder(
                              color: AppColors.primaryColor.withOpacity(0.34),
                              strokeWidth: 1.4,
                              dashPattern: const [6, 4],
                              borderType: BorderType.Circle,
                              child: Container(
                                height: 112,
                                width: 112,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5F9FE),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.secondaryColor,
                                  child:
                                      signUpController
                                          .selectedImagePath
                                          .value
                                          .isEmpty
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 36,
                                              width: 36,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: AppColors.primaryColor,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                  ),
                                              child: NText(
                                                text: languagesController.tr(
                                                  "UPLOAD_PHOTO",
                                                ),
                                                textAlign: TextAlign.center,
                                                fontSize: 10.5,
                                                color: const Color(0xFF6F7F94),
                                              ),
                                            ),
                                          ],
                                        )
                                      : ClipOval(
                                          child: Image.file(
                                            signUpController.imageFile!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _fieldLabel(
                        languagesController.tr("IDENTITY_ATTACHMENT"),
                        optional: true,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => _uploadBox(
                          hasImage: signUpController
                              .selectedIdentityPath
                              .value
                              .isNotEmpty,
                          imagePath:
                              signUpController.selectedIdentityPath.value,
                          emptyText: languagesController.tr(
                            "TAP_TO_UPLOAD_IDENTITY_IMAGE",
                          ),
                          onTap: () async {
                            await signUpController.uploadIdentityAttachment();

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          onRemove: () {
                            signUpController.selectedIdentityPath.value = '';
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      _fieldLabel(
                        languagesController.tr("EXTRA_PROOF"),
                        optional: true,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => _uploadBox(
                          hasImage: signUpController
                              .selectedExtraProofPath
                              .value
                              .isNotEmpty,
                          imagePath:
                              signUpController.selectedExtraProofPath.value,
                          emptyText: languagesController.tr(
                            "TAP_TO_UPLOAD_EXTRA_PROOF",
                          ),
                          onTap: () async {
                            await signUpController.uploadExtraOptionalProof();

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          onRemove: () {
                            signUpController.selectedExtraProofPath.value = '';
                          },
                        ),
                      ),

                      const SizedBox(height: 26),
                      _softDivider(),
                      const SizedBox(height: 22),

                      _sectionTitle(
                        icon: Icons.shield_outlined,
                        title: languagesController.tr("SECURITY"),
                        fallbackTitle: "Security",
                      ),
                      const SizedBox(height: 18),

                      _fieldLabel(
                        languagesController.tr("ENTER_YOUR_PIN"),
                        optional: true,
                      ),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.pinController,
                        hintText: languagesController.tr("NEW_PIN"),
                        icon: Icons.pin_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(
                        languagesController.tr("CONFIRM_PIN"),
                        optional: true,
                      ),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.confirmPinController,
                        hintText: languagesController.tr("CONFIRM_PIN"),
                        icon: Icons.verified_user_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(languagesController.tr("PASSWORD")),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.passwordController,
                        hintText: languagesController.tr("PASSWORD"),
                        icon: Icons.lock_outline_rounded,
                        obscureText: !isPasswordVisible,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      _fieldLabel(languagesController.tr("CONFIRM_PASSWORD")),
                      const SizedBox(height: 7),
                      _authField(
                        controller: signUpController.confirmPassController,
                        hintText: languagesController.tr("CONFIRM_PASSWORD"),
                        icon: Icons.lock_reset_outlined,
                        obscureText: !isConfirmPasswordVisible,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      /// REGISTER BUTTON
                      Obx(
                        () => GestureDetector(
                          onTap: signUpController.isLoading.value
                              ? null
                              : () async {
                                  final error = signUpController
                                      .validateInputs();

                                  if (error != null) {
                                    Get.snackbar(
                                      languagesController.tr("INVALID_INPUT"),
                                      error,
                                      backgroundColor: const Color(0xFF10233F),
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  await signUpController.registernow();
                                },
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: signUpController.isLoading.value
                                ? 0.65
                                : 1,
                            child: Container(
                              height: 56,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(17),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.24,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 9),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Center(
                                        child: NText(
                                          text: signUpController.isLoading.value
                                              ? languagesController.tr(
                                                  "PLEASE_WAIT",
                                                )
                                              : languagesController.tr(
                                                  "REGISTER",
                                                ),
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            NText(
                              text: languagesController.tr(
                                "ALREADY_REGISTERED",
                              ),
                              color: const Color(0xFF7C899A),
                              fontSize: 13.5,
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: NText(
                                text: languagesController.tr("LOGIN"),
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                /// =====================================================
                /// SUPPORT
                /// =====================================================
                NText(
                  text: languagesController.tr("FIND_US_ON"),
                  color: const Color(0xFF8C99AA),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                _socialSection(screenWidth),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// SECTION TITLE
  /// ============================================================
  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String fallbackTitle,
  }) {
    final displayTitle = title.trim().isEmpty ? fallbackTitle : title;

    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 21),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: NText(
            text: displayTitle,
            color: const Color(0xFF10233F),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _softDivider() {
    return Container(height: 1, color: const Color(0xFFE8EEF5));
  }

  Widget _heroCircle(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _heroDot(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  /// ============================================================
  /// FIELD LABEL
  /// ============================================================
  Widget _fieldLabel(String text, {bool optional = false}) {
    return Row(
      children: [
        Flexible(
          child: NText(
            text: text,
            color: const Color(0xFF31445D),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 5),
          NText(
            text: "(${languagesController.tr("OPTIONAL")})",
            color: const Color(0xFF9AA7B7),
            fontSize: 11.5,
          ),
        ],
      ],
    );
  }

  /// ============================================================
  /// AUTH FIELD
  /// ============================================================
  Widget _authField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 1.1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 13),
          Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              textAlign: fieldTextAlign,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF20344F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration:
                  const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ).copyWith(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFFA1ADBC),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 8),
            suffixIcon,
            const SizedBox(width: 11),
          ] else
            const SizedBox(width: 14),
        ],
      ),
    );
  }

  /// ============================================================
  /// DROPDOWN WRAPPER
  /// ============================================================
  Widget _dropdownWrapper({required Widget child}) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 1.1),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _dropdownIcon() {
    return const Icon(
      FontAwesomeIcons.chevronDown,
      color: AppColors.primaryColor,
      size: 13,
    );
  }

  /// CURRENCY DROPDOWN

  /// ============================================================

  Widget _currencyDropdown(double screenHeight) {
    return _dropdownWrapper(
      child: Obx(() {
        final List<Currency> currencies =
            currencyController.allcurrencylist.value.data?.currencies ??
            <Currency>[];

        final List<Currency> usable = currencies
            .where((currency) => currency.id != null)
            .toList();

        final String? selectedCurrencyId =
            signUpController.currencyId.value.isEmpty
            ? null
            : signUpController.currencyId.value;

        final bool selectedExists =
            selectedCurrencyId != null &&
            usable.any(
              (currency) => currency.id.toString() == selectedCurrencyId,
            );

        final String? currentValue = selectedExists ? selectedCurrencyId : null;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: currentValue,

            dropdownColor: Colors.white,

            icon: _dropdownIcon(),

            borderRadius: BorderRadius.circular(12),

            hint: Align(
              alignment: fieldAlignment,

              child: NText(
                text: languagesController.tr("CURRENCY"),

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                color: const Color(0xFF9AA7B7),

                fontSize: 14,

                textAlign: fieldTextAlign,
              ),
            ),

            selectedItemBuilder: (context) {
              return usable.map<Widget>((currency) {
                return Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: _currencyName(currency),

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                );
              }).toList();
            },

            items: usable.map<DropdownMenuItem<String>>((currency) {
              return DropdownMenuItem<String>(
                value: currency.id.toString(),

                child: Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: _currencyName(currency),

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              signUpController.currencyId.value = value;
            },
          ),
        );
      }),
    );
  }

  String _currencyName(Currency currency) {
    final name = (currency.name ?? '').trim();

    final code = (currency.code ?? '').trim();

    final symbol = (currency.symbol ?? '').trim();

    if (name.isNotEmpty && code.isNotEmpty) {
      return "$name ($code)";
    }

    if (code.isNotEmpty && symbol.isNotEmpty) {
      return "$code ($symbol)";
    }

    if (code.isNotEmpty) {
      return code;
    }

    if (symbol.isNotEmpty) {
      return symbol;
    }

    return name;
  }

  /// ============================================================

  /// COUNTRY DROPDOWN

  /// ============================================================

  Widget _countryDropdown(double screenHeight) {
    return _dropdownWrapper(
      child: Obx(() {
        final countries =
            countryListController.allcountryListData.value.data?.countries ??
            <dynamic>[];

        final String? selectedCountryId =
            signUpController.countryId.value.isEmpty
            ? null
            : signUpController.countryId.value;

        final bool selectedExists =
            selectedCountryId != null &&
            countries.any(
              (country) =>
                  ((country?.id) ?? '').toString() == selectedCountryId,
            );

        final String? currentValue = selectedExists ? selectedCountryId : null;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: currentValue,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(12),

            icon: _dropdownIcon(),

            hint: Align(
              alignment: fieldAlignment,

              child: NText(
                text: languagesController.tr("COUNTRY_OF_RESIDENCE"),

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                color: const Color(0xFF9AA7B7),

                fontSize: 14,

                textAlign: fieldTextAlign,
              ),
            ),

            selectedItemBuilder: (context) {
              return countries.map<Widget>((country) {
                final name = ((country?.countryName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                );
              }).toList();
            },

            items: countries.map<DropdownMenuItem<String>>((country) {
              final id = ((country?.id) ?? '').toString();

              final name = ((country?.countryName) ?? '').toString();

              final flagUrl = ((country?.countryFlagImageUrl) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,

                child: Row(
                  children: [
                    if (flagUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),

                        child: Image.network(
                          flagUrl,

                          height: 24,

                          width: 36,

                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),

                    if (flagUrl.isNotEmpty) const SizedBox(width: 10),

                    Expanded(
                      child: NText(
                        text: name,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        color: const Color(0xFF26384F),

                        fontSize: 14,

                        fontWeight: FontWeight.w500,

                        textAlign: fieldTextAlign,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final country in countries) {
                if (((country?.id) ?? '').toString() == value) {
                  picked = country;

                  break;
                }
              }

              signUpController.countryId.value = value;

              selectedCountry = ((picked?.countryName) ?? '').toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  /// ============================================================

  /// PROVINCE DROPDOWN

  /// ============================================================

  Widget _provinceDropdown(double screenHeight) {
    return _dropdownWrapper(
      child: Obx(() {
        final provinces =
            provinceController.allprovincelist.value.data?.provinces ??
            <dynamic>[];

        final String? selectedProvinceId =
            signUpController.provinceId.value.isEmpty
            ? null
            : signUpController.provinceId.value;

        final bool selectedExists =
            selectedProvinceId != null &&
            provinces.any(
              (province) =>
                  ((province?.id) ?? '').toString() == selectedProvinceId,
            );

        final String? currentValue = selectedExists ? selectedProvinceId : null;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: currentValue,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(12),

            icon: _dropdownIcon(),

            hint: Align(
              alignment: fieldAlignment,

              child: NText(
                text: languagesController.tr("PROVINCE"),

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                color: const Color(0xFF9AA7B7),

                fontSize: 14,

                textAlign: fieldTextAlign,
              ),
            ),

            selectedItemBuilder: (context) {
              return provinces.map<Widget>((province) {
                final name = ((province?.provinceName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                );
              }).toList();
            },

            items: provinces.map<DropdownMenuItem<String>>((province) {
              final id = ((province?.id) ?? '').toString();

              final name = ((province?.provinceName) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,

                child: Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final province in provinces) {
                if (((province?.id) ?? '').toString() == value) {
                  picked = province;

                  break;
                }
              }

              signUpController.provinceId.value = value;

              selectedProvince = ((picked?.provinceName) ?? '').toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  /// ============================================================

  /// DISTRICT DROPDOWN

  /// ============================================================

  Widget _districtDropdown(double screenHeight) {
    return _dropdownWrapper(
      child: Obx(() {
        final districts =
            districtController.alldistrictList.value.data?.districts ??
            <dynamic>[];

        final String? selectedDistrictId =
            signUpController.districtID.value.isEmpty
            ? null
            : signUpController.districtID.value;

        final bool selectedExists =
            selectedDistrictId != null &&
            districts.any(
              (district) =>
                  ((district?.id) ?? '').toString() == selectedDistrictId,
            );

        final String? currentValue = selectedExists ? selectedDistrictId : null;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: currentValue,

            dropdownColor: Colors.white,

            borderRadius: BorderRadius.circular(12),

            icon: _dropdownIcon(),

            hint: Align(
              alignment: fieldAlignment,

              child: NText(
                text: languagesController.tr("DISTRICT"),

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                color: const Color(0xFF9AA7B7),

                fontSize: 14,

                textAlign: fieldTextAlign,
              ),
            ),

            selectedItemBuilder: (context) {
              return districts.map<Widget>((district) {
                final name = ((district?.districtName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                );
              }).toList();
            },

            items: districts.map<DropdownMenuItem<String>>((district) {
              final id = ((district?.id) ?? '').toString();

              final name = ((district?.districtName) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,

                child: Align(
                  alignment: fieldAlignment,

                  child: NText(
                    text: name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    color: const Color(0xFF26384F),

                    fontSize: 14,

                    fontWeight: FontWeight.w500,

                    textAlign: fieldTextAlign,
                  ),
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              dynamic picked;

              for (final district in districts) {
                if (((district?.id) ?? '').toString() == value) {
                  picked = district;

                  break;
                }
              }

              signUpController.districtID.value = value;

              selectedDistrict = ((picked?.districtName) ?? '').toString();

              setState(() {});
            },
          ),
        );
      }),
    );
  }

  /// ============================================================

  /// ============================================================
  /// UPLOAD BOX
  /// ============================================================
  Widget _uploadBox({
    required bool hasImage,
    required String imagePath,
    required String emptyText,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.primaryColor.withOpacity(0.30),
        strokeWidth: 1.4,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
        child: Container(
          width: double.infinity,
          height: 118,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: hasImage
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NText(
                        text: emptyText,
                        textAlign: TextAlign.center,
                        color: const Color(0xFF718096),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// SOCIAL FOOTER

  /// ============================================================

  Widget _socialSection(double screenWidth) {
    return SizedBox(
      height: 58,

      width: screenWidth,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          _supportButton(
            onTap: whatsapp,

            child: const FaIcon(
              FontAwesomeIcons.whatsapp,

              color: Color(0xff25D366),

              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          _supportButton(
            onTap: () {
              showSocialPopup(context);
            },

            child: Image.asset(
              "assets/icons/social-media.png",

              height: 25,

              width: 25,
            ),
          ),

          const SizedBox(width: 16),

          _supportButton(
            onTap: () {
              _makePhoneCall(phoneNumber);
            },

            child: const FaIcon(
              FontAwesomeIcons.phone,

              color: AppColors.primaryColor,

              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 50,
          width: 50,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE4EAF2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF183A64).withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  /// WHATSAPP

  /// ============================================================

  Future<void> whatsapp() async {
    const contact = "+93708488200";

    final androidUrl =
        "whatsapp://send?phone=$contact&text=Hi, I need some help";

    final iosUrl =
        "https://wa.me/$contact?text=${Uri.encodeComponent('Hi, I need some help')}";

    try {
      final Uri url = Uri.parse(Platform.isIOS ? iosUrl : androidUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("WhatsApp Error: $e");
    }
  }
}

/// ============================================================

/// PHONE CALL

/// ============================================================

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
