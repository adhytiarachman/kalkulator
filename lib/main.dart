import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Calculator',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
    );
  }
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getResponsiveWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.of(context).size.width;
    if (isTablet(context)) return MediaQuery.of(context).size.width * 0.6;
    return 400; // Desktop max width
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return EdgeInsets.all(20);
    if (isTablet(context)) return EdgeInsets.all(40);
    return EdgeInsets.all(60);
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _controller.forward();

    Timer(Duration(milliseconds: 800), () {
      _pulseController.repeat(reverse: true);
    });

    Timer(Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              KalkulatorPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: isMobile ? 120 : 160,
                              height: isMobile ? 120 : 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00d4ff),
                                    Color(0xFF007cf0),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF007cf0).withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.calculate_rounded,
                                color: Colors.white,
                                size: isMobile ? 60 : 80,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isMobile ? 30 : 50),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Professional',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 42,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'CALCULATOR',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00d4ff),
                    letterSpacing: 4.0,
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 50 : 70),
              FadeTransition(
                opacity: _fadeAnimation,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00d4ff)),
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage>
    with TickerProviderStateMixin {
  String _input = "";
  String _output = "";
  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void tekanTombol(String nilai) {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    setState(() {
      if (nilai == "C") {
        _input = "";
        _output = "";
      } else if (nilai == "⌫") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (nilai == "=") {
        try {
          _output = _hitung(_input);
        } catch (e) {
          _output = "Error";
        }
      } else {
        _input += nilai;
      }
    });
  }

  String _hitung(String ekspresi) {
    if (ekspresi.isEmpty) return "";

    ekspresi = ekspresi.replaceAll('×', '*').replaceAll('÷', '/');
    try {
      final hasil = _eval(ekspresi);
      if (hasil == hasil.toInt()) {
        return hasil.toInt().toString();
      } else {
        return hasil
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return "Error";
    }
  }

  double _eval(String exp) {
    exp = exp.replaceAll(' ', '');
    if (exp.isEmpty) return 0;

    List<String> numbers = [];
    List<String> operators = [];
    String currentNumber = '';

    for (int i = 0; i < exp.length; i++) {
      String char = exp[i];
      if ('+-*/'.contains(char)) {
        if (currentNumber.isNotEmpty) {
          numbers.add(currentNumber);
          currentNumber = '';
        }
        operators.add(char);
      } else {
        currentNumber += char;
      }
    }
    if (currentNumber.isNotEmpty) {
      numbers.add(currentNumber);
    }

    if (numbers.isEmpty) return 0;

    double result = double.parse(numbers[0]);
    for (int i = 0; i < operators.length; i++) {
      double nextNumber = double.parse(numbers[i + 1]);
      switch (operators[i]) {
        case '+':
          result += nextNumber;
          break;
        case '-':
          result -= nextNumber;
          break;
        case '*':
          result *= nextNumber;
          break;
        case '/':
          if (nextNumber != 0) {
            result /= nextNumber;
          } else {
            throw Exception('Division by zero');
          }
          break;
      }
    }
    return result;
  }

  final List<Map<String, dynamic>> tombol = [
    {'text': 'C', 'color': Color(0xFFff6b6b), 'textColor': Colors.white},
    {'text': '⌫', 'color': Color(0xFF4ecdc4), 'textColor': Colors.white},
    {'text': '', 'color': Colors.transparent, 'textColor': Colors.transparent},
    {'text': '÷', 'color': Color(0xFF007cf0), 'textColor': Colors.white},

    {'text': '7', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '8', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '9', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '×', 'color': Color(0xFF007cf0), 'textColor': Colors.white},

    {'text': '4', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '5', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '6', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '-', 'color': Color(0xFF007cf0), 'textColor': Colors.white},

    {'text': '1', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '2', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '3', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '+', 'color': Color(0xFF007cf0), 'textColor': Colors.white},

    {'text': '0', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '.', 'color': Color(0xFF2c3e50), 'textColor': Colors.white},
    {'text': '', 'color': Colors.transparent, 'textColor': Colors.transparent},
    {'text': '=', 'color': Color(0xFF00d4ff), 'textColor': Colors.white},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLandscape = orientation == Orientation.landscape;

    // Responsive font sizes
    final inputFontSize = isMobile ? (isLandscape ? 24.0 : 28.0) : 32.0;
    final outputFontSize = isMobile ? (isLandscape ? 36.0 : 48.0) : 56.0;
    final buttonFontSize = isMobile ? (isLandscape ? 18.0 : 24.0) : 28.0;
    final headerFontSize = isMobile ? (isLandscape ? 16.0 : 20.0) : 24.0;

    // Responsive layout ratios
    final displayFlex = isLandscape ? 1 : 2;
    final buttonsFlex = isLandscape ? 2 : 3;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: ResponsiveHelper.getResponsiveWidth(context),
              child: Column(
                children: [
                  // Header - Hide in landscape mobile untuk save space
                  if (!isLandscape || !isMobile)
                    Container(
                      padding: ResponsiveHelper.getResponsivePadding(
                        context,
                      ).copyWith(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calculate_rounded,
                            color: Color(0xFF00d4ff),
                            size: isMobile ? 28 : 36,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Professional Calculator',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: headerFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Display Area
                  Expanded(
                    flex: displayFlex,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 30,
                        vertical: isLandscape ? 10 : 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: isLandscape ? 30 : 40,
                            ),
                            child: SingleChildScrollView(
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                _input.isEmpty ? "0" : _input,
                                style: TextStyle(
                                  fontSize: inputFontSize,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: isLandscape ? 8 : 15),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: isLandscape ? 40 : 60,
                            ),
                            child: SingleChildScrollView(
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                _output.isEmpty ? "" : _output,
                                style: TextStyle(
                                  fontSize: outputFontSize,
                                  color: Color(0xFF00d4ff),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Button Grid
                  Expanded(
                    flex: buttonsFlex,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 15 : 20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate button spacing based on available space
                          final buttonSpacing = isMobile
                              ? (isLandscape ? 8.0 : 12.0)
                              : 15.0;
                          final buttonAspectRatio = isLandscape
                              ? (isMobile ? 1.5 : 1.3)
                              : 1.2;

                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tombol.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: buttonSpacing,
                                  mainAxisSpacing: buttonSpacing,
                                  childAspectRatio: buttonAspectRatio,
                                ),
                            itemBuilder: (context, index) {
                              var buttonData = tombol[index];
                              String text = buttonData['text'];

                              if (text.isEmpty) {
                                return Container();
                              }

                              return AnimatedScale(
                                scale: 1.0,
                                duration: Duration(milliseconds: 100),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => tekanTombol(text),
                                    borderRadius: BorderRadius.circular(
                                      isMobile ? 16 : 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: buttonData['color'],
                                        borderRadius: BorderRadius.circular(
                                          isMobile ? 16 : 20,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: buttonData['color']
                                                .withOpacity(0.3),
                                            blurRadius: isMobile ? 6 : 8,
                                            offset: Offset(0, isMobile ? 3 : 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              fontSize: text == '='
                                                  ? buttonFontSize * 1.3
                                                  : buttonFontSize,
                                              color: buttonData['textColor'],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
