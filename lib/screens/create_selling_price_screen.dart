import 'package:mashhorbazar/controllers/add_selling_price_controller.dart';

import 'package:mashhorbazar/controllers/categories_controller.dart';

import 'package:mashhorbazar/controllers/only_service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/service_category_model.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CategorisListController categorisListController =
      Get.find<CategorisListController>();

  final AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Map<String, String>> commissionType;

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

    commissionType = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},

      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];

    if (serviceController.allservices.value.data?.services.isEmpty ?? true) {
      serviceController.fetchservices();
    }

    if (categorisListController
            .allcategorieslist
            .value
            .data
            ?.servicecategories
            ?.isEmpty ??
        true) {
      categorisListController.fetchcategories();
    }
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
                  text: languagesController.tr("CREATE_SELLING_PRICE"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("SERVICE"),
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
                  Icons.sell_outlined,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: languagesController.tr("CREATE_SELLING_PRICE"),
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _fieldLabel(languagesController.tr("AMOUNT")),
          const SizedBox(height: 7),
          Authtextfield(
            hinttext: languagesController.tr("ENTER_AMOUNT"),
            controller: addSellingPriceController.amountController,
          ),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("COMMISSION_TYPE")),
          const SizedBox(height: 7),
          _buildCommissionSelector(),
          const SizedBox(height: 14),
          _fieldLabel(languagesController.tr("SERVICE")),
          const SizedBox(height: 7),
          _buildServiceSelector(),
          const SizedBox(height: 20),
          _buildCreateButton(),
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
                final value = addSellingPriceController.commitype.value
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

  Widget _buildServiceSelector() {
    return Obx(() {
      final hasService = addSellingPriceController.catName.value.isNotEmpty;

      return Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 96),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE2E9F1)),
              ),
              child: hasService
                  ? Row(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Image.network(
                            addSellingPriceController.logolink.toString(),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.business_rounded,
                                color: AppColors.primaryColor,
                                size: 23,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NText(
                                text: addSellingPriceController.serviceName
                                    .toString(),
                                color: const Color(0xFF172D49),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              NText(
                                text: addSellingPriceController.catName
                                    .toString(),
                                color: AppColors.fontColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.apps_rounded,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 7),
                          NText(
                            text: languagesController.tr("SERVICE"),
                            color: AppColors.fontColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 9),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showServiceDialog,
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCreateButton() {
    return Obx(
      () => GestureDetector(
        onTap: addSellingPriceController.isLoading.value
            ? null
            : _createSellingPrice,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: addSellingPriceController.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: addSellingPriceController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: addSellingPriceController.isLoading.value
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
                      text: languagesController.tr("CREATE_NOW"),
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

  void _createSellingPrice() {
    final hasAmount =
        addSellingPriceController.amountController.text.isNotEmpty;

    final hasCommissionType =
        addSellingPriceController.commissiontype.value.isNotEmpty;

    final hasService =
        addSellingPriceController.serviceidcontroller.text.isNotEmpty;

    if (hasAmount && hasCommissionType && hasService) {
      addSellingPriceController.createnow();

      return;
    }

    Fluttertoast.showToast(
      msg: languagesController.tr("FILL_DATA_CORRECTLY"),

      toastLength: Toast.LENGTH_SHORT,

      gravity: ToastGravity.CENTER,

      timeInSecForIosWeb: 1,

      backgroundColor: Colors.red,

      textColor: Colors.white,

      fontSize: 16,
    );
  }

  void _showCommissionTypeDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 28),

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
                    addSellingPriceController.commitype.value =
                        item["name"] ?? "";

                    addSellingPriceController.commissiontype.value =
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

  void _showServiceDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,

            vertical: 40,
          ),

          backgroundColor: Colors.transparent,

          child: const ServiceBox(),
        );
      },
    );
  }
}

class ServiceBox extends StatelessWidget {
  const ServiceBox({super.key});

  OnlyServiceController get serviceController =>
      Get.find<OnlyServiceController>();

  CategorisListController get categorisListController =>
      Get.find<CategorisListController>();

  AddSellingPriceController get addSellingPriceController =>
      Get.find<AddSellingPriceController>();

  LanguagesController get languagesController =>
      Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 560),

      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
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
                    colors: [AppColors.primarycolor2, AppColors.primaryColor],
                  ),

                  borderRadius: BorderRadius.circular(11),
                ),

                child: const Icon(
                  Icons.apps_rounded,

                  color: Colors.white,

                  size: 19,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: NText(
                  text: languagesController.tr("SERVICE"),

                  color: AppColors.primaryColor,

                  fontSize: 16,

                  fontWeight: FontWeight.w700,
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
              if (serviceController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              final services =
                  serviceController.allservices.value.data?.services ?? [];

              if (services.isEmpty) {
                return Center(
                  child: NText(
                    text: languagesController.tr("NO_DATA_FOUND"),

                    color: AppColors.fontColor,

                    fontSize: 13,

                    fontWeight: FontWeight.w600,
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),

                itemCount: services.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,

                  crossAxisSpacing: 8,

                  mainAxisSpacing: 8,

                  childAspectRatio: 0.78,
                ),

                itemBuilder: (context, index) {
                  final data = services[index];

                  final categoryName = _categoryNameFor(
                    data.serviceCategoryId?.toString() ?? "",
                  );

                  return GestureDetector(
                    onTap: () {
                      addSellingPriceController.serviceidcontroller.text = data
                          .id
                          .toString();

                      addSellingPriceController.catName.value = categoryName;

                      addSellingPriceController.logolink.value =
                          data.company?.companyLogo?.toString() ?? "";

                      addSellingPriceController.serviceName.value =
                          data.company?.companyName?.toString() ?? "";

                      Navigator.pop(context);
                    },

                    child: Container(
                      padding: const EdgeInsets.all(9),

                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.035),

                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.06),
                        ),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            height: 48,

                            width: 48,

                            padding: const EdgeInsets.all(4),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Image.network(
                              data.company?.companyLogo?.toString() ?? "",

                              fit: BoxFit.contain,

                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.business_rounded,

                                  color: AppColors.primaryColor,

                                  size: 23,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          NText(
                            text: data.company?.companyName?.toString() ?? "",

                            color: AppColors.primaryColor,

                            fontSize: 10.5,

                            fontWeight: FontWeight.w700,

                            textAlign: TextAlign.center,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            height: 1.15,
                          ),

                          if (categoryName.isNotEmpty) ...[
                            const SizedBox(height: 4),

                            NText(
                              text: categoryName,

                              color: AppColors.fontColor,

                              fontSize: 9,

                              fontWeight: FontWeight.w500,

                              textAlign: TextAlign.center,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
    );
  }

  String _categoryNameFor(String categoryId) {
    try {
      final category = categorisListController
          .allcategorieslist
          .value
          .data
          ?.servicecategories
          ?.firstWhere(
            (cat) => cat.id.toString() == categoryId,

            orElse: () => Servicecategory(categoryName: ""),
          );

      return category?.categoryName?.toString() ?? "";
    } catch (_) {
      return "";
    }
  }
}
