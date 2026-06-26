import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/payment_provider.dart';
import '../../main/screens/main_screen.dart';
import 'qr_payment_dialog.dart';
import 'package:tet/core/l10n/app_localizations.dart';

class PaymentBottomAction extends StatelessWidget {
  final PaymentProvider provider;

  const PaymentBottomAction({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      int? paymentId = await provider.initiatePaymentFlow();
                      if (paymentId != null && context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => QRPaymentDialog(
                            provider: provider,
                            paymentId: paymentId,
                            amount: provider.totalPrice,
                          ),
                        );
                      } else if (context.mounted && provider.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.errorMessage!,
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : Text(
                      "${AppLocalizations.of(context)!.payment_pay_btn}  •  ${provider.totalPrice.toInt()} VND",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
