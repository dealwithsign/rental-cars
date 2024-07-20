import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rents_cars_app/bloc/auth/bloc/auth_bloc.dart';
import 'package:rents_cars_app/bloc/auth/bloc/auth_event.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/users.dart';
import '../../services/users/auth_services.dart';
import '../../utils/fonts/constant.dart';

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
      setState(() {
        isLoading = false;
      });
    });
  }

  String getInitials(String name) {
    // Trim the name to remove leading/trailing whitespaces and split into parts
    List<String> names =
        name.trim().split(" ").where((part) => part.isNotEmpty).toList();
    String initials = "";

    if (names.length > 1) {
      // If there are at least two non-empty parts, take the first character of the first two parts
      initials = names[0][0] + names[1][0];
    } else if (names.isNotEmpty) {
      // If there's only one non-empty part, take the first character of that part
      initials = names[0][0];
    }

    return initials.toUpperCase(); // Return the initials in uppercase
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
          fontSize: 18,
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
              physics: BouncingScrollPhysics(),
              child: Container(
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
      margin: EdgeInsets.only(
        bottom: defaultMargin * 2,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: kPrimaryColor,
            backgroundImage: user.url_profile.isNotEmpty
                ? NetworkImage(user.url_profile)
                : null,
            child: user.url_profile.isEmpty
                ? Text(
                    getInitials(user.username),
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
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
              SizedBox(height: defaultMargin),
              Text(
                user.email,
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                user.phone_number.toString(),
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
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
      margin: EdgeInsets.only(
        top: defaultMargin * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          _buildSettingItem(
            icon: Icons.person,
            title: 'Ubah Profil',
            onTap: () {
              Navigator.pushNamed(context, '/editAccounts');
            },
          ),
          _buildSettingItem(
              icon: Icons.settings, title: 'Pusat Bantuan', onTap: () {}),
          _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Kebijakan Privasi',
              onTap: () {}),
          _buildSettingItem(
            icon: Icons.exit_to_app,
            title: 'Keluar',
            onTap: () async {
              await AuthServices().signOut();
              Navigator.pushReplacementNamed(context, '/signIn');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      splashColor: kWhiteColor,
      focusColor: kWhiteColor,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: defaultMargin),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kBackgroundColor,
              child: Icon(
                icon,
                color: kPrimaryColor,
                size: 25,
              ),
            ),
            SizedBox(width: defaultMargin),
            Text(
              title,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersions() {
    return Center(
      child: Text(
        'App Version 1.0.0',
        style: subTitleTextStyle.copyWith(
          fontSize: 13,
        ),
      ),
    );
  }
}
