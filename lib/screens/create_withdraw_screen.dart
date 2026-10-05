import 'package:mashhorbazar/controllers/create_withdraw_controller.dart';

import 'package:mashhorbazar/global_controller/languages_controller.dart';

import 'package:mashhorbazar/global_controller/page_controller.dart';

import 'package:mashhorbazar/utils/colors.dart';

import 'package:mashhorbazar/widgets/authtextfield.dart';

import 'package:mashhorbazar/widgets/custom_text.dart';

import 'package:mashhorbazar/widgets/drawer.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CreateWithdrawScreen extends StatelessWidget {
  CreateWithdrawScreen({super.key});

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CreateWithdrawController createWithdrawController = Get.put(
    CreateWithdrawController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                children: [
                  _buildWithdrawDetailsSection(),
                  const SizedBox(height: 12),
                  _buildBankDetailsSection(),
                  const SizedBox(height: 18),
                  _buildSubmitButton(),
                ],
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
                  text: languagesController.tr("CREATE_NEW_WITHDRAW"),
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                NText(
                  text: languagesController.tr("BANK_DETAILS"),
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

  Widget _buildWithdrawDetailsSection() {
    return _sectionCard(
      icon: Icons.account_balance_wallet_outlined,

      title: languagesController.tr("CREATE_NEW_WITHDRAW"),

      children: [
        _fieldLabel(languagesController.tr("AMOUNT")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.amountController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("ACCOUNT_NAME")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.accountNameController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("ACCOUNT_NUMBER")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.accountNumberController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("BANK_NAME")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.bankNameController,

          hinttext: "",
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
          controller: createWithdrawController.notesController,

          hinttext: "",
        ),
      ],
    );
  }

  Widget _buildBankDetailsSection() {
    return _sectionCard(
      icon: Icons.account_balance_rounded,

      title: languagesController.tr("BANK_DETAILS"),

      children: [
        _fieldLabel(languagesController.tr("BANK_NAME")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.bankDetailNameController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("ACCOUNT_HOLDER_NAME")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.bankHolderNameController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("ACCOUNT_NUMBER")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.bankAccountNumberController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("IBAN")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.ibanController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("BRANCH")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.branchController,

          hinttext: "",
        ),

        const SizedBox(height: 14),

        _fieldLabel(languagesController.tr("SWIFT_CODE")),

        const SizedBox(height: 7),

        Authtextfield(
          controller: createWithdrawController.swiftCodeController,

          hinttext: "",
        ),
      ],
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153C68).withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NText(
                  text: title,
                  color: const Color(0xFF172D49),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          ...children,
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

  Widget _buildSubmitButton() {
    return Obx(
      () => GestureDetector(
        onTap: createWithdrawController.isLoading.value
            ? null
            : () {
                createWithdrawController.createBankWithdraw();
              },
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: createWithdrawController.isLoading.value
                ? AppColors.primaryColor.withOpacity(0.45)
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: createWithdrawController.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: createWithdrawController.isLoading.value
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
                      Icons.add_card_rounded,
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
}
