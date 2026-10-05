import 'package:mashhorbazar/controllers/change_balance_controller.dart';

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

class ChangeBalance extends StatefulWidget {
  const ChangeBalance({super.key, this.subID});

  final String? subID;

  @override
  State<ChangeBalance> createState() => _ChangeBalanceState();
}

class _ChangeBalanceState extends State<ChangeBalance> {
  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final BalanceController balanceController = Get.put(BalanceController());

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedType = 1;

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

    balanceController.status.value = "credit";
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
                children: [_buildBalanceForm()],
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
                  text: languagesController.tr("CHANGE_BALANCE"),
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

  Widget _buildBalanceForm() {
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
          _buildFormHeading(),
          const SizedBox(height: 16),
          _buildTypeSelector(),
          const SizedBox(height: 16),
          _fieldLabel(languagesController.tr("AMOUNT")),
          const SizedBox(height: 7),
          _buildAmountRow(),
          const SizedBox(height: 20),
          _buildConfirmButton(),
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

  Widget _buildFormHeading() {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primaryColor,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NText(
                text: languagesController.tr("CHANGE_BALANCE"),
                color: const Color(0xFF172D49),
                fontSize: 14,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              NText(
                text: _selectedType == 1
                    ? languagesController.tr("CREDIT")
                    : languagesController.tr("DEBIT"),
                color: AppColors.fontColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2E9F1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _typeOption(
              value: 1,
              title: languagesController.tr("CREDIT"),
              icon: Icons.add_rounded,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _typeOption(
              value: 2,
              title: languagesController.tr("DEBIT"),
              icon: Icons.remove_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeOption({
    required int value,
    required String title,
    required IconData icon,
  }) {
    final selected = _selectedType == value;
    final isCredit = value == 1;
    final activeColor = isCredit
        ? const Color(0xFF19A766)
        : const Color(0xFFE05263);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = value;
          balanceController.status.value = value == 1 ? "credit" : "debit";
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : activeColor, size: 18),
            const SizedBox(width: 7),
            Flexible(
              child: NText(
                text: title,
                color: selected ? Colors.white : const Color(0xFF263B54),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Obx(
            () => Authtextfield(
              hinttext: languagesController.tr("ENTER_AMOUNT"),
              controller: balanceController.amountController,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFE2E9F1)),
            ),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Image.asset(
                    "assets/icons/afghanistan.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: NText(
                    text: box.read("currency_code")?.toString() ?? "",
                    color: AppColors.primaryColor,
                    fontSize: 11,
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
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Obx(
      () => GestureDetector(
        onTap: balanceController.isLoading.value ? null : _submitBalanceChange,
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: balanceController.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: balanceController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: balanceController.isLoading.value
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
                      text: languagesController.tr("CONFIRMATION"),
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

  void _submitBalanceChange() {
    if (balanceController.amountController.text.trim().isEmpty ||
        balanceController.status.value.isEmpty) {
      Fluttertoast.showToast(
        msg: languagesController.tr("ENTER_AMOUNT"),

        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,

        timeInSecForIosWeb: 1,

        backgroundColor: Colors.black,

        textColor: Colors.white,

        fontSize: 16,
      );

      return;
    }

    if (balanceController.status.value == "credit") {
      balanceController.credit(widget.subID.toString());
    } else {
      balanceController.debit(widget.subID.toString());
    }
  }
}

class PasswordBox extends StatelessWidget {
  const PasswordBox({super.key, this.hintText});

  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: AppColors.primaryColor.withOpacity(0.13)),

        color: Colors.white,
      ),

      child: TextField(
        obscureText: true,

        cursorColor: AppColors.primaryColor,

        decoration: InputDecoration(
          hintText: hintText,

          border: InputBorder.none,

          suffixIcon: const Icon(
            Icons.visibility_off_outlined,

            color: AppColors.fontColor,

            size: 20,
          ),
        ),
      ),
    );
  }
}
