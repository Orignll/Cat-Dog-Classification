import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat vs Dog Classifier',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash Screen dengan animasi loading
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Inisialisasi animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Mulai animasi secara berurutan
    _startAnimations();
  }

  void _startAnimations() async {
    // Mulai fade dan scale bersamaan
    _fadeController.forward();
    _scaleController.forward();

    // Delay untuk rotation
    await Future.delayed(const Duration(milliseconds: 500));
    _rotationController.repeat();

    // Delay untuk slide text
    await Future.delayed(const Duration(milliseconds: 300));
    _slideController.forward();

    // Navigasi ke halaman utama setelah 3.5 detik
    await Future.delayed(const Duration(milliseconds: 2700));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const ImageClassifier(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade800,
              Colors.blue.shade700,
              Colors.indigo.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo dan icon animasi
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationAnimation.value * 3.14159,
                                child: const Icon(
                                  Icons.pets,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Title animasi
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Cat vs Dog',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Classifier',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🐱', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: 20),
                          Container(
                            width: 40,
                            height: 2,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 20),
                          const Text('🐶', style: TextStyle(fontSize: 32)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Loading indicator animasi
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Memuat aplikasi...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageClassifier extends StatefulWidget {
  const ImageClassifier({super.key});

  @override
  State<ImageClassifier> createState() => _ImageClassifierState();
}

class _ImageClassifierState extends State<ImageClassifier>
    with SingleTickerProviderStateMixin {
  File? _image;
  String _result = '';
  double _confidence = 0.0;
  bool _isLoading = false;
  bool _showResult = false;
  Interpreter? _interpreter;
  List<String>? _labels;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();

    // Inisialisasi controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Mulai animasi repeating untuk placeholder
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _interpreter?.close();
    super.dispose();
  }

  // Memuat model TFLite dan file label
  Future<void> _loadModelAndLabels() async {
    try {
      // Coba cara 1: Menggunakan path 'assets/model.tflite'
      try {
        _interpreter = await Interpreter.fromAsset(
          'assets/models/cat_dog_model.tflite',
        );
        print(
          'Model berhasil dimuat dengan path assets/models/cat_dog_model.tflite',
        );
      } catch (assetError) {
        print('Error dengan path assets/model.tflite: $assetError');
        // Coba cara 2: Menggunakan path 'model.tflite'
        _interpreter = await Interpreter.fromAsset('model.tflite');
        print('Model berhasil dimuat dengan path cat_dog_model.tflite');
      }

      // Muat file labels
      try {
        final labelsData = await DefaultAssetBundle.of(
          context,
        ).loadString('assets/models/labels.txt');
        _labels = labelsData.split('\n');
        print('Labels berhasil dimuat.');
      } catch (e) {
        print('Error memuat labels: $e');
        // Gunakan label default jika file tidak ditemukan
        _labels = ['dog', 'cat'];
      }
    } catch (e) {
      print('Error memuat model: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memuat model: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  // Memproses gambar dan menjalankan inferensi
  Future<void> _classifyImage(File imageFile) async {
    if (_interpreter == null || _labels == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Model belum siap. Silakan coba lagi.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
      _confidence = 0.0;
      _showResult = false;
    });

    try {
      // 1. Baca dan decode gambar
      img.Image? originalImage = img.decodeImage(await imageFile.readAsBytes());
      if (originalImage == null) {
        throw Exception('Gagal membaca gambar');
      }

      // 2. Resize gambar ke ukuran input model (224x224)
      img.Image resizedImage = img.copyResize(
        originalImage,
        width: 224,
        height: 224,
      );

      // 3. Konversi gambar ke format yang diterima model dan normalisasi piksel
      var input = List.generate(
        1,
        (index) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            var pixel = resizedImage.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      // Siapkan output tensor - PERBAIKAN: Sesuaikan dengan output model [1, 1]
      var output = List.filled(1, 0.0).reshape([1, 1]);

      // 4. Jalankan inferensi
      _interpreter!.run(
        input,
        output,
      ); // 5. Interpretasi hasil - PERBAIKAN: Untuk model binary classification
      double score = output[0][0];

      // Debug: Print output untuk memahami model
      print('Output score: $score');

      // PERBAIKAN: Logika terbalik - model Anda menggunakan:
      // - Score mendekati 0.0 = Class 0 (Cat)
      // - Score mendekati 1.0 = Class 1 (Dog)
      bool isCat = score < 0.5; // Dibalik dari sebelumnya
      double confidence = isCat ? (1 - score) * 100 : score * 100;
      String prediction = isCat ? 'CAT' : 'DOG';

      // Efek animasi saat menampilkan hasil
      await Future.delayed(const Duration(milliseconds: 600));

      setState(() {
        _result = prediction;
        _confidence = confidence;
        _isLoading = false;
        _showResult = true;
        _animationController.reset();
        _animationController.forward();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error: $e';
        _confidence = 0.0;
        _showResult = true;
      });
      print('Error klasifikasi: $e');
    }
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 95,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _showResult = false;
        });

        // Mulai animasi loading
        _animationController.reset();
        _animationController.repeat();

        // Klasifikasi gambar
        _classifyImage(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saat memilih gambar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Helper function untuk mendapatkan icon berdasarkan confidence level
  String _getConfidenceIcon(double confidence) {
    if (confidence >= 90) {
      return '🔥'; // Very high confidence
    } else if (confidence >= 80) {
      return '✨'; // High confidence
    } else if (confidence >= 70) {
      return '👍'; // Good confidence
    } else if (confidence >= 60) {
      return '🤔'; // Medium confidence
    } else {
      return '🤷'; // Low confidence
    }
  }

  // Membangun kartu hasil
  Widget _buildResultCard() {
    final isCat = _result.toLowerCase().contains('cat');

    // Pilih tema berdasarkan hasil
    final themeColor = isCat ? Colors.orange : Colors.blue;
    final emoji = isCat ? '🐱' : '🐶';
    final gradientColors =
        isCat
            ? [Colors.orange.shade300, Colors.deepOrange.shade600]
            : [Colors.blue.shade300, Colors.indigo.shade600];

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(_animation),
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Deteksi:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _result,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getConfidenceIcon(_confidence),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Akurasi: ${_confidence.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar untuk confidence
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tingkat Keyakinan:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${_confidence.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _confidence / 100,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _confidence >= 80
                              ? Colors.green.shade300
                              : _confidence >= 60
                              ? Colors.yellow.shade300
                              : Colors.orange.shade300,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCat
                      ? 'Ini adalah seekor kucing! 🐈'
                      : 'Ini adalah seekor anjing! 🐕',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Info Menarik
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: const Text('Info Menarik'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                InfoPage(animalType: isCat ? 'Cat' : 'Dog'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cat vs Dog Classifier',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  const Text(
                    '🐱 or 🐶',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Klasifikasi gambar kucing & anjing',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 30),

                  // Gambar yang dipilih atau placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child:
                          _image == null
                              ? _buildPlaceholder()
                              : Hero(
                                tag: 'preview',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Loading atau hasil
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        _isLoading
                            ? _buildLoadingIndicator()
                            : _showResult && _result.isNotEmpty
                            ? _buildResultCard()
                            : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 30),

                  // Tombol pilih gambar
                  _buildImageSourceButtons(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0.8, end: 1.0),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale + (0.1 * (_animationController.value % 1)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.grey.shade400.withOpacity(
                          0.6 + (0.4 * (_animationController.value % 1)),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: 0.7 + (0.3 * (_animationController.value % 1)),
                child: Text(
                  'Pilih gambar kucing atau anjing',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: 0.5 + (0.3 * (_animationController.value % 1)),
                child: Text(
                  'untuk klasifikasi',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer rotating circle
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * 3.14159,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Inner container with icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (0.1 * (_animationController.value % 1)),
                      child: Icon(
                        Icons.pets,
                        size: 36,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Pulsing effect
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 80 + (20 * (_animationController.value % 1)),
                  height: 80 + (20 * (_animationController.value % 1)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(
                      0.1 * (1 - (_animationController.value % 1)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Animated text
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.7 + (0.3 * (_animationController.value % 1)),
              child: const Text(
                'Menganalisis gambar...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        // Loading dots animation
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                double animationValue =
                    (_animationController.value * 3 - index) % 3;
                double opacity =
                    animationValue < 1 ? animationValue : 2 - animationValue;
                opacity = opacity.clamp(0.3, 1.0);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(opacity),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageSourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImageButton(
          label: 'Galeri',
          icon: Icons.photo_library_rounded,
          color: Colors.green.shade600,
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        _buildImageButton(
          label: 'Kamera',
          icon: Icons.camera_alt_rounded,
          color: Colors.purple.shade600,
          onTap: () => _pickImage(ImageSource.camera),
        ),
      ],
    );
  }

  Widget _buildImageButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          tween: Tween(begin: 1.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTapDown: (_) {
                  // Scale down saat ditekan
                },
                onTapUp: (_) {
                  // Scale kembali normal
                },
                onTap: onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.8), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.8 + (0.2 * value),
                            child: Icon(icon, size: 36, color: Colors.white),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Halaman untuk menampilkan fakta menarik
class InfoPage extends StatelessWidget {
  final String animalType;

  const InfoPage({super.key, required this.animalType});

  // Daftar fakta menarik tentang kucing
  final List<String> catFacts = const [
    "🐱 Kucing dapat membuat sekitar 100 suara yang berbeda. Anjing hanya bisa membuat sekitar 10.",
    "👃 Setiap hidung kucing memiliki pola unik, seperti sidik jari manusia.",
    "😴 Kucing tidur rata-rata 13-14 jam sehari.",
    "🍯 Kucing tidak bisa merasakan rasa manis.",
    "👥 Kelompok kucing disebut 'clowder'.",
    "🎂 Kucing tertua yang pernah ada berumur 38 tahun!",
    "🏃 Kucing dapat melompat hingga 6 kali panjang tubuhnya.",
    "🌙 Kucing lebih aktif di malam hari (nokturnal).",
    "💧 Kucing mendapat sebagian besar air dari makanannya.",
    "🔊 Dengkuran kucing dapat membantu menyembuhkan tulang yang patah.",
  ];

  // Daftar fakta menarik tentang anjing
  final List<String> dogFacts = const [
    "👃 Indra penciuman anjing 40 kali lebih baik dari manusia.",
    "🏥 Anjing dapat dilatih untuk mendeteksi kanker dan penyakit lain pada manusia.",
    "👂 Anjing memiliki sekitar 18 otot untuk menggerakkan telinganya.",
    "🔍 Jejak hidung anjing juga unik, seperti sidik jari.",
    "🎵 The Beatles memasukkan suara peluit anjing di akhir lagu 'A Day in the Life'.",
    "🎭 Anjing Basenji tidak menggonggong, tetapi mereka bisa 'yodel'.",
    "💭 Anjing bermimpi seperti manusia.",
    "❤️ Anjing dapat merasakan emosi manusia melalui bau.",
    "🎾 Anjing dapat belajar hingga 250 kata dan gerakan.",
    "🌈 Anjing dapat melihat warna biru dan kuning, tetapi tidak merah dan hijau.",
  ];

  @override
  Widget build(BuildContext context) {
    final facts = animalType.toLowerCase() == 'cat' ? catFacts : dogFacts;
    final themeColor =
        animalType.toLowerCase() == 'cat' ? Colors.orange : Colors.blue;
    final emoji = animalType.toLowerCase() == 'cat' ? '🐱' : '🐶';
    final animalName = animalType.toLowerCase() == 'cat' ? 'Kucing' : 'Anjing';

    return Scaffold(
      appBar: AppBar(
        title: Text('Fakta Menarik $emoji'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeColor.shade300, themeColor.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeColor.withOpacity(0.1), Colors.grey.shade50],
          ),
        ),
        child: Column(
          children: [
            // Header dengan emoji besar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 10),
                  Text(
                    'Fakta Menarik tentang $animalName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeColor.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tahukah kamu? Ada banyak hal menarik tentang $animalName!',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Daftar fakta
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: facts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    shadowColor: themeColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            Colors
                                .white, // Hapus gradient, gunakan warna putih solid
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: themeColor.withOpacity(0.15),
                          child: Text(
                            '#${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeColor.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        title: Text(
                          facts[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Semoga fakta-fakta ini menambah pengetahuanmu! 📚',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
