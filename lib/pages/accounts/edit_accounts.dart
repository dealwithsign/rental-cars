import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rents_cars_app/models/users.dart';
import '../../bloc/auth/bloc/auth_bloc.dart';
import '../../utils/fonts/constant.dart';
import '../../utils/widgets/button.dart';

class EditAccounts extends StatefulWidget {
  const EditAccounts({super.key});

  @override
  State<EditAccounts> createState() => _EditAccountsState();
}

class _EditAccountsState extends State<EditAccounts> {
  String getInitials(String name) {
    List<String> names =
        name.trim().split(" ").where((part) => part.isNotEmpty).toList();
    if (names.length > 1) {
      return (names[0][0] + names[1][0]).toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: kWhiteColor,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Edit Profile',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildImageProfile(state.user!),
                    ),
                    SizedBox(height: defaultMargin),
                    Divider(
                      color: kBackgroundColor,
                      thickness: 10,
                    ),
                    SizedBox(height: defaultMargin),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildAccountInformation(state.user!),
                    ),
                  ],
                ),
              );
            } else if (state is AuthFailure) {
              return Center(child: Text("Please log in to continue"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildImageProfile(UserModel user) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
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
      ],
    );
  }

  Widget _buildAccountInformation(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informasi Profil",
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        Text(
          "Informasi yang Anda bagikan akan digunakan di seluruh Airbnb untuk membantu tamu dan tuan rumah lainnya mengenal Anda.",
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        SizedBox(height: defaultMargin),
        _buildInfoFormField("Nama", "Masukkan nama lengkap Anda"),
        _buildInfoFormField("Nomor HP", "Tulis tentang diri Anda"),
        SizedBox(height: defaultMargin * 2),
        CustomButton(
          title: "Simpan",
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildInfoFormField(String label, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          TextFormField(
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: bold,
            ),
            maxLines: null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: subTitleTextStyle.copyWith(
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                borderSide: BorderSide(
                  color: kDivider,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
