import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/fonts/constant.dart';
import '../../utils/widgets/navigation.dart';
import '../accounts/accounts.dart';
import '../screens/home.dart';
import '../screens/ticket.dart';
import '../../bloc/navigations/bloc/pages_bloc.dart';

// Import your PagesBloc

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  Widget buildContent(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const NotificationsScreen();
      case 2:
        return const AccountsScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget customBottomNavigation(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(
          bottom: 0,
        ),
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border(
            top: BorderSide(
              width: 1.5,
              color: kBackgroundColor,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomBottomNavigationItem(
              index: 0,
              iconData: FontAwesomeIcons.house,
              label: 'Home',
            ),
            CustomBottomNavigationItem(
              index: 1,
              iconData: FontAwesomeIcons.ticketSimple,
              label: 'Tiket',
            ),
            CustomBottomNavigationItem(
              index: 2,
              iconData: FontAwesomeIcons.circleUser,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        if (state is PageLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kBackgroundColor,
            body: Stack(
              children: [
                buildContent(state.currentIndex),
                customBottomNavigation(
                  context,
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: kWhiteColor,
          );
        }
      },
    );
  }
}
