// presentation/pages/accounts_edit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../data/models/users_model.dart';
import '../../data/services/authentication_services.dart';

import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/flushbar_widget.dart';
import '../widgets/input_widget.dart';
import 'wrapper_auth_page.dart';

class AccountsEdit extends StatefulWidget {
  const AccountsEdit({super.key});

  @override
  State<AccountsEdit> createState() => _AccountsEditState();
}

class _AccountsEditState extends State<AccountsEdit> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _phoneNumberFocusNode = FocusNode();
  late UserModel user; // Add UserModel instance

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          surfaceTintColor: kWhiteColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              LineIcons.angleLeft,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: kWhiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: defaultMargin * 2),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ubah Nomor WhatsApp",
          style: titleTextStyle.copyWith(
            fontSize: 24,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin / 2),
        Text(
          "Masukkan nomor WhatsApp yang ingin kamu gunakan",
          style: blackTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          OutlineBorderTextFormField(
            labelText: 'Nomor WhatsApp',
            autofocus: false,
            tempTextEditingController: _phoneNumberController,
            myFocusNode: _phoneNumberFocusNode,
            inputFormatters: const [],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            validator: (value) {
              return value!.isEmpty ? 'Phone Number tidak boleh kosong' : null;
            },
          ),
          Container(
            margin: EdgeInsets.only(top: defaultMargin * 2),
            child: CustomButton(
              title: "Simpan",
              onPressed: _handleUpdate,
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpdate() async {
    if (_phoneNumberController.text.isEmpty) {
      showErrorFlushbar(
        context,
        "Pembaruan Gagal",
        "Silakan lengkapi informasi yang diperlukan sebelum melanjutkan",
      );
    } else {
      final phoneNumber = int.parse(_phoneNumberController.text);
      final AuthServices authServices = AuthServices();
      try {
        final updatedUser = await authServices.updatePhoneNumber(
          phone_number: phoneNumber,
        );
        setState(() {
          user = updatedUser;
        });

        // Show success message
        showErrorFlushbar(
          context,
          "Nomor Tersimpan",
          "Nomor WhatsApp berhasil diperbarui",
        );

        _navigateTo(const WrapperAuth());
      } catch (e) {
        showErrorFlushbar(
          context,
          "Pembaruan Gagal",
          "Terjadi kesalahan saat memperbarui nomor telepon",
        );
      }
    }
  }
}
