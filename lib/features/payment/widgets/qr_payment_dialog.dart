import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/payment_provider.dart';
import '../../main/screens/main_screen.dart';

class QRPaymentDialog extends StatefulWidget {
  final PaymentProvider provider;
  final int paymentId;
  final double amount;
  final int initialSecondsLeft;

  const QRPaymentDialog({
    super.key,
    required this.provider,
    required this.paymentId,
    required this.amount,
    this.initialSecondsLeft = 600,
  });

  @override
  State<QRPaymentDialog> createState() => _QRPaymentDialogState();
}

class _QRPaymentDialogState extends State<QRPaymentDialog> {
  late int _secondsLeft;
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.initialSecondsLeft;
    if (_secondsLeft < 0) _secondsLeft = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
          _onFail();
        }
      });
    });
  }

  Future<void> _onFail() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    
    await widget.provider.failPaymentFlow(widget.paymentId);
    
    if (mounted) {
      Navigator.pop(context); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thanh toán thất bại! Bạn có thể thử lại."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onSuccess() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _timer?.cancel();
    
    bool success = await widget.provider.confirmPaymentFlow(widget.paymentId);
    
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 1),
        ),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thanh toán thành công!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      setState(() => _isProcessing = false);
      _startTimer(); // Khôi phục lại timer nếu lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.provider.errorMessage ?? "Có lỗi xảy ra!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onFail();
      },
      child: Dialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Quét mã để thanh toán",
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Giả lập QR code
              Container(
                width: 200,
                height: 200,
                color: Colors.white,
                child: const Icon(Icons.qr_code_2, size: 180, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                "Số tiền: ${widget.amount.toInt()} VND",
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 8),
              Text(
                "Thời gian còn lại: ${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}",
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.redAccent),
              ),
              const SizedBox(height: 24),
              if (_isProcessing)
                const CircularProgressIndicator(color: AppColors.secondary)
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _onSuccess,
                        child: const Text("Thanh toán thành công", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _onFail,
                        child: const Text("Thanh toán thất bại"),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
