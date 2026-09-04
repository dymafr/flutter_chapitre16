import 'dart:async';

import 'package:flutter/material.dart';

import '../../../apis/google_api.dart';
import '../../../models/activity_model.dart';
import '../../../models/place_model.dart';

Future<LocationActivity?> showInputAutocomplete(BuildContext context) {
  return showDialog<LocationActivity>(
    context: context,
    builder: (_) => const InputAddress(),
  );
}

class InputAddress extends StatefulWidget {
  const InputAddress({super.key});

  @override
  State<InputAddress> createState() => _InputAddressState();
}

class _InputAddressState extends State<InputAddress> {
  List<Place> _places = [];
  Timer? _debounce;

  Future<void> _searchAddress(String value) async {
    try {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () async {
        if (value.isNotEmpty) {
          final places = await getAutocompleteSuggestions(value);
          if (!mounted) return;
          setState(() => _places = places);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return;
    try {
      LocationActivity location = await getPlaceDetailsApi(placeId);
      if (mounted) {
        Navigator.pop(context, location);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rechercher',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchAddress,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (_, i) {
                var place = _places[i];
                return ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(place.description),
                  onTap: () => getPlaceDetails(place.placeId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
