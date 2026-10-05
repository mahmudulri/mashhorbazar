import 'package:mashhorbazar/controllers/bundle_controller.dart';

import 'package:mashhorbazar/controllers/confirm_pin_controller.dart';

import 'package:mashhorbazar/controllers/service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/helpers/price.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:lottie/lottie.dart';

class SocialBundles extends StatefulWidget {
  const SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final ServiceController serviceController = Get.find<ServiceController>();

  final BundleController bundleController = Get.find<BundleController>();

  final ConfirmPinController confirmPinController =
      Get.find<ConfirmPinController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final ScrollController scrollController = ScrollController();

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

    confirmPinController.numberController.clear();

    bundleController.finalList.clear();

    bundleController.initialpage = 1;

    scrollController.addListener(_loadMoreBundles);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();

      bundleController.fetchallbundles();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreBundles);

    scrollController.dispose();

    super.dispose();
  }

  Future<void> _loadMoreBundles() async {
    if (!scrollController.hasClients || bundleController.isLoading.value) {
      return;
    }

    final reachedBottom =
        scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80;

    if (!reachedBottom) {
      return;
    }

    final totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;

    if (totalPages <= 0 || bundleController.initialpage >= totalPages) {
      return;
    }

    bundleController.initialpage++;

    await bundleController.fetchallbundles();
  }

  Future<void> _pullRefresh() async {
    bundleController.finalList.clear();

    bundleController.initialpage = 1;

    await bundleController.fetchallbundles();
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
            const SizedBox(height: 8),
            Expanded(child: _buildBundleList()),
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
        borderRadius: BorderRadius.circular(25),
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
            onTap: () {
              mypagecontroller.goBack();
            },
            icon: Icons.arrow_back_rounded,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                NText(
                  text: languagesController.tr("COMMUNICATION_PACKAGES"),
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("COMMUNICATION_PACKAGES"),
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),

        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.045),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: AppColors.primaryColor.withOpacity(0.08)),
        ),

        child: Row(
          children: [
            Container(
              height: 42,

              width: 42,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primarycolor2,

                    AppColors.mashhorbazarTurquoise,
                  ],
                ),

                borderRadius: BorderRadius.circular(13),
              ),

              child: const Icon(
                Icons.forum_outlined,

                color: Colors.white,

                size: 21,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: NText(
                text: languagesController.tr("COMMUNICATION_PACKAGES"),

                color: AppColors.primaryColor,

                fontSize: 14,

                fontWeight: FontWeight.w700,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,
              ),
            ),

            GestureDetector(
              onTap: _pullRefresh,

              child: Container(
                height: 34,

                width: 34,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: AppColors.mashhorbazarTurquoise.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.refresh_rounded,

                  color: AppColors.primaryColor,

                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBundleList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        final bundles = bundleController.finalList;
        final isLoading = bundleController.isLoading.value;

        if (isLoading && bundles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (bundles.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _pullRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 70),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
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
                          Icons.forum_outlined,
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
          onRefresh: _pullRefresh,
          child: ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: bundles.length + (isLoading ? 1 : 0),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 6);
            },
            itemBuilder: (context, index) {
              if (index >= bundles.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                );
              }

              return _buildBundleCard(bundles[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBundleCard(dynamic data) {
    final companyName = data.service?.company?.companyName?.toString() ?? "";

    final logo = data.service?.company?.companyLogo?.toString() ?? "";

    final title = data.bundleTitle?.toString() ?? "";

    final buyingPrice = data.buyingPrice?.toString() ?? "";

    final sellingPrice = data.sellingPrice?.toString() ?? "";

    final currency = box.read("currency_code")?.toString() ?? "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          box.write("bundleID", data.id.toString());

          _showBundleDialog(
            companyName: companyName,
            title: title,
            validity: data.validityType?.toString() ?? "",
            buyingPrice: buyingPrice,
            sellingPrice: sellingPrice,
            imageLink: logo,
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE9EEF5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF153C68).withOpacity(0.035),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: CachedNetworkImage(
                  imageUrl: logo,
                  fit: BoxFit.contain,
                  placeholder: (_, __) {
                    return const Center(
                      child: SizedBox(
                        height: 13,
                        width: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                  errorWidget: (_, __, ___) {
                    return const Icon(
                      Icons.business_outlined,
                      color: AppColors.primaryColor,
                      size: 19,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NText(
                      text: title,
                      color: const Color(0xFF172D49),
                      fontSize: 10.8,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (companyName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      NText(
                        text: companyName,
                        color: AppColors.fontColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    _inlinePrice(
                      label: languagesController.tr("SALE"),
                      price: sellingPrice,
                      currency: currency,
                      color: const Color(0xFF19A766),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 72),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    NText(
                      text: languagesController.tr("BUY"),
                      color: const Color(0xFFE05263),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: PriceTextView(
                            price: buyingPrice,
                            textStyle: const TextStyle(
                              color: Color(0xFFE05263),
                              fontSize: 10.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        NText(
                          text: currency,
                          color: const Color(0xFFE05263),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inlinePrice({
    required String label,
    required String price,
    required String currency,
    required Color color,
  }) {
    return Row(
      children: [
        NText(
          text: label,
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(width: 3),
        PriceTextView(
          price: price,
          textStyle: TextStyle(
            color: color,
            fontSize: 10.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 2),
        NText(
          text: currency,
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  void _showBundleDialog({
    required String companyName,

    required String title,

    required String validity,

    required String buyingPrice,

    required String sellingPrice,

    required String imageLink,
  }) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,

            vertical: 28,
          ),

          child: SocialdialogBox(
            companyname: companyName,

            title: title,

            validity: validity,

            buyingprice: buyingPrice,

            sellingprice: sellingPrice,

            imagelink: imageLink,
          ),
        );
      },
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  const SocialdialogBox({
    super.key,

    this.title,

    this.validity,

    this.buyingprice,

    this.sellingprice,

    this.imagelink,

    this.companyname,
  });

  final String? companyname;

  final String? title;

  final String? validity;

  final String? buyingprice;

  final String? sellingprice;

  final String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  final ConfirmPinController confirmPinController =
      Get.find<ConfirmPinController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 650),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(
        () => confirmPinController.isLoading.value
            ? Center(
                child: SizedBox(
                  height: 220,
                  width: 220,
                  child: Lottie.asset("assets/loties/recharge.json"),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildDialogHeader(context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      child: Column(
                        children: [
                          _buildBundleInfo(),
                          const SizedBox(height: 12),
                          _buildIdField(),
                          const SizedBox(height: 12),
                          _buildPinField(),
                          const SizedBox(height: 18),
                          _buildActions(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    final logo = widget.imagelink?.toString() ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 13, 17),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: logo,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) {
                return const Icon(
                  Icons.business_outlined,
                  color: AppColors.primaryColor,
                  size: 24,
                );
              },
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NText(
                  text: widget.companyname?.toString() ?? "",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                NText(
                  text: widget.title?.toString() ?? "",
                  color: Colors.white.withOpacity(0.72),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((widget.validity ?? "").isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: NText(
                      text: _validityText(widget.validity),
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 34,
              width: 34,
              alignment: Alignment.center,
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
    );
  }

  Widget _buildBundleInfo() {
    final currency = box.read("currency_code")?.toString() ?? "";

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.035),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          _dialogPriceRow(
            icon: Icons.shopping_bag_outlined,

            label: languagesController.tr("BUY"),

            price: widget.buyingprice?.toString() ?? "",

            currency: currency,

            accent: const Color(0xFFE05263),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),

            child: Divider(height: 1, color: Color(0xFFE8EEF3)),
          ),

          _dialogPriceRow(
            icon: Icons.sell_outlined,

            label: languagesController.tr("SALE"),

            price: widget.sellingprice?.toString() ?? "",

            currency: currency,

            accent: const Color(0xFF23B26D),
          ),
        ],
      ),
    );
  }

  Widget _dialogPriceRow({
    required IconData icon,

    required String label,

    required String price,

    required String currency,

    required Color accent,
  }) {
    return Row(
      children: [
        Container(
          height: 32,

          width: 32,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: accent.withOpacity(0.08),

            borderRadius: BorderRadius.circular(9),
          ),

          child: Icon(icon, color: accent, size: 17),
        ),

        const SizedBox(width: 9),

        NText(
          text: label,

          color: AppColors.fontColor,

          fontSize: 11.5,

          fontWeight: FontWeight.w600,
        ),

        const Spacer(),

        PriceTextView(
          price: price,

          textStyle: TextStyle(
            color: accent,

            fontSize: 14,

            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(width: 4),

        NText(
          text: currency,

          color: accent,

          fontSize: 10.5,

          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildIdField() {
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
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: confirmPinController.numberController,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF172D49),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: languagesController.tr("ENTER_ID"),
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

  Widget _buildPinField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              maxLength: 4,
              controller: confirmPinController.pinController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              obscureText: true,
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF172D49),
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: languagesController.tr("PIN"),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.65),
                  fontSize: 12,
                  letterSpacing: 0,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,

          child: GestureDetector(
            onTap: () {
              if (confirmPinController.numberController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: languagesController.tr("ENTER_ID"),

                  toastLength: Toast.LENGTH_SHORT,

                  gravity: ToastGravity.TOP,

                  timeInSecForIosWeb: 1,

                  backgroundColor: Colors.black,

                  textColor: Colors.white,

                  fontSize: 16,
                );

                return;
              }

              if (confirmPinController.pinController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: languagesController.tr("ENTER_YOUR_PIN"),

                  toastLength: Toast.LENGTH_SHORT,

                  gravity: ToastGravity.TOP,

                  timeInSecForIosWeb: 1,

                  backgroundColor: Colors.black,

                  textColor: Colors.white,

                  fontSize: 16,
                );

                return;
              }

              confirmPinController.placeOrder(context);
            },

            child: Container(
              height: 48,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primarycolor2,

                    AppColors.mashhorbazarTurquoise,
                  ],
                ),

                borderRadius: BorderRadius.circular(13),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.mashhorbazarTurquoise.withOpacity(0.16),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Icon(
                    Icons.check_circle_rounded,

                    color: Colors.white,

                    size: 19,
                  ),

                  const SizedBox(width: 7),

                  Flexible(
                    child: NText(
                      text: languagesController.tr("CONFIRMATION"),

                      color: Colors.white,

                      fontSize: 12.5,

                      fontWeight: FontWeight.w700,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          flex: 2,

          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              height: 48,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.055),

                borderRadius: BorderRadius.circular(13),
              ),

              child: NText(
                text: languagesController.tr("CANCEL"),

                color: AppColors.primaryColor,

                fontSize: 12.5,

                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _validityText(String? value) {
    switch (value?.toLowerCase()) {
      case "unlimited":
        return languagesController.tr("UNLIMITED");

      case "monthly":
        return languagesController.tr("MONTHLY");

      case "weekly":
        return languagesController.tr("WEEKLY");

      case "daily":
        return languagesController.tr("DAILY");

      case "hourly":
        return languagesController.tr("HOURLY");

      case "nightly":
        return languagesController.tr("NIGHTLY");

      default:
        return value ?? "";
    }
  }
}
