import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_app/icons/kebhana_icons.dart';
import 'package:my_app/models/qr_respon.dart';
import 'package:my_app/pages/transfer_info_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'error-page.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('KEB HANA')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize : MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                },
                child: const Text('Start Scan QR'),
              ),
            ],
          ),
        ));
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(title: Text("Scan Qr")),
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Icon(
                Kebhana.vietqr,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Icon(
                Kebhana.kebhana,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.7,
                child: Text(
                  'Please the QR code within the scan frame',
                  style: TextStyle(color: Colors.white),
                )),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.9,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Icon(
                Kebhana.napasqr,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.9,
              left: MediaQuery.of(context).size.width * 0.4,
              child: Icon(
                Kebhana.napasqr,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.9,
              left: MediaQuery.of(context).size.width * 0.7,
              child: Icon(
                Kebhana.kebhana,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              child: buildControlButtons(context),
            ),
          ],
        ),
      );

  Widget buildControlButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
          color: Colors.white24),
      child: IconButton(
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
          icon: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              return Icon(
                snapshot.data == true ? Icons.flash_on : Icons.flash_off,
                size: MediaQuery.of(context).size.width * 0.1,
              );
            },
          )),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) async {
    if (!mounted) return;
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        // controller.dispose();
        controller.pauseCamera();
      });
      await valid();
    });
  }

  Future<void> valid() async {
    print('-------------------- ${result!.code}');
    String content = '';

    try {
      Response response = await http.get(Uri.parse(
          'http://103.160.89.20:9796/qr/valid?strQR=${result!.code}'));
      if (response.statusCode == 200) {
        QRRespon qrRespon = QRRespon.fromJson(jsonDecode(response.body));
        if (qrRespon.accCode != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Transfer(
                      qrRespon: qrRespon,
                    )),
          );
          return;
        } else {
          content = 'QR code is not correct format';
        }
      } else {
        content = 'System error!!';
      }
    } catch (e) {
      print('Scan error : $e');
      content = e.toString();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ErrorPage(errorStr: content)),
    );
  }
}
