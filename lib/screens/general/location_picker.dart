import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:welfare_claims_app/colors/app_colors.dart';
import 'package:welfare_claims_app/uiupdates/UIUpdates.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController googleMapController;
  LatLng targetLatLang= LatLng(0.0, 0.0);
  Map data = {"lat" : "0.0", "lng" : "0.0"};
  UIUpdates uiUpdates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUpdates= new UIUpdates(context);
  }

  Future<void> OnMapCreated(GoogleMapController controller) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

      _controller.complete(controller);
    googleMapController= controller;

    await GetCurrentLocation();
  }

  void GetCurrentLocation() async{
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      targetLatLang = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: targetLatLang, zoom: 16);
      googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition));
    }catch(e){
      print('error:$e');
      uiUpdates.ShowToast(e.toString());
    }
  }

  void _updatePosition(CameraPosition _position) {
    targetLatLang= LatLng(_position.target.latitude, _position.target.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.newWhite,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppTheme.colors.newPrimary,

              child: Container(
                margin: EdgeInsets.only(top: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.arrow_back, color: AppTheme.colors.newWhite, size: 20,),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("Location",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: (){
                        data = {"lat" : targetLatLang.latitude.toString(), "lng" : targetLatLang.longitude.toString()};
                        Navigator.pop(context, data);
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        child: Center(
                          child: Text("Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.colors.newWhite,
                                fontSize: 14,
                                fontFamily: "AppFont",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: OnMapCreated,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      onCameraMove: ((_position) => _updatePosition(_position)),
                      initialCameraPosition: CameraPosition(
                        target: targetLatLang,
                        zoom: 15,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Align(alignment: Alignment.center,
                          child: Icon(Icons.location_on, color: Colors.red, size: 40,)),
                    ),

                    // InkWell(
                    //   onTap: (){
                    //     data = {"lat" : targetLatLang.latitude.toString(), "lng" : targetLatLang.longitude.toString()};
                    //     Navigator.pop(context, data);
                    //   },
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Container(
                    //       height: 45,
                    //       margin: EdgeInsets.only(left: 15, right: 15, bottom: 60),
                    //       decoration: BoxDecoration(
                    //           color: AppTheme.colors.newPrimary,
                    //           borderRadius: BorderRadius.circular(2)
                    //       ),
                    //       child: Center(
                    //         child: Text("Save",
                    //           style: TextStyle(
                    //               color: AppTheme.colors.newWhite,
                    //               fontSize: 12,
                    //               fontFamily: "AppFont",
                    //               fontWeight: FontWeight.bold
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
