import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../apis/google_api.dart';
import '../../../../models/activity_model.dart';

Future<LocationActivity?> showInputAutocomplete(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => InputAddress(),
  );
}

class InputAddress extends StatefulWidget {
  @override
  _InputAddressState createState() => _InputAddressState();
}

class _InputAddressState extends State<InputAddress> {
  List<dynamic> _places = [];
  Timer? _debounce;

  Future<void> _searchAddress(String value) async {
    try {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(Duration(seconds: 1), () async {
        if (value.isNotEmpty) {
          print(value);
          _places = await getAutocompleteSuggestions(value);
          setState(() {});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {} catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Rechercher',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchAddress,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (_, i) {
                var place = _places[i];
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(place.description),
                  onTap: () => getPlaceDetails(place.placeId),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
