// presentation/pages/accounts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';
import 'package:rents_cars_app/presentation/pages/terms_conditions.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/users_model.dart';
import '../../data/services/authentication_services.dart';
import '../../data/services/whatsapp_services.dart';
import '../../utils/fonts.dart';
import 'accounts_edit.dart';

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

  final WhatsappServices whatsappService = WhatsappServices();
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
        style: titleTextStyle.copyWith(
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
          return SingleChildScrollView(
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
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: EdgeInsets.only(bottom: defaultMargin * 2),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: kPrimaryColor,
              child: Text(
                getInitials(user.username),
                style: buttonColor.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ),
            SizedBox(width: defaultMargin),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: titleTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: defaultMargin / 2),
                Text(
                  user.email,
                  style: subTitleTextStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "0${user.phone_number}",
                  style: subTitleTextStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: defaultMargin),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountsEdit(),
                      ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
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
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          _buildSettingItem(
            icon: FontAwesomeIcons.circleQuestion,
            title: 'Bantuan',
            subTitle: 'Temukan jawaban terbaik dari pertanyaanmu',
            onTap: () {
              whatsappService.sendWhatsAppMessage(
                contact: '082134400200', // Replace with actual contact number
                message:
                    'Halo, saya butuh bantuan.', // Replace with actual message
              );
            },
          ),
          _buildSettingItem(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'Syarat & Ketentuan',
            subTitle: 'Baca syarat & ketentuan kami disini',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditions(),
                ),
              );
            },
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WrapperAuth(),
                ),
              );
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
                    fontSize: 16,
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
            '© 2024 Lalan.id',
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
