// presentation/pages/terms_conditions.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../utils/fonts.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(),
      body: Skeletonizer(
        enabled: _isLoading,
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      title: Text(
        'Syarat dan Ketentuan',
        style: titleTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Iconsax.arrow_left_2,
          size: 20,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionTitle('Terakhir di Perbaharui'),
          ),
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionContent(
              '1.0 - 17 Agustus 2024',
            ),
          ),
          // about apps
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionTitle('Tentang Lalan'),
          ),
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionContent(
              'Terima kasih telah menggunakan Lalan. Kami berharap Anda merasa nyaman dan mendapatkan manfaat dari layanan yang kami sediakan. Kami terus berusaha meningkatkan kualitas layanan kami dan sangat menghargai masukan dari Anda.',
            ),
          ),
          SizedBox(height: defaultMargin),
          // what is terms and conditions
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionTitle('Apa itu Kebijakan Privasi di Lalan'),
          ),
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionContent(
              'Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, melindungi, dan membagikan informasi pribadi pengguna. Kami akan menjelaskan jenis data yang dikumpulkan, tujuan penggunaannya, potensi pengungkapan kepada pihak ketiga, langkah-langkah keamanan, hak pengguna, dan penggunaan cookies. Kebijakan ini memastikan transparansi dan melindungi hak privasi sesuai dengan peraturan yang berlaku.',
            ),
          ),
          SizedBox(height: defaultMargin * 2),
          // including term and conditions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: _buildSectionTitle(
              'Kebijakan Privasi ini mencakup hal-hal berikut:',
            ),
          ),
          SizedBox(height: defaultMargin * 2),
          _buildListItem(
            '1.',
            'Informasi Pribadi yang kami kumpulkan',
            'Informasi pribadi yang kami kumpulkan meliputi nama lengkap, tanggal lahir, jenis kelamin, alamat email, nomor telepon, foto profil, dan alamat fisik. Kami juga mengumpulkan informasi akun seperti nama pengguna dan kata sandi, serta data pembayaran seperti informasi kartu kredit, transaksi perbankan, dan akun virtual yang tersimpan secara tidak langsung pada payment gateway yang kami gunakan. Selain itu, kami mengumpulkan data lokasi dari IP address atau GPS jika diperlukan, serta detail transaksi, riwayat aktivitas di Lalan, dan konten yang dibagikan di media sosial.',
          ),
          _buildListItem(
            '2.',
            'Pengunaan Informasi Pribadi ',
            'Kami menggunakan informasi pribadi Anda untuk mengelola akun, memproses pembayaran melalui payment gateway, dan memberikan layanan berbasis lokasi. Data riwayat aktivitas dan detail transaksi membantu kami meningkatkan pengalaman Anda, sementara konten media sosial digunakan untuk memahami preferensi Anda. Semua informasi dikelola dengan keamanan dan privasi yang ketat sesuai kebijakan kami dan peraturan perlindungan data. Kami juga dapat mempublikasikan ulasan Anda tentang layanan atau produk kami dan akan memberi tahu Anda tentang tujuan lain saat kami mengumpulkan data pribadi.',
          ),
          _buildListItem(
            '3.',
            'Berbagai informasi Pribadi yang kami kumpulkan',
            'Kami membagikan data pribadi Anda kepada pihak ketiga, seperti payment gateway, yang bekerja sama dengan kami untuk memproses transaksi dan menyediakan layanan kami. Kami memastikan bahwa pihak ketiga mematuhi standar perlindungan data yang sebanding dengan komitmen kami berdasarkan kebijakan privasi ini, dengan mematuhi hukum yang berlaku dan menggunakan upaya yang wajar untuk menjaga keamanan informasi Anda. ',
          ),
          _buildListItem(
            '4.',
            'Akses, koreksi dan penghapusan informasi Pribadi',
            'Anda memiliki hak untuk mengakses, mengoreksi, dan menghapus informasi pribadi yang kami miliki tentang Anda. Jika Anda ingin melihat informasi yang kami simpan, melakukan perubahan, atau menghapus data tersebut, Anda dapat menghubungi kami melalui Email atau WhatsApp yang telah disediakan. Namun, kami berhak untuk menolak permintaan Anda untuk mengakses, memperbaiki, atau menghapus sebagian atau seluruh data pribadi jika hal ini diperlukan berdasarkan hukum yang berlaku atau jika data tersebut mencakup referensi ke individu lain. Selain itu, permintaan untuk penghapusan data yang memerlukan upaya teknis yang tidak proporsional atau dapat menimbulkan risiko operasional mungkin tidak dapat kami penuhi.',
          ),
          _buildListItem(
            '5.',
            'Penyimpanan informasi Pribadi',
            'Kami menyimpan informasi pribadi Anda dengan aman selama diperlukan untuk memenuhi tujuan yang dijelaskan dalam kebijakan privasi ini. Untuk keperluan penyimpanan data, kami menggunakan pihak ketiga yang terpercaya. Anda setuju bahwa pihak ketiga ini akan mengikuti kebijakan privasi mereka masing-masing terkait pengelolaan data. Kami tidak bertanggung jawab atas kebijakan atau tindakan pihak ketiga tersebut yang mungkin memengaruhi penyimpanan dan perlindungan data Anda. Data Anda disimpan dalam sistem yang dilindungi dengan langkah-langkah keamanan yang ketat dan akan dihapus atau dianonimkan setelah tidak lagi diperlukan',
          ),
          _buildListItem(
            '6.',
            'Keamanan Data Pribadi',
            'Anda setuju bahwa informasi yang Anda kirimkan melalui internet tidak sepenuhnya aman. Meskipun kami akan menggunakan upaya terbaik untuk melindungi dan menjaga data pribadi Anda dari akses yang tidak sah, kami tidak dapat bertanggung jawab atas integritas dan keakuratan data pribadi Anda jika terjadi penyalinan, akses, pengungkapan, perubahan, atau penghancuran oleh pihak ketiga yang tidak berwenang dan di luar kontrol kami. Kami juga tidak bertanggung jawab atas kerahasiaan data pribadi Anda, termasuk penggunaan kata sandi. Anda harus segera memberi tahu kami jika terjadi penggunaan kata sandi tanpa izin Anda atau jika Anda mencurigai adanya pelanggaran keamanan pada Lalan',
          ),
          _buildListItem(
            '7.',
            'Perubahan Data Kebijakan Privasi ini',
            'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu untuk mencerminkan perubahan dalam praktik kami atau untuk mematuhi peraturan yang berlaku. Jika terjadi perubahan signifikan, kami akan memberitahukan Anda melalui email atau pemberitahuan dalam Lalan. Harap periksa kebijakan privasi secara berkala untuk mengetahui perubahan terbaru.',
          ),
          _buildListItem(
            '8.',
            'Persetujuan',
            'Dengan menggunakan layanan kami, Anda mengonfirmasi bahwa Anda telah membaca, memahami, dan setuju dengan kebijakan privasi ini. Anda memberikan persetujuan untuk pengumpulan, penggunaan, dan pembagian data pribadi Anda sebagaimana dijelaskan dalam kebijakan ini. Jika Anda tidak setuju dengan kebijakan privasi kami, harap tidak menggunakan layanan kami dan segera menghubungi kami untuk pertanyaan atau kekhawatiran lebih lanjut. ',
          ),
          _buildListItem(
            '9.',
            'Bagaimana cara menghubungi kami?',
            'Jika Anda memiliki pertanyaan, atau membutuhkan informasi lebih lanjut, Anda dapat menghubungi kami melalui email di helpmelalan@gmail.com atau telepon di +6282134400200. Kami akan berusaha merespons permintaan Anda secepat mungkin.',
          ),
          _buildListItem(
            '10.',
            'Hukum yang berlaku',
            'Penggunaan layanan online ini tunduk pada dan diatur oleh hukum yang berlaku di Indonesia, tanpa mempengaruhi adanya prinsip-prinsip konflik hukum yang mungkin berlaku.',
          ),
          SizedBox(height: defaultMargin),
          Divider(
            color: kBackgroundColor,
            thickness: 5,
          ),
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lalan',
                    style: titleTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  GestureDetector(
                    onTap: () {},
                    child: _aboutApps(
                      'WhatsApp',
                      '082134400200',
                      FontAwesomeIcons.whatsapp,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  GestureDetector(
                    onTap: () {},
                    child: _aboutApps(
                      'Email',
                      'helpmelalan@gmail.com',
                      FontAwesomeIcons.envelopeOpen,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  GestureDetector(
                    onTap: () {},
                    child: _aboutApps(
                      'Instagram',
                      'lalan.id',
                      FontAwesomeIcons.instagram,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: defaultMargin),
          Divider(
            color: kBackgroundColor,
            thickness: 5,
          ),
          SizedBox(height: defaultMargin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '© 2024 Lalan.id',
                  style: subTitleTextStyle.copyWith(
                    fontSize: 13,
                  ),
                ),
                Text(
                  'All Rights Reserved',
                  style: subTitleTextStyle.copyWith(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: defaultMargin * 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: titleTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: blackTextStyle.copyWith(
        fontSize: 15,
      ),
    );
  }

  Widget _buildListItem(String number, String content, String subContent) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: defaultMargin,
        left: defaultMargin,
        right: defaultMargin,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: blackTextStyle.copyWith(
              fontSize: 15,
            ),
          ),
          SizedBox(width: defaultMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(
                  height: defaultMargin,
                ),
                Text(
                  subContent,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutApps(
    String title,
    String message,
    IconData icon,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding:
                    EdgeInsets.all(defaultMargin), // Adjust padding as needed
                child: Icon(
                  icon,
                  color: kPrimaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: defaultMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                    SizedBox(
                      height: defaultMargin / 2,
                    ),
                    Text(
                      message,
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
