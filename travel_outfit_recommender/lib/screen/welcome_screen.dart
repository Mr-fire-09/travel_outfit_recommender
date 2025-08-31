import 'package:flutter/material.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _season = 'Summer';

  // Map season to button color
  Color getButtonColor() {
    switch (_season) {
      case 'Winter':
        return Colors.black;
      case 'Summer':
        return Colors.yellow.shade700;
      case 'Rainy':
        return Colors.blue;
      case 'Spring':
        return Colors.green;
      case 'Autumn':
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  Color getTextColor() {
    return (_season == 'Summer') ? Colors.black : Colors.white;
  }

  void _showRandomOutfitDialog() {
    final outfits = [
      'T-shirt, Shorts, Sneakers',
      'Raincoat, Boots, Umbrella',
      'Sweater, Jeans, Scarf',
      'Dress, Sandals, Hat',
      'Jacket, Trousers, Beanie',
    ];
    final random = Random();
    final suggestion = outfits[random.nextInt(outfits.length)];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Random Outfit Suggestion'),
        content: Text(suggestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.redAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 110,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 30),
              const Text(
                'Travel Outfit\nRecommender',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.redAccent,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Season dropdown for demo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButtonFormField<String>(
                  value: _season,
                  dropdownColor: Colors.black87,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Select Season',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem(value: 'Summer', child: Text('Summer')),
                    DropdownMenuItem(value: 'Winter', child: Text('Winter')),
                    DropdownMenuItem(value: 'Spring', child: Text('Spring')),
                    DropdownMenuItem(value: 'Autumn', child: Text('Autumn')),
                    DropdownMenuItem(value: 'Rainy', child: Text('Rainy')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _season = val!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: getButtonColor(),
                  foregroundColor: getTextColor(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OutfitFormPage(),
                    ),
                  );
                },
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                icon: const Icon(Icons.shuffle, color: Colors.white),
                label: const Text(
                  'Random Outfit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: _showRandomOutfitDialog,
              ),
              const SizedBox(height: 60),
              const Text(
                'Created by Neeraj Singh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black54,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// OutfitFormPage definition starts here (same file)
class OutfitFormPage extends StatefulWidget {
  const OutfitFormPage({super.key});

  @override
  State<OutfitFormPage> createState() => _OutfitFormPageState();
}

class _OutfitFormPageState extends State<OutfitFormPage> {
  final _formKey = GlobalKey<FormState>();
  String destination = '';
  String _season = 'Summer';
  String _location = 'Beach';
  String _purpose = 'Vacation';
  String _selectedGender = 'All';
  bool _includeAccessories = true;

  final List<String> _seasons = ['Summer', 'Winter', 'Spring', 'Autumn'];
  final List<String> _locations = ['Beach', 'City', 'Mountain'];
  final List<String> _purposes = ['Vacation', 'Business', 'Casual'];
  final List<String> _genders = ['All', 'Male', 'Female'];

  Map<String, List<String>> outfitSuggestions = {};

  void _generateOutfits() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_selectedGender == 'All') {
          outfitSuggestions = {
            'Male': _getOutfit('Male', _season, _location, _purpose),
            'Female': _getOutfit('Female', _season, _location, _purpose),
          };
        } else {
          outfitSuggestions = {
            _selectedGender: _getOutfit(
              _selectedGender,
              _season,
              _location,
              _purpose,
            ),
          };
        }
      });
    }
  }

  List<String> _getOutfit(
    String gender,
    String season,
    String location,
    String purpose,
  ) {
    List<String> outfit = [];

    if (gender == 'Male') {
      if (season == 'Winter') {
        outfit = ['Thermal shirt', 'Jeans', 'Parka', 'Boots'];
      } else if (location == 'Beach') {
        outfit = ['Tank top', 'Shorts', 'Flip-flops'];
      } else if (purpose == 'Business') {
        outfit = ['Blazer', 'Dress shirt', 'Slacks', 'Oxfords'];
      } else {
        outfit = ['T-shirt', 'Shorts', 'Sneakers'];
      }
    } else {
      if (season == 'Winter') {
        outfit = ['Wool coat', 'Leggings', 'Boots'];
      } else if (location == 'Beach') {
        outfit = ['Swimsuit', 'Sundress', 'Sandals'];
      } else if (purpose == 'Business') {
        outfit = ['Blouse', 'Blazer', 'Skirt or Slacks', 'Heels'];
      } else {
        outfit = ['Top', 'Skirt or Jeans', 'Flats'];
      }
    }

    if (_includeAccessories) {
      if (season == 'Winter') {
        outfit.addAll(['Scarf', 'Gloves', 'Beanie']);
      } else if (location == 'Beach') {
        outfit.addAll(['Sunglasses', 'Hat', 'Beach bag']);
      } else if (purpose == 'Business') {
        outfit.addAll(['Watch', 'Belt']);
      }
    }

    return outfit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outfit Recommender')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Destination',
                            prefixIcon: Icon(Icons.place),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a destination';
                            }
                            return null;
                          },
                          onChanged: (value) => destination = value,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Season',
                            prefixIcon: Icon(Icons.wb_sunny),
                          ),
                          value: _season,
                          items: _seasons
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _season = val!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Location Type',
                            prefixIcon: Icon(Icons.landscape),
                          ),
                          value: _location,
                          items: _locations
                              .map(
                                (l) => DropdownMenuItem(
                                  value: l,
                                  child: Text(l),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _location = val!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Purpose',
                            prefixIcon: Icon(Icons.category),
                          ),
                          value: _purpose,
                          items: _purposes
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _purpose = val!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.person),
                          ),
                          value: _selectedGender,
                          items: _genders
                              .map(
                                (g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedGender = val!),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Include Accessories'),
                          value: _includeAccessories,
                          onChanged: (val) =>
                              setState(() => _includeAccessories = val),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _generateOutfits,
                  icon: const Icon(Icons.style),
                  label: const Text('Suggest Outfit'),
                ),
                const SizedBox(height: 20),
                if (outfitSuggestions.isNotEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: outfitSuggestions.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${entry.key} Outfit:",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.teal,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(item),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
