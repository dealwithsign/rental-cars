import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/navigations/bloc/pages_bloc.dart';
import '../fonts/constant.dart';

// Import your PagesBloc

class CustomBottomNavigationItem extends StatelessWidget {
  final int index;
  final IconData iconData;
  final String label;

  const CustomBottomNavigationItem({
    super.key,
    required this.index,
    required this.iconData,
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
                  const SizedBox(height: 10),
                  Icon(
                    iconData,
                    size: 15,
                    color: isActive ? kIcon : descGrey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    style: blackTextStyle.copyWith(
                      color: isActive ? kIcon : descGrey,
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Container(
                width: 20,
                height: 5,
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
