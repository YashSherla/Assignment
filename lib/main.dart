import 'package:assignment/features/auth/controller/auth_controller.dart';
import 'package:assignment/features/auth/screens/login_screen.dart';
import 'package:assignment/features/widgets/bottom_navigator_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51P5NiRSGwHNy9Mjk97Wkq7WyAudkbL3sTEPCIGAsIXqDrvbGFibJWkG7gGIss86Oju4ugebFaVKqpMV0xRxzp5me00SVKWk5Ic";
  await dotenv.load(fileName: "assets/.env");
  await Stripe.instance.applySettings();
  Stripe.urlScheme = 'flutterstripe';

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ref.watch(getuserDataControllerProvider).when(data: (data) {
          if (data != null) {
            return HomeBottomNavigatorBar(
              usermodel: data,
            );
          } else {
            return const LoginScreen();
          }
        }, error: (error, stackTrace) {
          return null;
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
