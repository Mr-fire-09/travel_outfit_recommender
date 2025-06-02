import 'package:flutter/material.dart';

void main() {
  runApp(const OutfitApp());
}

class OutfitApp extends StatelessWidget {
  const OutfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Outfit Recommender',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const OutfitFormPage(),
    );
  }
}

class OutfitFormPage extends StatefulWidget {
  const OutfitFormPage({super.key});

  @override
  State<OutfitFormPage> createState() => _OutfitFormPageState();
}

class _OutfitFormPageState extends State<OutfitFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _destination = '';
  String _season = 'Summer';
  String _location = 'Beach';
  String _purpose = 'Vacation';

  final List<String> _seasons = ['Summer', 'Winter', 'Spring', 'Autumn'];
  final List<String> _locations = ['Beach', 'City', 'Mountain'];
  final List<String> _purposes = ['Vacation', 'Business', 'Casual'];

  Map<String, List<String>> outfitSuggestions = {};

  void _generateOutfits() {
    String key = '$_season-$_location-$_purpose';
    setState(() {
      outfitSuggestions = {
        'Male': _getOutfit('Male', _season, _location, _purpose),
        'Female': _getOutfit('Female', _season, _location, _purpose),
      };
    });
  }

  List<String> _getOutfit(
    String gender,
    String season,
    String location,
    String purpose,
  ) {
    if (gender == 'Male') {
      if (season == 'Winter')
        return ['Thermal shirt', 'Jeans', 'Parka', 'Boots', 'Gloves'];
      if (location == 'Beach')
        return ['Tank top', 'Shorts', 'Flip-flops', 'Sunglasses'];
      if (purpose == 'Business')
        return ['Blazer', 'Dress shirt', 'Slacks', 'Oxfords'];
      return ['T-shirt', 'Shorts', 'Sneakers'];
    } else {
      if (season == 'Winter')
        return ['Wool coat', 'Leggings', 'Boots', 'Scarf', 'Gloves'];
      if (location == 'Beach')
        return ['Swimsuit', 'Sundress', 'Sandals', 'Hat'];
      if (purpose == 'Business')
        return ['Blouse', 'Blazer', 'Skirt or Slacks', 'Heels'];
      return ['Top', 'Skirt or Jeans', 'Flats'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outfit Recommender')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Destination'),
                onChanged: (value) => _destination = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Season'),
                value: _season,
                items:
                    _seasons
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (val) => setState(() => _season = val!),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Location Type'),
                value: _location,
                items:
                    _locations
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                onChanged: (val) => setState(() => _location = val!),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Purpose'),
                value: _purpose,
                items:
                    _purposes
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                onChanged: (val) => setState(() => _purpose = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateOutfits,
                child: const Text('Suggest Outfit'),
              ),
              const SizedBox(height: 20),
              if (outfitSuggestions.isNotEmpty)
                ...outfitSuggestions.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${entry.key} Outfit:",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...entry.value.map((item) => Text("• $item")),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
