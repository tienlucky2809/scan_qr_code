import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/qr_respon.dart';

import '../main.dart';

class Transfer extends StatefulWidget {
  QRRespon qrRespon;
  Transfer({required this.qrRespon});
  @override
  State<StatefulWidget> createState() => _Transfer();
}
class _Transfer extends State<Transfer>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Transfer money",
      home: Scaffold(
        body: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Bin code : ${widget.qrRespon.binCode}', style: TextStyle(fontSize: 20, color: Colors.black),),
              Text('Bank name : ${widget.qrRespon.bankName}', style: TextStyle(fontSize: 20, color: Colors.black),),
              Text('Account/card number : ${widget.qrRespon.accCode}', style: TextStyle(fontSize: 20, color: Colors.black),),
              Text('Service name : ${widget.qrRespon.serviceCode}', style: TextStyle(fontSize: 20, color: Colors.black),),
              Text('Amount : ${widget.qrRespon.amount}', style: TextStyle(fontSize: 20, color: Colors.black),),
              Text('Content : ${widget.qrRespon.contentTransfer}', style: TextStyle(fontSize: 20, color: Colors.black),),

              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ));
                },
                child: const Text('Go to home'),
              ),

            ],
          ),
        ),
      ),
    );
  }

}