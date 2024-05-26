import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/chats/screens/contact_screen.dart';
import 'package:assignment/features/payment/screens/payment_screen.dart';
import 'package:assignment/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBottomNavigatorBar extends ConsumerStatefulWidget {
  final UserModel? usermodel;
  const HomeBottomNavigatorBar({super.key, required this.usermodel});

  @override
  ConsumerState<HomeBottomNavigatorBar> createState() =>
      _HomeBottomNavigatorBarState();
}

class _HomeBottomNavigatorBarState
    extends ConsumerState<HomeBottomNavigatorBar> {
  late List<Widget> pages;
  late MyContactsScreen myContactsScreen;
  late PaymentScreen paymentScreen;
  late ProfileScreen profileScreen;
  int currentIndex = 0;
  @override
  void initState() {
    myContactsScreen = MyContactsScreen(
      userModel: widget.usermodel!,
    );
    paymentScreen = PaymentScreen(
      usermodel: widget.usermodel!,
    );
    profileScreen = ProfileScreen(
      usermodel: widget.usermodel!,
    );
    pages = [myContactsScreen, paymentScreen, profileScreen];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: pages[currentIndex],
    );
  }
}
