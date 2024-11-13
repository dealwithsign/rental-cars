// presentation/pages/drop_maps_page.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';

class PickDrop extends StatefulWidget {
  const PickDrop({super.key});

  @override
  State<PickDrop> createState() => _PickDropState();
}

class _PickDropState extends State<PickDrop> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  String selectedLocationAddress = "";
  String selectedLocationName = "";
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _locateUser();
  }

  void _onTap(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );
    });
    getAddressFromLatLng(position);
  }

  @override
  void initState() {
    super.initState();
    _locateUser();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _locateUser() async {
    try {
      Position position = await getCurrentLocation();
      if (mounted) {
        _updateCameraPosition(position);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedLocationAddress = "Failed to get current location. Error: $e";
        });
      }
    }
  }

  void _updateCameraPosition(Position position) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );
    if (mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        getAddressFromLatLng(LatLng(position.latitude, position.longitude));
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String addressDesc =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
        String addressName = "${place.street}";
        if (mounted) {
          setState(() {
            selectedLocationAddress = addressDesc;
            selectedLocationName = addressName;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedLocationAddress = "Failed to get address. Error: $e";
        });
      }
    }
  }

  void searchAndNavigate(String searchText) {
    GeocodingPlatform.instance!
        .locationFromAddress(searchText)
        .then((locations) {
      if (locations.isEmpty) {
        if (mounted) {
          setState(() {
            selectedLocationName = "Lokasi tidak ditemukan";
            selectedLocationAddress = "";
          });
        }
        return;
      }
      LatLng searchedLocation =
          LatLng(locations.first.latitude, locations.first.longitude);
      mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(searchedLocation, 14.0));
      if (mounted) {
        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId(searchedLocation.toString()),
              position: searchedLocation,
              infoWindow: const InfoWindow(title: 'Searched Location'),
            ),
          );
          getAddressFromLatLng(searchedLocation);
        });
      }
    }).catchError((error) {
      print('Error searching for location: $error');
      if (mounted) {
        setState(() {
          selectedLocationName = "Lokasi tidak ditemukan";
          selectedLocationAddress =
              "Gunakan kata kunci seperti Toraja, Makassar, dll";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-3.1048903, 119.8492578),
                zoom: 15.0,
              ),
              markers: _markers,
            ),
            Positioned(
              top: 40.0,
              left: 15.0,
              right: 15.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Iconsax.arrow_left_2,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: kPrimaryColor,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan lokasi drop, kota, dll',
                          hintStyle: subTitleTextStyle.copyWith(
                            fontSize: 15.0,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: defaultMargin,
                          ),
                        ),
                        onSubmitted: (value) {
                          searchAndNavigate(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        String searchText = _searchController.text;
                        if (searchText.isNotEmpty) {
                          searchAndNavigate(searchText);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: kWhiteColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin,
                          left: defaultMargin,
                          bottom: defaultMargin,
                        ),
                        child: Text(
                          "Pilih Lokasi Drop",
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: defaultMargin,
                          right: defaultMargin,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedLocationName,
                              style: blackTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: defaultMargin / 2),
                            Text(
                              selectedLocationAddress,
                              style: subTitleTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin,
                          left: defaultMargin,
                          right: defaultMargin,
                          bottom: defaultMargin,
                        ),
                        child: CustomButton(
                          title: "Atur Lokasi Drop",
                          onPressed: () {
                            String selectedLocation = selectedLocationAddress;
                            _locationController.text = selectedLocation;
                            Navigator.pop(context, selectedLocation);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
