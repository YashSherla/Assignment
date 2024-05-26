import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/payment/repository/payment_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentControllerProvider = Provider((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return PaymentController(
    paymentRepository: paymentRepository,
    ref: ref,
  );
});

// final makePaymentprovider = FutureProvider.family((ref, String amount) async {
//   final paymentController = ref.watch(paymentControllerProvider);
//   return paymentController.makePayment(amount: amount);
// });

class PaymentController {
  final PaymentRepository paymentRepository;
  final ProviderRef ref;

  PaymentController({required this.paymentRepository, required this.ref});

  makePayment({required BuildContext context, required String amount}) async {
    paymentRepository.initPaymentSheet(context: context, amount: amount);
  }

  Stream<UserModel?> walletAmount() {
    return paymentRepository.walletAmount();
  }
}
