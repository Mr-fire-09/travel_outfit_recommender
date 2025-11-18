import 'package:flutter/material.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  String _season = 'Summer';
  late AnimationController _ctrl;
  late List<Particle> particles;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    particles = List.generate(30, (i) => Particle.random(_rnd));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Map season to button color
  Color getButtonColor() {
    switch (_season) {
      case 'Winter':
        return Colors.black;
      case 'Summer':
        return Colors.yellow.shade700;
      case 'Rainy':
        return Colors.blue.shade700;
      case 'Spring':
        return Colors.green.shade600;
      case 'Autumn':
        return Colors.deepOrange.shade700;
      default:
        return Colors.redAccent;
    }
  }

  Color getTextColor() {
    return (_season == 'Summer' || _season == 'Spring')
        ? Colors.black
        : Colors.white;
  }

  void _showRandomOutfitDialog() {
    final outfits = [
      'T-shirt, Shorts, Sneakers',
      'Raincoat, Boots, Umbrella',
      'Sweater, Jeans, Scarf',
      'Dress, Sandals, Hat',
      'Jacket, Trousers, Beanie',
    ];
    final suggestion = outfits[_rnd.nextInt(outfits.length)];
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

  Widget _buildSeasonSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _season,
          dropdownColor: Colors.black87,
          items: const [
            DropdownMenuItem(value: 'Summer', child: Text('Summer')),
            DropdownMenuItem(value: 'Winter', child: Text('Winter')),
            DropdownMenuItem(value: 'Spring', child: Text('Spring')),
            DropdownMenuItem(value: 'Autumn', child: Text('Autumn')),
            DropdownMenuItem(value: 'Rainy', child: Text('Rainy')),
          ],
          onChanged: (val) => setState(() => _season = val ?? 'Summer'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = getButtonColor();
    final textColor = getTextColor();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedGradient(
            animation: _ctrl,
            season: _season,
          ),

          // Particle / weather simulation layer
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              // update particles positions
              for (final p in particles) p.update(_ctrl.value, _season);
              return CustomPaint(
                painter: ParticlePainter(particles, season: _season),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated title
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                        CurvedAnimation(
                            parent: _ctrl,
                            curve: const Interval(0.0, 0.25,
                                curve: Curves.easeInOut))),
                    child: FadeTransition(
                      opacity:
                          Tween<double>(begin: 0.8, end: 1.0).animate(_ctrl),
                      child: Column(
                        children: [
                          Icon(Icons.checkroom, size: 96, color: buttonColor),
                          const SizedBox(height: 12),
                          Text(
                            'Welcome to Your Wardrobe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              shadows: [
                                Shadow(
                                    blurRadius: 8,
                                    color: buttonColor.withOpacity(0.6),
                                    offset: const Offset(0, 2)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // season selector
                  _buildSeasonSelector(),

                  const SizedBox(height: 20),

                  // animated primary button
                  AnimatedButton(
                    color: buttonColor,
                    textColor: textColor,
                    label: 'Get Started',
                    onPressed: () {
                      // small burst animation simulated by changing particles
                      for (var i = 0; i < 20; i++)
                        particles.add(Particle.random(_rnd, burst: true));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OutfitFormPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // secondary action
                  OutlinedButton.icon(
                    onPressed: _showRandomOutfitDialog,
                    icon: const Icon(Icons.shuffle, color: Colors.white),
                    label: const Text('Random Outfit',
                        style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // author name
                  Text(
                    'Created by Neeraj Singh',
                    style: TextStyle(
                        color: textColor.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Supporting animated widgets & particle simulation ---------- */

class AnimatedGradient extends StatelessWidget {
  final Animation<double> animation;
  final String season;
  const AnimatedGradient(
      {required this.animation, required this.season, super.key});

  List<Color> _colorsForSeason() {
    switch (season) {
      case 'Winter':
        return [Colors.black, Colors.blueGrey.shade900];
      case 'Summer':
        return [Colors.black, Colors.yellow.shade700];
      case 'Rainy':
        return [Colors.black, Colors.blue.shade700];
      case 'Spring':
        return [Colors.black, Colors.green.shade600];
      case 'Autumn':
        return [Colors.black, Colors.deepOrange.shade700];
      default:
        return [Colors.black, Colors.redAccent];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForSeason();
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = (sin(animation.value * 2 * pi) + 1) / 2;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(colors[0], colors[1], t) ?? colors[0],
                Color.lerp(colors[1], colors[0], t) ?? colors[1],
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final String label;
  const AnimatedButton(
      {required this.color,
      required this.textColor,
      required this.onPressed,
      required this.label,
      super.key});
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 1.0, end: 1.03)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    return ScaleTransition(
      scale: scale,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: widget.textColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 10,
        ),
        onPressed: widget.onPressed,
        child: Text(widget.label,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.textColor)),
      ),
    );
  }
}

/* Simple particle model to simulate rain/snow/bubbles */
class Particle {
  Offset pos;
  double size;
  double speed;
  Color color;
  double drift;

  Particle(
      {required this.pos,
      required this.size,
      required this.speed,
      required this.color,
      required this.drift});

  factory Particle.random(Random rnd, {bool burst = false}) {
    return Particle(
      pos: Offset(rnd.nextDouble(), rnd.nextDouble()),
      size: burst ? (2 + rnd.nextDouble() * 6) : (1 + rnd.nextDouble() * 4),
      speed: burst
          ? (0.5 + rnd.nextDouble() * 2)
          : (0.01 + rnd.nextDouble() * 0.06),
      color: Colors.white.withOpacity(0.85),
      drift: (rnd.nextDouble() - 0.5) * 0.2,
    );
  }

  void update(double t, String season) {
    // Move particle depending on season
    switch (season) {
      case 'Rainy':
        pos = Offset(pos.dx + drift * 0.02, pos.dy + speed * 2);
        break;
      case 'Winter':
        pos = Offset(pos.dx + drift * 0.01, pos.dy + speed * 0.5);
        break;
      case 'Summer':
        pos = Offset(
            pos.dx + drift * 0.01, pos.dy - speed * 0.4); // rising bubbles
        break;
      default:
        pos = Offset(pos.dx + drift * 0.01, pos.dy + speed * 0.5);
    }
    if (pos.dy > 1.2) pos = Offset(Random().nextDouble(), -0.2);
    if (pos.dy < -0.3) pos = Offset(Random().nextDouble(), 1.2);
    if (pos.dx < -0.3 || pos.dx > 1.3)
      pos = Offset(Random().nextDouble(), pos.dy);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final String season;
  ParticlePainter(this.particles, {required this.season});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final cx = p.pos.dx * size.width;
      final cy = p.pos.dy * size.height;
      if (season == 'Rainy') {
        paint.color = Colors.white.withOpacity(0.12);
        canvas.drawLine(
            Offset(cx - 2, cy - 8),
            Offset(cx + 2, cy + 8),
            paint
              ..strokeWidth = 2.0
              ..strokeCap = StrokeCap.round);
      } else if (season == 'Winter') {
        paint.color = Colors.white.withOpacity(0.9);
        canvas.drawCircle(Offset(cx, cy), p.size, paint);
      } else if (season == 'Summer') {
        paint.color = Colors.yellow.withOpacity(0.25 + p.size * 0.03);
        canvas.drawCircle(Offset(cx, cy), p.size + 2, paint);
      } else {
        paint.color = Colors.white.withOpacity(0.08 + p.size * 0.02);
        canvas.drawCircle(Offset(cx, cy), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
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
