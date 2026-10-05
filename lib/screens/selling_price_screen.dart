import 'package:mashhorbazar/controllers/categories_controller.dart';

import 'package:mashhorbazar/controllers/delete_selling_price_controller.dart';

import 'package:mashhorbazar/controllers/only_service_controller.dart';

import 'package:mashhorbazar/controllers/selling_price_controller.dart';

import 'package:mashhorbazar/controllers/update_selling_price_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/service_category_model.dart';

import 'package:mashhorbazar/screens/create_selling_price_screen.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class SellingPriceScreen extends StatefulWidget {
  const SellingPriceScreen({super.key});

  @override
  State<SellingPriceScreen> createState() => _SellingPriceScreenState();
}

class _SellingPriceScreenState extends State<SellingPriceScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );

  final UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
  );

  final CategorisListController categorisListController =
      Get.find<CategorisListController>();

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Map<String, String>> commissionType;

  @override
  void initState() {
    super.initState();

    commissionType = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},

      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.mashhorbazarBackground,

        statusBarIconBrightness: Brightness.dark,

        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: AppColors.mashhorbazarBackground,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    categorisListController.fetchcategories();

    sellingPriceController.fetchpriceData();

    serviceController.fetchservices();
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
            _buildControlBar(),
            const SizedBox(height: 10),
            Expanded(child: _buildPricingList()),
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
            right: -45,
            top: -58,
            child: Container(
              height: 140,
              width: 140,
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
                      text: languagesController.tr("SELLING_PRICE"),
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    NText(
                      text: languagesController.tr("COMMISSION_TYPE"),
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

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF153C68).withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFE2E9F1)),
                ),
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  style: const TextStyle(
                    color: Color(0xFF263B54),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 19,
                    ),
                    hintText: languagesController.tr("SEARCH"),
                    hintStyle: TextStyle(
                      color: AppColors.fontColor.withOpacity(0.72),
                      fontSize: 12.5,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    mypagecontroller.changePage(
                      CreateSellingPriceScreen(),
                      isMainPage: false,
                    );
                  },
                  borderRadius: BorderRadius.circular(13),
                  child: Ink(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: NText(
                            text: languagesController.tr("CREATE_NEW"),
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        final loading =
            sellingPriceController.isLoading.value ||
            serviceController.isLoading.value;

        if (loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final pricingList =
            sellingPriceController.allpricelist.value.data?.pricings ?? [];

        if (pricingList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            sellingPriceController.fetchpriceData();
            serviceController.fetchservices();
            categorisListController.fetchcategories();

            await Future<void>.delayed(const Duration(milliseconds: 450));
          },
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 110),
            itemCount: pricingList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 7);
            },
            itemBuilder: (context, index) {
              return _buildPricingCard(pricingList[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildPricingCard(dynamic data) {
    final service = _findServiceById(data.serviceId?.toString() ?? "");

    final companyName = service?.company?.companyName?.toString() ?? "";

    final companyLogo = service?.company?.companyLogo?.toString() ?? "";

    final categoryName = _findCategoryName(
      data.service?.serviceCategoryId?.toString() ?? "",
    );

    final commissionText = data.commissionType?.toString() == "percentage"
        ? languagesController.tr("PERCENTAGE")
        : languagesController.tr("FIXED");

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 8, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.035),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: companyLogo.isNotEmpty && companyLogo != "null"
                ? Image.network(
                    companyLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.business_rounded,
                        color: AppColors.primaryColor,
                        size: 22,
                      );
                    },
                  )
                : const Icon(
                    Icons.business_rounded,
                    color: AppColors.primaryColor,
                    size: 22,
                  ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: NText(
                        text: companyName,
                        color: const Color(0xFF172D49),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (categoryName.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: NText(
                          text: categoryName,
                          color: AppColors.primaryColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                _infoRow(
                  languagesController.tr("COMMISSION_TYPE"),
                  commissionText,
                ),
                const SizedBox(height: 3),
                _infoRow(
                  languagesController.tr("AMOUNT"),
                  data.amount?.toString() ?? "",
                  valueColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              _actionButton(
                icon: Icons.edit_rounded,
                background: AppColors.secondaryColor,
                iconColor: AppColors.primaryColor,
                onTap: () {
                  updateSellingPriceController.amountController.text =
                      data.amount?.toString() ?? "";

                  _showUpdateDialog(data);
                },
              ),
              const SizedBox(height: 6),
              _actionButton(
                icon: Icons.delete_outline_rounded,
                background: const Color(0xFFFFF0F2),
                iconColor: const Color(0xFFE05263),
                onTap: () {
                  _showDeleteDialog(data.id?.toString() ?? "");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: NText(
            text: label,

            color: AppColors.fontColor,

            fontSize: 10.5,

            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: NText(
            text: value,

            color: valueColor ?? AppColors.primaryColor,

            fontSize: 10.8,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.end,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,

    required Color background,

    required Color iconColor,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 35,

        width: 35,

        decoration: BoxDecoration(
          color: background,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: AppColors.primaryColor,

      onRefresh: () async {
        sellingPriceController.fetchpriceData();

        serviceController.fetchservices();

        await Future<void>.delayed(const Duration(milliseconds: 450));
      },

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          const SizedBox(height: 110),

          Container(
            height: 70,

            width: 70,

            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.sell_outlined,

              color: AppColors.primaryColor,

              size: 31,
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: NText(
              text: languagesController.tr("NO_DATA_FOUND"),

              color: AppColors.fontColor,

              fontSize: 13,

              fontWeight: FontWeight.w600,

              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  dynamic _findServiceById(String serviceId) {
    try {
      return serviceController.allservices.value.data?.services.firstWhere(
        (service) => service.id.toString() == serviceId,
      );
    } catch (_) {
      return null;
    }
  }

  String _findCategoryName(String categoryId) {
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

  void _showUpdateDialog(dynamic data) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 20),

          child: Container(
            constraints: const BoxConstraints(maxHeight: 560),

            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(22),
            ),

            child: ListView(
              shrinkWrap: true,

              physics: const BouncingScrollPhysics(),

              children: [
                Row(
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
                        Icons.edit_rounded,

                        color: Colors.white,

                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: NText(
                        text: languagesController.tr("SELLING_PRICE"),

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

                const SizedBox(height: 18),

                NText(
                  text: languagesController.tr("AMOUNT"),

                  color: AppColors.primaryColor,

                  fontSize: 12,

                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 7),

                Authtextfield(
                  hinttext: languagesController.tr("ENTER_AMOUNT"),

                  controller: updateSellingPriceController.amountController,
                ),

                const SizedBox(height: 12),

                NText(
                  text: languagesController.tr("COMMISSION_TYPE"),

                  color: AppColors.primaryColor,

                  fontSize: 12,

                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 7),

                GestureDetector(
                  onTap: () {
                    _showCommissionTypeDialog();
                  },

                  child: Container(
                    height: 50,

                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.035),

                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.08),
                      ),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => NText(
                              text: updateSellingPriceController.commitype.value
                                  .toString(),

                              color: AppColors.primaryColor,

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

                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                NText(
                  text: languagesController.tr("SERVICE"),

                  color: AppColors.primaryColor,

                  fontSize: 12,

                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final hasService = updateSellingPriceController
                            .catName
                            .value
                            .isNotEmpty;

                        return Container(
                          constraints: const BoxConstraints(minHeight: 100),

                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.035),

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.07),
                            ),
                          ),

                          child: hasService
                              ? Row(
                                  children: [
                                    Container(
                                      height: 52,

                                      width: 52,

                                      padding: const EdgeInsets.all(6),

                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: Image.network(
                                        updateSellingPriceController.logolink
                                            .toString(),

                                        fit: BoxFit.contain,

                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.business_rounded,

                                                color: AppColors.primaryColor,
                                              );
                                            },
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          NText(
                                            text: updateSellingPriceController
                                                .serviceName
                                                .toString(),

                                            color: AppColors.primaryColor,

                                            fontSize: 12.5,

                                            fontWeight: FontWeight.w700,

                                            maxLines: 1,

                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          const SizedBox(height: 4),

                                          NText(
                                            text: updateSellingPriceController
                                                .catName
                                                .toString(),

                                            color: AppColors.fontColor,

                                            fontSize: 10.5,

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
                                  child: NText(
                                    text: languagesController.tr("SERVICE"),

                                    color: AppColors.fontColor,

                                    fontSize: 12,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      }),
                    ),

                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,

                          builder: (context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.symmetric(
                                horizontal: 18,

                                vertical: 40,
                              ),

                              backgroundColor: Colors.transparent,

                              child: UpdateServiceBox(),
                            );
                          },
                        );
                      },

                      child: Container(
                        height: 48,

                        width: 48,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primarycolor2,

                              AppColors.primaryColor,
                            ],
                          ),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,

                          color: Colors.white,

                          size: 23,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (updateSellingPriceController
                              .amountController
                              .text
                              .isNotEmpty &&
                          updateSellingPriceController
                              .commissiontype
                              .value
                              .isNotEmpty &&
                          updateSellingPriceController
                              .serviceidcontroller
                              .text
                              .isNotEmpty) {
                        updateSellingPriceController.updatenow(
                          data.id.toString(),
                        );
                      } else {
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
                    },

                    child: Container(
                      height: 50,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primarycolor2,

                            AppColors.primaryColor,
                          ],
                        ),

                        borderRadius: BorderRadius.circular(14),
                      ),

                      alignment: Alignment.center,

                      child: NText(
                        text: updateSellingPriceController.isLoading.value
                            ? languagesController.tr("PLEASE_WAIT")
                            : languagesController.tr("UPDATE_NOW"),

                        color: Colors.white,

                        fontSize: 13.5,

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
                    updateSellingPriceController.commitype.value =
                        item["name"] ?? "";

                    updateSellingPriceController.commissiontype.value =
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

  void _showDeleteDialog(String priceId) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,

          contentPadding: EdgeInsets.zero,

          insetPadding: const EdgeInsets.symmetric(horizontal: 24),

          content: DeleteDialog(priceID: priceId),
        );
      },
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, required this.priceID});

  final String priceID;

  final DeleteSellingPriceController controller = Get.put(
    DeleteSellingPriceController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            height: 64,

            width: 64,

            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.delete_outline_rounded,

              color: Colors.redAccent,

              size: 30,
            ),
          ),

          const SizedBox(height: 14),

          NText(
            text: languagesController.tr("DO_YOU_WANT_TO_DELETE"),

            color: AppColors.primaryColor,

            fontSize: 15,

            fontWeight: FontWeight.w700,

            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 3,

                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.deleteprice(priceID);

                      Navigator.pop(context);
                    },

                    child: Container(
                      height: 46,

                      decoration: BoxDecoration(
                        color: Colors.redAccent,

                        borderRadius: BorderRadius.circular(13),
                      ),

                      alignment: Alignment.center,

                      child: NText(
                        text: controller.isLoading.value
                            ? languagesController.tr("PLEASE_WAIT")
                            : languagesController.tr("YES"),

                        color: Colors.white,

                        fontSize: 13,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 2,

                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    height: 46,

                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.055),

                      borderRadius: BorderRadius.circular(13),
                    ),

                    alignment: Alignment.center,

                    child: NText(
                      text: languagesController.tr("NO"),

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
    );
  }
}

class UpdateServiceBox extends StatelessWidget {
  UpdateServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final CategorisListController categorisListController =
      Get.find<CategorisListController>();

  final UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

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
                      updateSellingPriceController.serviceidcontroller.text =
                          data.id.toString();

                      updateSellingPriceController.catName.value = categoryName;

                      updateSellingPriceController.logolink.value =
                          data.company?.companyLogo?.toString() ?? "";

                      updateSellingPriceController.serviceName.value =
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
