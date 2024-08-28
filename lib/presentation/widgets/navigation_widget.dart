// presentation/widgets/navigation_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/navigations/pages_bloc.dart';
import '../../utils/fonts.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  final int index;
  final Widget icon; // Changed from IconData to Widget
  final String label;

  const CustomBottomNavigationItem({
    super.key,
    required this.index,
    required this.icon, // Changed from iconData to icon
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PagesBloc>().add(PageTapped(index));
      },
      child: BlocBuilder<PagesBloc, PagesState>(
        builder: (context, state) {
          final bool isActive =
              state is PageLoaded && state.currentIndex == index;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: defaultMargin),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      isActive ? kPrimaryColor : descGrey,
                      BlendMode.srcIn,
                    ),
                    child: icon, // Use the icon Widget directly
                  ),
                  SizedBox(height: defaultMargin / 2),
                  Text(
                    label,
                    style: blackTextStyle.copyWith(
                      color: isActive ? kPrimaryColor : descGrey,
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Container(
                width: 20,
                height: defaultMargin / 2,
                decoration: BoxDecoration(
                  color: isActive ? kTransparentColor : kTransparentColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
