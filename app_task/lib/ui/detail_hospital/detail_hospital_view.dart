import 'package:app_task/model/hospital.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailHospitalView extends StatefulWidget {
  final Hospital hospital;

  DetailHospitalView({
    this.hospital,
  });

  @override
  _DetailHospitalViewState createState() => _DetailHospitalViewState();
}

class _DetailHospitalViewState extends State<DetailHospitalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Hospital'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Hospital Name'),
              subtitle: Text(widget.hospital.name),
            ),
            ListTile(
              title: Text('Hospital Address'),
              subtitle: Text(widget.hospital.address),
            ),
            ListTile(
              title: Text('Hospital Description'),
              subtitle: Text(widget.hospital.description),
            ),
            ListTile(
              title: Text('Hospital LatLong'),
              subtitle: Text('${widget.hospital.latitude}, ${widget.hospital.longitude}'),
            ),
            SizedBox(
              height: 400.0,
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.tryParse(widget.hospital.latitude), double.parse(widget.hospital.longitude)), zoom: 17.0),
                  markers: Set<Marker>.of(<Marker>[
                    Marker(
                      markerId: MarkerId(widget.hospital.id),
                      position: LatLng(double.parse(widget.hospital.latitude), double.parse(widget.hospital.longitude)),
                      infoWindow: InfoWindow(
                          title: widget.hospital.name, snippet: widget.hospital.address),
                    ),
                  ]),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                      () => ScaleGestureRecognizer(),
                    ),
                  ].toSet()),
            ),
          ],
        ),
      ),
    );
  }
}
