// lib/features/payment/screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/payment_provider.dart';
import '../widgets/combo_item.dart';
import '../widgets/payment_movie_header.dart';
import '../widgets/payment_row_info.dart';
import '../widgets/payment_discount_code_box.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/payment_bottom_action.dart';
import '../../../data/models/booking_selection.dart';

class PaymentScreen extends StatefulWidget {
  final BookingSelection selection;
  const PaymentScreen({super.key, required this.selection});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().initPayment(widget.selection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Payment", style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: provider.isLoading && provider.availableCombos.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentMovieHeader(
                    selection: widget.selection,
                    showTimeDate: provider.showTimeDate,
                  ),
                  const SizedBox(height: 16),
                  PaymentRowInfo(
                    label: "Order ID",
                    value: provider.confirmedOrderId?.toString() ?? "Chờ thanh toán",
                  ),
                  const SizedBox(height: 12),
                  PaymentRowInfo(
                    label: "Seat",
                    value: widget.selection.selectedSeatLabels.join(', '),
                  ),
                  const SizedBox(height: 20),
                  const PaymentDiscountCodeBox(),
                  const SizedBox(height: 24),
                  Text("Chọn combo ưu đãi", style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  ...List.generate(
                    provider.availableCombos.length,
                    (index) => ComboItem(
                      combo: provider.availableCombos[index],
                      onAdd: () => provider.updateComboQuantity(index, true),
                      onRemove: () => provider.updateComboQuantity(index, false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: AppTextStyles.bodyLarge),
                      Text(
                        "${provider.totalPrice.toInt()} VND",
                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text("Payment Method", style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  PaymentMethodTile(provider: provider, title: "Zalo Pay", methodCode: "ZALOPAY", logoPath: "assets/zalopay.png"),
                  PaymentMethodTile(provider: provider, title: "MoMo", methodCode: "MOMO", logoPath: "assets/momo.png"),
                  PaymentMethodTile(provider: provider, title: "ATM Card (Mock)", methodCode: "MOCK", logoPath: "assets/atm.png"),
                ],
              ),
            ),
      bottomSheet: PaymentBottomAction(provider: provider),
    );
  }
}