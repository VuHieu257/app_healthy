import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
 import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanQRcode extends StatefulWidget {
  const ScanQRcode({Key? key}) : super(key: key);

  @override
  _ScanQRcodeState createState() => _ScanQRcodeState();
}

class _ScanQRcodeState extends State<ScanQRcode> {
  String qrResult =
      'Quét QR thực phẩm để xem Thành phần dinh dưỡng'; // Ensure qrResult is initialized

  File? pickedImage;

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        if (qrCode != '-1') {
          qrResult = qrCode; // Update qrResult with scanned QR code
          print(qrResult);
        } else {
          qrResult = 'Failed to read QR';
        }
      });
    } on PlatformException {
      setState(() {
        qrResult = 'Failed to read QR';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              qrResult, // Display qrResult here
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: scanQR,
              child: Text('Scan Code'),
            ),
          ],
        ),
      ),
    );
  }
}
