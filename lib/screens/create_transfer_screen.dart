import 'package:mashhorbazar/controllers/add_selling_price_controller.dart';

import 'package:mashhorbazar/controllers/categories_controller.dart';

import 'package:mashhorbazar/controllers/create_transfer_controller.dart';

import 'package:mashhorbazar/controllers/dashboard_controller.dart';

import 'package:mashhorbazar/controllers/only_service_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/models/service_category_model.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class CreateTransferScreen extends StatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final CreateTransferController controller = Get.put(
    CreateTransferController(),
  );

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

    controller.amountController.clear();
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
                children: [_buildTransferForm()],
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
                  text: languagesController.tr("CREATE_TRANSFER_REQUEST"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("AMOUNT"),
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

  Widget _buildTransferForm() {
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
                  text: languagesController.tr("CREATE_TRANSFER_REQUEST"),
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          NText(
            text: languagesController.tr("AMOUNT"),
            color: const Color(0xFF42556D),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 7),
          _buildAmountBox(),
          const SizedBox(height: 10),
          _buildAvailableCommissionCard(),
          const SizedBox(height: 20),
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildAmountBox() {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
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
              Icons.payments_outlined,
              color: AppColors.primaryColor,
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              cursorColor: AppColors.primaryColor,
              style: const TextStyle(
                color: Color(0xFF263B54),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: languagesController.tr("AMOUNT"),
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(0.72),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCommissionCard() {
    final totalEarning =
        dashboardController.alldashboardData.value.data?.userInfo?.totalearning
            ?.toString() ??
        "0";

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
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: NText(
              text: totalEarning,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.amountController.text = totalEarning;
              controller
                  .amountController
                  .selection = TextSelection.fromPosition(
                TextPosition(offset: controller.amountController.text.length),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: NText(
                text: languagesController.tr("ALL"),
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value ? null : _submitTransfer,
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: controller.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: controller.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: controller.isLoading.value
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
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 17,
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

  void _submitTransfer() {
    if (controller.amountController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("FILL_DATA_CORRECTLY"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.CENTER,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.red,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    controller.createnow();
  }
}

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final CategorisListController categorisListController =
      Get.find<CategorisListController>();

  final AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 560),

      margin: const EdgeInsets.all(20),

      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,

                width: 40,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primarycolor2, AppColors.primaryColor],
                  ),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.apps_rounded,

                  color: Colors.white,

                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: NText(
                  text: "Services",

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
                    text: "No data found",

                    color: AppColors.fontColor,

                    fontSize: 13,

                    fontWeight: FontWeight.w600,
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,

                  crossAxisSpacing: 7,

                  mainAxisSpacing: 8,

                  childAspectRatio: 0.76,
                ),

                itemCount: services.length,

                itemBuilder: (context, index) {
                  final data = services[index];

                  final categoryName = _categoryNameFor(
                    data.serviceCategoryId.toString(),
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
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.06),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.035),

                            blurRadius: 9,

                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            height: 50,

                            width: 50,

                            decoration: BoxDecoration(
                              color: AppColors.mashhorbazarBackground,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            clipBehavior: Clip.antiAlias,

                            child: Image.network(
                              data.company?.companyLogo?.toString() ?? "",

                              fit: BoxFit.contain,

                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,

                                  color: AppColors.primaryColor,

                                  size: 21,
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
                          ),

                          const SizedBox(height: 3),

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
