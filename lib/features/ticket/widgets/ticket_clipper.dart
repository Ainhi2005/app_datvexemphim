// lib/features/booking/widgets/ticket_clipper.dart
import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double cutoutRadius = 15; // Bán kính lỗ khoét 2 bên
    double cutoutPosition = size.height - 140; // Vị trí khoét lỗ
    double cornerRadius = 16; // Bán kính bo tròn 4 góc vé

    // Bắt đầu từ mép trên bên trái (sau góc bo)
    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    // Bo góc trên phải
    path.arcToPoint(Offset(size.width, cornerRadius), radius: Radius.circular(cornerRadius), clockwise: true);

    // Đi xuống cạnh phải tới mép lỗ khoét
    path.lineTo(size.width, cutoutPosition - cutoutRadius);
    // Cắt lỗ khoét bên phải (lõm vào trong)
    path.arcToPoint(Offset(size.width, cutoutPosition + cutoutRadius), radius: Radius.circular(cutoutRadius), clockwise: false);

    // Đi tiếp cạnh phải tới sát đáy
    path.lineTo(size.width, size.height - cornerRadius);
    // Bo góc dưới phải
    path.arcToPoint(Offset(size.width - cornerRadius, size.height), radius: Radius.circular(cornerRadius), clockwise: true);

    // Kẻ cạnh đáy sang trái
    path.lineTo(cornerRadius, size.height);
    // Bo góc dưới trái
    path.arcToPoint(Offset(0, size.height - cornerRadius), radius: Radius.circular(cornerRadius), clockwise: true);

    // Đi lên cạnh trái tới mép lỗ khoét
    path.lineTo(0, cutoutPosition + cutoutRadius);
    // Cắt lỗ khoét bên trái (lõm vào trong)
    path.arcToPoint(Offset(0, cutoutPosition - cutoutRadius), radius: Radius.circular(cutoutRadius), clockwise: false);

    // Đi tiếp cạnh trái lên sát đỉnh
    path.lineTo(0, cornerRadius);
    // Bo góc trên trái
    path.arcToPoint(Offset(cornerRadius, 0), radius: Radius.circular(cornerRadius), clockwise: true);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}