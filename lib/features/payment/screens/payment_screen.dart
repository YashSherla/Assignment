import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/payment/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final UserModel? usermodel;
  const PaymentScreen({
    super.key,
    required this.usermodel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  TextEditingController amountController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  void makePayment({required String amount}) {
    ref.watch(paymentControllerProvider).makePayment(
          amount: amount,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<UserModel?>(
          stream: ref.watch(paymentControllerProvider).walletAmount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Payment",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                  child: Row(
                    children: [
                      Image.network(
                        'https://raw.githubusercontent.com/shivam22rkl/FoodDeliveryApp-From-Scratch/main/images/wallet.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          const Text(
                            "Balance",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            snapshot.data!.wallet.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      openEdit();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(400, 60),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Add Money",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel)),
                      const SizedBox(
                        width: 60.0,
                      ),
                      const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            color: Color(0xFF008080),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Amount"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Enter Amount'),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        makePayment(amount: amountController.text);
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
