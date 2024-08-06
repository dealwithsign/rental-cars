// presentation/pages/accounts_page.dart
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/users_model.dart';
import '../../data/services/authentication_services.dart';
import '../../utils/fonts.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetCurrentUserRequested());
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  String getInitials(String name) {
    List<String> names =
        name.trim().split(" ").where((part) => part.isNotEmpty).toList();
    String initials = "";

    if (names.length > 1) {
      initials = names[0][0] + names[1][0];
    } else if (names.isNotEmpty) {
      initials = names[0][0];
    }

    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Profile',
        style: blackTextStyle.copyWith(
          fontSize: 24,
          fontWeight: bold,
        ),
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is AuthSuccess) {
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildUserProfile(state.user!),
                  ),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildSettings(),
                  ),
                  SizedBox(height: defaultMargin * 2),
                  _buildAppVersions(),
                ],
              ),
            ),
          );
        } else if (state is AuthFailure) {
          return Center(
              child: Text('Failed to load user data: ${state.error}'));
        } else {
          return const Center(
              child: Text('Please log in to see account details'));
        }
      },
    );
  }

  Widget _buildUserProfile(UserModel user) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultMargin * 2),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: kPrimaryColor,
            backgroundImage: user.url_profile.isNotEmpty
                ? NetworkImage(user.url_profile)
                : null,
            child: user.url_profile.isEmpty
                ? Text(
                    getInitials(user.username),
                    style: whiteTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                    ),
                  )
                : null,
          ),
          SizedBox(width: defaultMargin),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username.split('@').first,
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: subTitleTextStyle.copyWith(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.phone_number.toString(),
                style: subTitleTextStyle.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Container(
      margin: EdgeInsets.only(top: defaultMargin * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Akun',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          _buildSettingItem(
            icon: FontAwesomeIcons.circleQuestion,
            title: 'Pusat Bantuan',
            subTitle: 'Temukan jawaban terbaik dari pertanyaan kamu',
            onTap: () {
              // Navigator.pushNamed(context, '/editAccounts');
            },
          ),
          _buildSettingItem(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'Syarat & Ketentuan',
            subTitle: 'Baca syarat & ketentuan kami disini',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: FontAwesomeIcons.star,
            title: 'Beri Kami Nilai',
            subTitle: 'Beri kami nilai dan ulasan',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: FontAwesomeIcons.rightFromBracket,
            title: 'Keluar',
            subTitle: 'Kamu harus masuk lagi untuk melanjutkan',
            onTap: () async {
              await AuthServices().signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: kWhiteColor,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: defaultMargin),
        child: Row(
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
              size: 20,
            ),
            SizedBox(width: defaultMargin),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
                Text(
                  subTitle,
                  style: subTitleTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              LineIcons.angleRight,
              color: kPrimaryColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersions() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Versi 1.0.0',
            style: subTitleTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '© 2021 Rents Cars',
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}