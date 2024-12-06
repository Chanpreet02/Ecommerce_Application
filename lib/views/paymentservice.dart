class PaymentService{
  void createPaymentIntent(String amount, String currency){
    try{
      Map<String, dynamic> body = {
         'amount':((int.parse(amount))*100).toString(),
        'currency':currency,
        'payment_method_type[]':'card',
      };
      var secretKey = "";
    }catch(e){
      print(e);
    }
  }
}