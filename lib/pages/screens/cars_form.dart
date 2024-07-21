import 'package:flutter/material.dart';
import 'package:rents_cars_app/pages/screens/book_with_driver.dart';

import 'package:rents_cars_app/utils/widgets/button.dart';
import '../../models/cars.dart';
import '../../utils/fonts/constant.dart';

enum RentType { withDriver, withoutDriver }

class BookFormScreen extends StatefulWidget {
  final CarsModels car;

  const BookFormScreen({super.key, required this.car});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  RentType _selectedRentType = RentType.withDriver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Selesai Pesanan',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarInformation(),
            SizedBox(height: defaultMargin * 2),
            _buildUserReviews(),
            SizedBox(height: defaultMargin * 2),
            _buildInformationRents(),
            SizedBox(height: defaultMargin * 2),
            _buildRentTypeSelection(),
            SizedBox(height: defaultMargin * 2),
            _buildBottomBar(context, widget.car),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Mobil dan Vendor',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Image.network(
                  widget.car.carLogo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.car.carName,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.car.seats} penumpang • 1 koper",
                      style: subTitleTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.car.ownerCar,
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(
              '4.8 (20 reviews)',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin),
        _buildReviewTile(
          name: 'John Doe',
          imageUrl: 'https://picsum.photos/200/300?grayscale',
          rating: 4,
          review:
              'Layanan yang sangat memuaskan! Mobil dalam kondisi prima dan sopir sangat profesional.',
        ),
        _buildReviewTile(
          name: 'Jane Smith',
          imageUrl: 'https://picsum.photos/200/300?grayscale',
          rating: 5,
          review:
              'Sangat puas dengan layanan rental mobil ini. Proses pengambilan dan pengembalian mobil sangat mudah.',
        ),
        _buildReviewTile(
          name: 'Michael Brown',
          imageUrl: 'https://picsum.photos/200/300?grayscale',
          rating: 4,
          review:
              'Sopirnya sangat profesional dan mengetahui rute terbaik. Sangat direkomendasikan!',
        ),
      ],
    );
  }

  Widget _buildReviewTile({
    required String name,
    required String imageUrl,
    required int rating,
    required String review,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: List.generate(
                rating,
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 16)),
          ),
        ],
      ),
      subtitle: Text(
        review,
        style: blackTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRentTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Jenis Rental',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RentTypeOption(
              type: RentType.withoutDriver,
              title: 'Dengan Sopir',
              isSelected: _selectedRentType == RentType.withoutDriver,
              onSelect: () {
                setState(() {
                  _selectedRentType = RentType.withoutDriver;
                  print(_selectedRentType);
                });
              },
            ),
            _RentTypeOption(
              type: RentType.withDriver,
              title: 'Lepas Kunci',
              isSelected: _selectedRentType == RentType.withDriver,
              onSelect: () {
                setState(() {
                  _selectedRentType = RentType.withDriver;
                  print(_selectedRentType);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInformationRents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Rental',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        ..._buildInfoItems([
          {
            'text':
                'Penggunaan mobil selama 12 jam atau hingga 23:59 jika dimulai di atas jam 12:00.',
            'icon': Icons.directions_car
          },
          {
            'text':
                'Belum termasuk biaya bensin minimal 50.000 atau mengikuti bar awal pemakaian.',
            'icon': Icons.local_gas_station
          },
          {
            'text':
                'Belum termasuk biaya tol, parkir, makan sopir, dan pemakaian di luar area 0.',
            'icon': Icons.money_off
          },
          {
            'text': 'Belum termasuk biaya kelebihan waktu dan jarak.',
            'icon': Icons.timer
          },
        ]),
      ],
    );
  }

  List<Widget> _buildInfoItems(List<Map<String, dynamic>> infos) {
    return infos.map((info) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(
              info['icon'],
              color: kPrimaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                info['text'],
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildBottomBar(BuildContext context, CarsModels car) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultMargin),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kBackgroundColor, width: 2.5)),
      ),
      child: CustomButton(
        title: 'Lanjut ke Form Pemesanan',
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BookWithDriverPage(),
          //   ),
          // );
        },
        // onPressed: () {
        //   if (_selectedRentType == RentType.withDriver) {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const BookWithDriverPage(),
        //       ),
        //     );
        //   } else {
        //     // Assuming WithoutDriverPage exists and is correctly implemented
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const BookWithKey(),
        //       ),
        //     );
        //   }
        // },
      ),
    );
  }
}

class _RentTypeOption extends StatelessWidget {
  final RentType type;
  final String title;
  final bool isSelected;
  final VoidCallback onSelect;

  const _RentTypeOption({
    required this.type,
    required this.title,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(defaultRadius),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kBackgroundColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
