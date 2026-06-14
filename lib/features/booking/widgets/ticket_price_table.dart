import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/showtime.dart';

class TicketPriceTable extends StatelessWidget {
  final Showtime showtime;
  final NumberFormat currencyFormatter;

  const TicketPriceTable({
    super.key,
    required this.showtime,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: AppColors.background.withValues(alpha: 0.15),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableRow(
            seatWidget: _buildMockSeatUI(width: 34, color: AppColors.surface),
            typeName: "Ghế thường",
            priceText: "${currencyFormatter.format(showtime.basePrice)} VND",
          ),
          _buildTableRow(
            seatWidget: _buildMockSeatUI(
              width: 34, 
              color: const Color(0xFF3A301E), 
              borderCol: Colors.amber.withValues(alpha: 0.4),
            ),
            typeName: "Ghế VIP",
            priceText: "${currencyFormatter.format(showtime.vipPrice)} VND",
            isVipText: true,
          ),
          _buildTableRow(
            seatWidget: _buildMockSeatUI(
              width: 76, 
              color: const Color(0xFF3A222E), 
              borderCol: Colors.pink.withValues(alpha: 0.4),
              isCouple: true,
            ),
            typeName: "Ghế đôi (Couple)",
            priceText: "${currencyFormatter.format(showtime.couplePrice)} VND",
            isCoupleText: true,
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow({
    required Widget seatWidget, 
    required String typeName, 
    required String priceText,
    bool isVipText = false,
    bool isCoupleText = false,
  }) {
    Color titleColor = AppColors.textPrimary;
    if (isVipText) titleColor = Colors.amber[200]!;
    if (isCoupleText) titleColor = Colors.pink[200]!;

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: seatWidget,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                typeName,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                priceText,
                style: TextStyle(
                  color: AppColors.secondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMockSeatUI({required double width, required Color color, Color? borderCol, bool isCouple = false}) {
    return Container(
      width: width,
      height: 30, 
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isCouple ? 10 : 6),
        border: borderCol != null ? Border.all(color: borderCol, width: 1) : null,
      ),
      child: Center(
        child: Icon(
          isCouple ? Icons.people_outline : Icons.person_outline,
          size: 12,
          color: borderCol ?? AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
