import 'dart:convert';
import 'dart:developer';
import 'package:assignment/features/auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final paymentRepositoryProvider = Provider((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  return PaymentRepository(
    auth: auth,
    firestore: firestore,
  );
});

class PaymentRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  PaymentRepository({
    required this.auth,
    required this.firestore,
  });

  Future<void> initPaymentSheet(
      {required BuildContext context, required String amount}) async {
    try {
      var paymentIntent = await createpayment(amount: amount, currency: 'INR');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'Ikay',
      ))
          .then((value) {
        displayPaymentSheet(
          context: context,
          amount: amount,
        );
        paymentIntent = null;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future createpayment(
      {required String amount, required String currency}) async {
    try {
      final body = {
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        "automatic_payment_methods[enabled]": "true",
      };
      var res = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  displayPaymentSheet(
      {required BuildContext context, required String? amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) {
          firestore.collection('users').doc(auth.currentUser!.uid).update(
            {
              'wallet': FieldValue.increment(
                int.parse(amount!),
              ),
            },
          );
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                );
              });
        },
      ).onError((error, stackTrace) {
        log(error.toString());
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    SizedBox(height: 10.0),
                    Text("Payment Failed!"),
                  ],
                ),
              );
            });
      });
    } on StripeException catch (e) {
      log(e.toString());

      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 100.0,
            ),
            SizedBox(height: 10.0),
            Text("Payment Failed!"),
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<UserModel?> walletAmount() {
    UserModel? userModel;

    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .asyncMap(
      (event) {
        userModel = UserModel.fromMap(event.data()!);
        return userModel;
      },
    );
  }
}
