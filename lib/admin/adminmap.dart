import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungexercies/utility/my_style.dart';

class AdminMap extends StatefulWidget {
  final DocumentSnapshot message;
  AdminMap({@required this.message});

  @override
  _AdminMapState createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  double lat;
  double lng;
  double screen;
  BitmapDescriptor policeIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat = widget.message['lat'];
    lng = widget.message['lng'];
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64,64)), 'images/customer.png').then((value){
          policeIcon =value;
        });
  }

  @override
 
  Widget build(BuildContext context) {
     screen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              lat == null ? MyStyle().showProgress() : showMap(lat, lng)
            ],
          ),
        ),
      ),
    );
  }

  Widget showMap(double lat, double lng) {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    Marker userMarer() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(lat, lng),
        icon: policeIcon,
        // defaultMarkerWithHue(60.0),
         infoWindow: InfoWindow(title: 'ลูกค้าอยู่ตรงนี้จ้า'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[userMarer()].toSet();
    }

    return Container(
      height: screen*0.8,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: mySet(),
      ),
    );
  }
}
