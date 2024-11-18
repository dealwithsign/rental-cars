// presentations/pages/navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rents_cars_app/presentation/pages/ticket_page.dart';

import '../../blocs/navigations/pages_bloc.dart';
import '../../utils/fonts.dart';
import 'accounts_page.dart';
import 'home_page.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  Widget buildContent(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TicketScreen();
      case 2:
        return const AccountsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        if (state is PageLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kWhiteColor,
            body: buildContent(state.currentIndex),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1.0,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  currentIndex: state.currentIndex,
                  onTap: (index) {
                    context.read<PagesBloc>().add(PageTapped(index));
                  },
                  selectedItemColor: kPrimaryColor,
                  unselectedItemColor: descGrey,
                  selectedFontSize: 14,
                  unselectedFontSize: 14,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    _buildNavItem(
                      icon: Iconsax.home,
                      activeIcon: Iconsax.home,
                      label: 'Home',
                      isSelected: state.currentIndex == 0,
                    ),
                    _buildNavItem(
                      icon: Iconsax.ticket,
                      activeIcon: Iconsax.ticket,
                      label: 'Tiket',
                      isSelected: state.currentIndex == 1,
                    ),
                    _buildNavItem(
                      icon: Iconsax.user,
                      activeIcon: Iconsax.user,
                      label: 'Profile',
                      isSelected: state.currentIndex == 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.only(top: 5), // Minimal top padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
            ),
            const SizedBox(height: 2), // Minimal spacing
            Text(
              label,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? kPrimaryColor : descGrey,
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }
}
