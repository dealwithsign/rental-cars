// presentation/pages/pick_maps_page.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';

class PickLocations extends StatefulWidget {
  const PickLocations({super.key});

  @override
  State<PickLocations> createState() => _PickLocationsState();
}

class _PickLocationsState extends State<PickLocations> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  String selectedLocationAddress = "";
  String selectedLocationName = "";
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool isLocationFound = true; // Flag to track if searched location is found

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  Future<void> _locateUser() async {
    Position position;
    try {
      position = await getCurrentLocation();
      _updateCameraPosition(position);
    } catch (e) {
      print('Error getting current location: $e');
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
      print('Error getting address: $e');
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
            isLocationFound =
                false; // Set flag to false if location is not found
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
          isLocationFound = true; // Set flag to true if location is found
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
        resizeToAvoidBottomInset:
            false, // This line ensures that the Scaffold's body is resized when the keyboard appears
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
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: kPrimaryColor,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Masukan lokasi jemput,kota, dll',
                          hintStyle: subTitleTextStyle.copyWith(
                            fontSize: 14.0,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                        ),
                        onSubmitted: (value) {
                          searchAndNavigate(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
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
                      if (!isLocationFound)
                        Container(
                          margin: EdgeInsets.only(
                            left: defaultMargin,
                            right: defaultMargin,
                            bottom: defaultMargin,
                          ),
                          child: const Text(
                            "Lokasi tidak ditemukan",
                            style: TextStyle(
                              color: Colors.red, // Set color as needed
                            ),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin,
                          left: defaultMargin,
                          bottom: defaultMargin,
                        ),
                        child: Text(
                          "Pilih Titik Jemput",
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
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
                          title: "Atur Lokasi Jemput",
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
