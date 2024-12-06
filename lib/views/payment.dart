import 'package:final_commerce/views/paymentservice.dart';
import 'package:flutter/material.dart';

class payment extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => paymentState();
}

class paymentState extends State<payment>{
  Map<String, dynamic>? paymentIntent;
  PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Payment Page"),
    ),
    body: Center(
      child: TextButton(onPressed: (){}, child: Text("Pay")),
    ),
  );
  }

}