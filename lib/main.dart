import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Explicit Animation Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExplicitAnimationDemo(),
    );
  }
}

class ExplicitAnimationDemo extends StatefulWidget {
  const ExplicitAnimationDemo({super.key});

  @override
  State<ExplicitAnimationDemo> createState() => _ExplicitAnimationDemoState();
}

// STEP 1: Mixin Add Karna - Yeh screen refresh ke saath sync karega
class _ExplicitAnimationDemoState extends State<ExplicitAnimationDemo>
    with SingleTickerProviderStateMixin {
  // STEP 2: Variables Declare Karna
  late AnimationController _controller; // Animation ka remote control
  late Animation<double> _sizeAnimation; // Size change animation
  late Animation<Color?> _colorAnimation; // Color change animation
  late Animation<double> _rotationAnimation; // Rotation animation

  // Animation status track karne ke liye
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // STEP 3: AnimationController Initialize Karna
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation 2 second tak chalegi
      vsync:
          this, // Screen refresh rate ke saath sync (Mixin ki wajah se 'this' use ho raha)
    );

    // STEP 4: Multiple Tweens Create Karna

    // 1. SIZE Animation: 50 se 150 tak
    _sizeAnimation = Tween<double>(begin: 50.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth movement
      ),
    );

    // 2. COLOR Animation: Blue se Red tak
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 3. ROTATION Animation: 0 se 360 degrees tak
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.1416, // 360 degrees in radians (π = 3.1416)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Listener lagana taki UI update ho
    _controller.addListener(() {
      setState(() {
        // Jab animation value change hoti hai, UI rebuild hoga
      });
    });

    // Animation complete hone par notification
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  // STEP 5: Play/Pause Animation Function
  void _toggleAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
      _isPlaying = false;
    } else {
      _controller.repeat(reverse: true);
      _isPlaying = true;
    }
    setState(() {});
  }

  // STEP 6: Forward Animation Function
  void _playForward() {
    _controller.forward();
    _isPlaying = true;
    setState(() {});
  }

  // STEP 7: Reset Animation Function
  void _resetAnimation() {
    _controller.reset();
    _isPlaying = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animation Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // STEP 8: AnimatedBuilder Use Karna
            // Yeh automatically rebuild hoga jab animation value change hogi
            AnimatedBuilder(
              animation: _controller, // Listen to controller
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value, // Rotation value
                  child: Container(
                    width: _sizeAnimation.value, // Current size value
                    height: _sizeAnimation.value,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value, // Current color value
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flutter_dash,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Animation Info Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    'Animation Status:',
                    _isPlaying ? 'Playing ▶️' : 'Stopped ⏸️',
                  ),
                  _buildInfoRow(
                    'Size:',
                    '${_sizeAnimation.value.toStringAsFixed(1)}',
                  ),
                  _buildInfoRow(
                    'Rotation:',
                    '${(_rotationAnimation.value * 180 / 3.1416).toStringAsFixed(1)}°',
                  ),
                  _buildInfoRow(
                    'Progress:',
                    '${(_controller.value * 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // STEP 9: Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play Button
                ElevatedButton.icon(
                  onPressed: _playForward,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text(
                    'Play Once',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 20),

                // Toggle Button
                ElevatedButton.icon(
                  onPressed: _toggleAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.repeat,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isPlaying ? 'Pause Loop' : 'Loop Animation',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 20),

                // Reset Button
                ElevatedButton.icon(
                  onPressed: _resetAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for info display
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }

  // STEP 10: Cleanup (Important!)
  @override
  void dispose() {
    _controller.dispose(); // Memory leak se bachne ke liye
    super.dispose();
  }
}
