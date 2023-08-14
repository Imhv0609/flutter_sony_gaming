import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main() => runApp(const DualSenseApp());

class DualSenseApp extends StatelessWidget {
  const DualSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF', // falls back to system if not provided
        textTheme: const TextTheme(bodyMedium: TextStyle(height: 1.45)),
      ),
      home: const DualSenseScreen(),
    );
  }
}

class DualSenseScreen extends StatefulWidget {
  const DualSenseScreen({super.key});

  @override
  State<DualSenseScreen> createState() => _DualSenseScreenState();
}

class _DualSenseScreenState extends State<DualSenseScreen> {
  String selectedControllerImage = 'assets/controller.png';
  String currentProductCategory = 'controller'; // New: track current product
  bool isDarkMode = true; // Dark mode toggle state

  // Logo size parameters - adjust these to change logo size
  static const double logoWidth = 150.0;
  static const double logoHeight = 75.0;

  void _updateControllerImage(String imagePath) {
    print('Updating controller image to: $imagePath');
    setState(() {
      selectedControllerImage = imagePath;
    });
  }

  void _updateProductCategory(String category) {
    setState(() {
      currentProductCategory = category;
      // Reset to default image when switching categories
      if (category == 'controller') {
        selectedControllerImage = 'assets/controller.png';
      } else if (category == 'monitor') {
        selectedControllerImage = 'assets/monitor.png';
      } else if (category == 'console') {
        selectedControllerImage = 'assets/ps5_new_white.png';
      } else if (category == 'steamdeck') {
        selectedControllerImage = 'assets/steamdeck_oled.png';
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Platform detection
    bool isWeb = kIsWeb;
    bool isMacOS = !kIsWeb && Platform.isMacOS;
    bool isIPad = !kIsWeb && Platform.isIOS && screenWidth >= 768;
    bool isIPhone = !kIsWeb && Platform.isIOS && screenWidth < 768;

    // Use web/macOS layout for web and macOS
    bool useDesktopLayout = isWeb || isMacOS;

    // Route to appropriate layout
    if (useDesktopLayout) {
      return _buildDesktopLayout(context, screenWidth, screenHeight);
    } else if (isIPad) {
      return _buildIPadLayout(context, screenWidth, screenHeight);
    } else if (isIPhone) {
      return _buildIPhoneLayout(context, screenWidth, screenHeight);
    } else {
      // Fallback to desktop layout
      return _buildDesktopLayout(context, screenWidth, screenHeight);
    }
  }

  // Desktop/Web layout (current implementation)
  Widget _buildDesktopLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    // Theme-aware colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF111111)
        : const Color(0xFFF5F5F5);

    final gradientColors = isDarkMode
        ? [const Color(0xFFCC6A1A), const Color(0xFF0E0D0D)]
        : [const Color(0xFFFFE0B3), const Color(0xFFF0F0F0)];

    final vignetteColors = isDarkMode
        ? [Colors.transparent, Colors.black54]
        : [Colors.transparent, Colors.grey.withValues(alpha: 0.3)];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Soft vignette
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.9, -0.8),
                  radius: 1.4,
                  colors: vignetteColors,
                  stops: [0.5, 1.0],
                ),
              ),
            ),

            // Dark/Light mode toggle button
            Positioned(
              right: screenWidth * 0.03,
              top: screenHeight * 0.02,
              child: GestureDetector(
                onTap: _toggleTheme,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDarkMode ? 'Light' : 'Dark',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Company logo in top left (theme-aware)
            Positioned(
              left: screenWidth * 0.03, // 3% from left
              top: screenHeight * 0.02, // 2% from top
              child: Image.asset(
                isDarkMode ? 'assets/sony_black.png' : 'assets/sony_white.png',
                width: logoWidth,
                height: logoHeight,

                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'SONY',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Big rounded tile on the left (theme-aware)
            Positioned(
              left: screenWidth * 0.05, // 5% from left
              top: screenHeight * 0.12, // 12% from top
              bottom: screenHeight * 0.0, // 5% from bottom
              child: Container(
                width: screenWidth * 0.49, // 55% of screen width
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFFFF7A1A)
                      : const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black26
                          : Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Vertical "GAMER" watermark - show for gaming products
                    if (currentProductCategory == 'controller' ||
                        currentProductCategory == 'console' ||
                        currentProductCategory == 'steamdeck')
                      Positioned(
                        left: -400,
                        top: 80, // Reduced from 165 to start higher
                        bottom: 20, // Reduced from 50 to extend lower
                        width: 1200,
                        child: ClipRect(
                          // Clip overflow instead of showing error
                          child: Opacity(
                            opacity: 0.3,
                            child: Transform.rotate(
                              angle: -1.5708, // -90 degrees in radians
                              child: Center(
                                child: SingleChildScrollView(
                                  // Make it scrollable to handle overflow
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize
                                        .min, // Use minimum space needed
                                    children: [
                                      Text(
                                        'GAMER',
                                        style: TextStyle(
                                          fontFamily: 'cursive',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 20,
                                          fontSize:
                                              160, // Increased for better coverage
                                          color: isDarkMode
                                              ? const Color(
                                                  0xFFFFE4CC,
                                                ).withValues(alpha: 0.6)
                                              : const Color(
                                                  0xFF2C3E50,
                                                ).withValues(alpha: 0.4),
                                          height: 0.8, // Even tighter
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ), // Minimal spacing
                                      Text(
                                        'GAMER',
                                        style: TextStyle(
                                          fontFamily: 'Clash Display Variable',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 20,
                                          fontSize:
                                              160, // Increased for better coverage
                                          color: isDarkMode
                                              ? const Color(
                                                  0xFFFFE4CC,
                                                ).withValues(alpha: 0.8)
                                              : const Color(
                                                  0xFF34495E,
                                                ).withValues(alpha: 0.6),
                                          height: 0.8, // Even tighter
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ), // Minimal spacing
                                      Text(
                                        'GAMER',
                                        style: TextStyle(
                                          fontFamily: 'Clash Display Variable',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 20,
                                          fontSize:
                                              160, // Increased for better coverage
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF2C3E50),
                                          height: 0.8, // Even tighter
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ), // Minimal spacing
                                      Text(
                                        'GAMER',
                                        style: TextStyle(
                                          fontFamily: 'cursive',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 20,
                                          fontSize:
                                              160, // Increased for better coverage
                                          color: isDarkMode
                                              ? const Color(
                                                  0xFFFFE4CC,
                                                ).withValues(alpha: 0.6)
                                              : const Color(
                                                  0xFF2C3E50,
                                                ).withValues(alpha: 0.4),
                                          height: 0.8, // Even tighter
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ), // Minimal spacing
                                      Text(
                                        'GAMER',
                                        style: TextStyle(
                                          fontFamily: 'Clash Display Variable',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 20,
                                          fontSize:
                                              160, // Increased for better coverage
                                          color: isDarkMode
                                              ? const Color(
                                                  0xFFFFE4CC,
                                                ).withValues(alpha: 0.8)
                                              : const Color(
                                                  0xFF34495E,
                                                ).withValues(alpha: 0.6),
                                          height: 0.8, // Even tighter
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Category switcher buttons - positioned above the dark card
            Positioned(
              right:
                  screenWidth *
                  0.05, // 5% from right (aligned with product card)
              top: screenHeight * 0.18, // 18% from top (above the product card)
              child: Row(
                children: [
                  _CategoryButton(
                    label: 'Controller',
                    isSelected: currentProductCategory == 'controller',
                    onTap: () => _updateProductCategory('controller'),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 12),
                  _CategoryButton(
                    label: 'Monitor',
                    isSelected: currentProductCategory == 'monitor',
                    onTap: () => _updateProductCategory('monitor'),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 12),
                  _CategoryButton(
                    label: 'Console',
                    isSelected: currentProductCategory == 'console',
                    onTap: () => _updateProductCategory('console'),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 12),
                  _CategoryButton(
                    label: 'Steam Deck',
                    isSelected: currentProductCategory == 'steamdeck',
                    onTap: () => _updateProductCategory('steamdeck'),
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),

            // Dark product card on the right
            Positioned(
              right: screenWidth * 0.05, // 5% from right
              top: screenHeight * 0.28, // 8% from top
              child: Center(
                child: _ProductCard(
                  onColorSelected: _updateControllerImage,
                  currentCategory: currentProductCategory,
                  onCategoryChanged: _updateProductCategory,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),

            // Controller/Monitor/Console/Steam Deck image floating over both
            Positioned(
              left: currentProductCategory == 'monitor'
                  ? screenWidth *
                        0.10 // Monitor position (10% from left)
                  : currentProductCategory == 'console'
                  ? screenWidth *
                        0.0 // Console position (6% from left)
                  : currentProductCategory == 'steamdeck'
                  ? screenWidth *
                        0.04 // Steam Deck position (4% from left)
                  : screenWidth * 0.02, // Controller position (2% from left)
              top: currentProductCategory == 'monitor'
                  ? screenHeight *
                        0.35 // Monitor vertical position (40% from top)
                  : currentProductCategory == 'console'
                  ? screenHeight *
                        0.30 // Console vertical position (20% from top)
                  : currentProductCategory == 'steamdeck'
                  ? screenHeight *
                        0.35 // Steam Deck vertical position (25% from top)
                  : screenHeight *
                        0.20, // Controller vertical position (15% from top)
              child: _FloatingController(imagePath: selectedControllerImage),
            ),
          ],
        ),
      ),
    );
  }

  // iPad-specific responsive layout
  Widget _buildIPadLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    // Theme-aware colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF111111)
        : const Color(0xFFF5F5F5);

    final gradientColors = isDarkMode
        ? [const Color(0xFFCC6A1A), const Color(0xFF0E0D0D)]
        : [const Color(0xFFFFE0B3), const Color(0xFFF0F0F0)];

    final vignetteColors = isDarkMode
        ? [Colors.transparent, Colors.black54]
        : [Colors.transparent, Colors.grey.withValues(alpha: 0.3)];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Stack(
              children: [
                // Soft vignette
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.9, -0.8),
                      radius: 1.4,
                      colors: vignetteColors,
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),

                // Dark/Light mode toggle button - iPad positioned
                Positioned(
                  right: 20,
                  top: 50,
                  child: GestureDetector(
                    onTap: _toggleTheme,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isDarkMode ? 'Light' : 'Dark',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Company logo in top left - iPad positioned
                Positioned(
                  left: 20,
                  top: 50,
                  child: Image.asset(
                    isDarkMode
                        ? 'assets/sony_black.png'
                        : 'assets/sony_white.png',
                    width: 120,
                    height: 60,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'SONY',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Category switcher buttons - iPad positioned at top
                Positioned(
                  left: 20,
                  right: 20,
                  top: 130,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryButton(
                          label: 'Controller',
                          isSelected: currentProductCategory == 'controller',
                          onTap: () => _updateProductCategory('controller'),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 12),
                        _CategoryButton(
                          label: 'Monitor',
                          isSelected: currentProductCategory == 'monitor',
                          onTap: () => _updateProductCategory('monitor'),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 12),
                        _CategoryButton(
                          label: 'Console',
                          isSelected: currentProductCategory == 'console',
                          onTap: () => _updateProductCategory('console'),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 12),
                        _CategoryButton(
                          label: 'Steam Deck',
                          isSelected: currentProductCategory == 'steamdeck',
                          onTap: () => _updateProductCategory('steamdeck'),
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),

                // Main product image - iPad centered positioning
                Positioned(
                  left: 20,
                  right: 20,
                  top: 200,
                  child: Center(
                    child: _FloatingController(
                      imagePath: selectedControllerImage,
                      isTablet: true,
                    ),
                  ),
                ),

                // Product card - iPad positioned at bottom
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: _ProductCard(
                    onColorSelected: _updateControllerImage,
                    currentCategory: currentProductCategory,
                    onCategoryChanged: _updateProductCategory,
                    isDarkMode: isDarkMode,
                    isTablet: true,
                  ),
                ),

                // Background tile with GAMER watermark - iPad version
                if (currentProductCategory == 'controller' ||
                    currentProductCategory == 'console' ||
                    currentProductCategory == 'steamdeck')
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 180,
                    bottom: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFFFF7A1A).withValues(alpha: 0.1)
                            : const Color(0xFF4A90E2).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Opacity(
                          opacity: 0.2,
                          child: Transform.rotate(
                            angle: -1.5708,
                            child: Center(
                              child: Text(
                                'GAMER',
                                style: TextStyle(
                                  fontFamily: 'Clash Display Variable',
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 15,
                                  fontSize: 80,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  // iPhone-specific responsive layout
  Widget _buildIPhoneLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    // Theme-aware colors
    final backgroundColor = isDarkMode
        ? const Color(0xFF111111)
        : const Color(0xFFF5F5F5);

    final gradientColors = isDarkMode
        ? [const Color(0xFFCC6A1A), const Color(0xFF0E0D0D)]
        : [const Color(0xFFFFE0B3), const Color(0xFFF0F0F0)];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header row with logo and toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Company logo
                    Image.asset(
                      isDarkMode
                          ? 'assets/sony_black.png'
                          : 'assets/sony_white.png',
                      width: 100,
                      height: 50,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'SONY',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),

                    // Dark/Light mode toggle
                    GestureDetector(
                      onTap: _toggleTheme,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: isDarkMode ? Colors.white : Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isDarkMode ? 'Light' : 'Dark',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Category selector - iPhone horizontal scroll
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _CategoryButton(
                        label: 'Controller',
                        isSelected: currentProductCategory == 'controller',
                        onTap: () => _updateProductCategory('controller'),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(width: 8),
                      _CategoryButton(
                        label: 'Monitor',
                        isSelected: currentProductCategory == 'monitor',
                        onTap: () => _updateProductCategory('monitor'),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(width: 8),
                      _CategoryButton(
                        label: 'Console',
                        isSelected: currentProductCategory == 'console',
                        onTap: () => _updateProductCategory('console'),
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(width: 8),
                      _CategoryButton(
                        label: 'Steam Deck',
                        isSelected: currentProductCategory == 'steamdeck',
                        onTap: () => _updateProductCategory('steamdeck'),
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Main product image - iPhone optimized
                Center(
                  child: _FloatingController(
                    imagePath: selectedControllerImage,
                    isMobile: true,
                  ),
                ),

                const SizedBox(height: 30),

                // Product information card - iPhone full width
                _ProductCard(
                  onColorSelected: _updateControllerImage,
                  currentCategory: currentProductCategory,
                  onCategoryChanged: _updateProductCategory,
                  isDarkMode: isDarkMode,
                  isMobile: true,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingController extends StatelessWidget {
  final String imagePath;
  final bool isTablet;
  final bool isMobile;

  const _FloatingController({
    required this.imagePath,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine size based on product type
    bool isMonitor = imagePath.contains('monitor');
    bool isConsole = imagePath.contains('ps5');
    bool isSteamDeck = imagePath.contains('steamdeck');

    // Platform-specific size settings
    double containerWidth;
    double containerHeight;

    if (isMobile) {
      // iPhone sizes - smaller for mobile
      if (isMonitor) {
        containerWidth = 280;
        containerHeight = 200;
      } else if (isConsole) {
        containerWidth = 250;
        containerHeight = 180;
      } else if (isSteamDeck) {
        containerWidth = 300;
        containerHeight = 150;
      } else {
        containerWidth = 320;
        containerHeight = 220;
      }
    } else if (isTablet) {
      // iPad sizes - medium for tablet
      if (isMonitor) {
        containerWidth = 400;
        containerHeight = 280;
      } else if (isConsole) {
        containerWidth = 350;
        containerHeight = 260;
      } else if (isSteamDeck) {
        containerWidth = 450;
        containerHeight = 220;
      } else {
        containerWidth = 500;
        containerHeight = 350;
      }
    } else {
      // Desktop sizes - original large sizes
      if (isMonitor) {
        containerWidth = 600;
        containerHeight = 400;
      } else if (isConsole) {
        containerWidth = 800;
        containerHeight = 600;
      } else if (isSteamDeck) {
        containerWidth = 800;
        containerHeight = 400;
      } else {
        containerWidth = 900;
        containerHeight = 700;
      }
    }

    return SizedBox(
      width: containerWidth,
      height: containerHeight, // Add explicit height control
      child: Image.asset(
        imagePath,
        // If you don't have the asset yet, comment the line above and
        // uncomment the network image below to preview:
        // 'https://i.imgur.com/o4mN2d4.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          // Lightweight colorful fallback shape so the layout still looks right
          return Container(
            height:
                containerHeight, // Use the dynamic height instead of hardcoded values
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A1A), Color(0xFF7A3CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 28,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              isMonitor
                  ? 'monitor.png'
                  : (isConsole
                        ? 'ps5_new_white.png'
                        : (isSteamDeck ? 'steamdeck.png' : 'controller.png')),
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Function(String) onColorSelected;
  final String currentCategory;
  final Function(String) onCategoryChanged;
  final bool isDarkMode;
  final bool isTablet;
  final bool isMobile;

  const _ProductCard({
    required this.onColorSelected,
    required this.currentCategory,
    required this.onCategoryChanged,
    required this.isDarkMode,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  int selectedColorIndex = 0;

  // Platform-responsive font sizes
  double get brandNameFontSize => widget.isMobile
      ? 24.0
      : widget.isTablet
      ? 32.0
      : 40.0;
  double get productNameFontSize => widget.isMobile
      ? 36.0
      : widget.isTablet
      ? 48.0
      : 60.0;
  double get subtitleFontSize => widget.isMobile
      ? 18.0
      : widget.isTablet
      ? 24.0
      : 30.0;
  double get priceFontSize => widget.isMobile
      ? 30.0
      : widget.isTablet
      ? 40.0
      : 50.0;
  double get labelFontSize => widget.isMobile
      ? 16.0
      : widget.isTablet
      ? 20.0
      : 24.0;
  double get buttonTextFontSize => widget.isMobile
      ? 12.0
      : widget.isTablet
      ? 13.0
      : 14.0;
  double get descriptionFontSize => widget.isMobile
      ? 14.0
      : widget.isTablet
      ? 18.0
      : 25.0;

  @override
  void didUpdateWidget(_ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset color selection when category changes
    if (oldWidget.currentCategory != widget.currentCategory) {
      setState(() {
        selectedColorIndex = 0;
      });
    }
  }

  // Product data for different categories
  final Map<String, Map<String, dynamic>> productData = {
    'controller': {
      'brandName': 'SONY',
      'productName': 'DUAL SENSE',
      'productSubtitle': 'wireless controller',
      'description':
          "The color has changed, to a two-tone design to match the PS5 itself, "
          "while the bulk is increased and rounded off a little."
          "However, the thumbstick are in the same position and there is "
          "still a touch panel at the top. A lightbar returns too, albeit "
          "around the touch panel rather than on the top.",
      'colors': [
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF7A1A), Color(0xFF7A3CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/controller.png',
          'price': '\$ 99.00',
        },
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/controller_red.png',
          'price': '\$ 79.00',
        },
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFD600),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/controller_yellow.png',
          'price': '\$ 79.00',
        },
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/controller_green.png',
          'price': '\$ 79.00',
        },
      ],
    },
    'monitor': {
      'brandName': 'SONY',
      'productName': 'BRAVIA 5',
      'productSubtitle': '4K OLED TV',
      'description':
          "The big screen experience you've always wanted is here. Enjoy stunning pictures and room-filling sound that make every movie night unforgettable. Bright, beautiful and full of life. Our TV brings rich colours and detailed contrast, delivering every frame that feels vivid and engaging, no matter what you watch.",
      'colors': [
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF2C2C2C),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/monitor.png',
          'price': '\$ 2000.00',
        },
      ],
    },
    'console': {
      'brandName': 'SONY',
      'productName': 'PLAYSTATION 5',
      'productSubtitle': 'gaming console',
      'description':
          "The future of gaming is here. Experience lightning-fast loading with an ultra-high speed SSD, deeper immersion with haptic feedback, adaptive triggers, and 3D Audio technology. The PS5 console unleashes new gaming possibilities that you never anticipated. Play has no limits with stunning 4K graphics and ray tracing for realistic lighting and reflections.",
      'colors': [
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFF000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/ps5_new_white.png',
          'price': '\$ 500.00',
        },
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/ps5_new_blue.png',
          'price': '\$ 519.00',
        },
      ],
    },
    'steamdeck': {
      'brandName': 'VALVE',
      'productName': 'STEAM DECK',
      'productSubtitle': 'handheld gaming PC',
      'description':
          "Your Steam library, everywhere you go. The Steam Deck is the most powerful handheld gaming PC ever created. Play the latest AAA games or thousands of verified titles from your Steam library on a gorgeous 7-inch touchscreen. With desktop-class performance and PC gaming flexibility, take your games anywhere and play however you want.",
      'colors': [
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1a1a1a), Color(0xFF4a4a4a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/steamdeck_oled.png',
          'price': '\$ 549.00',
          'variant': 'OLED',
          'description':
              'Experience gaming in stunning clarity with the Steam Deck OLED. Featuring a vibrant 7.4-inch HDR OLED display with richer colors, deeper blacks, and improved battery life. The premium OLED model delivers an enhanced visual experience that brings your games to life with exceptional contrast and color accuracy.',
        },
        {
          'widget': const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2c3e50), Color(0xFF34495e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          'imagePath': 'assets/steamdeck_lcd.png',
          'price': '\$ 399.00',
          'variant': 'LCD',
          'description':
              'The perfect entry point into PC gaming on-the-go. The Steam Deck LCD features a crisp 7-inch LCD display, powerful AMD APU, and all the controls you need for your Steam library. Incredible value with desktop-class performance in a portable form factor that fits perfectly in your hands.',
        },
      ],
    },
  };

  // Get current product colors based on selected category
  List<Map<String, dynamic>> get currentColors {
    return productData[widget.currentCategory]?['colors'] ?? [];
  }

  // Get current product info based on selected category
  Map<String, dynamic> get currentProduct {
    return productData[widget.currentCategory] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    // Theme-aware colors for the product card
    final cardGradientColors = widget.isDarkMode
        ? [
            const Color(0xFF1A1411),
            const Color(0xFF271A14),
            const Color(0xFF2F221B),
          ]
        : [
            const Color(0xFFF8F9FA),
            const Color(0xFFE9ECEF),
            const Color(0xFFDEE2E6),
          ];

    final cardShadowColor = widget.isDarkMode
        ? Colors.black54
        : Colors.grey.withValues(alpha: 0.3);

    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    // Platform-specific card sizing
    double cardWidth;
    double cardHeight;
    EdgeInsets cardPadding;

    if (widget.isMobile) {
      // iPhone - full width, compact height
      cardWidth = MediaQuery.of(context).size.width - 32;
      cardHeight = 400;
      cardPadding = const EdgeInsets.all(20);
    } else if (widget.isTablet) {
      // iPad - larger but not full desktop size
      cardWidth = MediaQuery.of(context).size.width - 40;
      cardHeight = 450;
      cardPadding = const EdgeInsets.fromLTRB(30, 20, 30, 25);
    } else {
      // Desktop - original size
      cardWidth = 840;
      cardHeight = 600;
      cardPadding = const EdgeInsets.fromLTRB(250, 24, 36, 30);
    }

    final card = Container(
      width: cardWidth,
      height: cardHeight,
      clipBehavior: Clip.antiAlias,
      padding: cardPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradientColors,
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor,
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top brand row
              Text(
                currentProduct['brandName'] ?? 'SONY',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  fontSize: brandNameFontSize,
                  color: textColor.withValues(alpha: 0.92),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentProduct['productName'] ?? 'PRODUCT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: productNameFontSize,
                  letterSpacing: 3.5,
                  color: textColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentProduct['productSubtitle'] ?? 'product subtitle',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: subtitleFontSize,
                  color: textColor.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentColors.isNotEmpty
                        ? currentColors[selectedColorIndex]['price']
                        : '\$ 0.00',
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Show different UI for Steam Deck variants vs colors
              if (widget.currentCategory == 'steamdeck') ...[
                widget.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Variant :',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: labelFontSize,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: currentColors.asMap().entries.map((
                              entry,
                            ) {
                              int index = entry.key;
                              Map<String, dynamic> variantData = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  print(
                                    'Variant $index tapped, imagePath: ${variantData['imagePath']}',
                                  );
                                  setState(() {
                                    selectedColorIndex = index;
                                  });
                                  widget.onColorSelected(
                                    variantData['imagePath'],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedColorIndex == index
                                        ? (widget.isDarkMode
                                              ? const Color(0xFFFF8A2A)
                                              : const Color(0xFF4A90E2))
                                        : (widget.isDarkMode
                                              ? Colors.white.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.1,
                                                )),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selectedColorIndex == index
                                          ? (widget.isDarkMode
                                                ? const Color(0xFFFF8A2A)
                                                : const Color(0xFF4A90E2))
                                          : (widget.isDarkMode
                                                ? Colors.white.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Colors.black.withValues(
                                                    alpha: 0.3,
                                                  )),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    variantData['variant'] ?? 'Variant',
                                    style: TextStyle(
                                      color: selectedColorIndex == index
                                          ? (widget.isDarkMode
                                                ? Colors.black
                                                : Colors.white)
                                          : (widget.isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      fontWeight: FontWeight.w600,
                                      fontSize: buttonTextFontSize,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            'Variant :',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: labelFontSize,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 14),
                          ...currentColors
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                Map<String, dynamic> variantData = entry.value;
                                return [
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                        'Variant $index tapped, imagePath: ${variantData['imagePath']}',
                                      );
                                      setState(() {
                                        selectedColorIndex = index;
                                      });
                                      widget.onColorSelected(
                                        variantData['imagePath'],
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectedColorIndex == index
                                            ? (widget.isDarkMode
                                                  ? const Color(0xFFFF8A2A)
                                                  : const Color(0xFF4A90E2))
                                            : (widget.isDarkMode
                                                  ? Colors.white.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.black.withValues(
                                                      alpha: 0.1,
                                                    )),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: selectedColorIndex == index
                                              ? (widget.isDarkMode
                                                    ? const Color(0xFFFF8A2A)
                                                    : const Color(0xFF4A90E2))
                                              : (widget.isDarkMode
                                                    ? Colors.white.withValues(
                                                        alpha: 0.3,
                                                      )
                                                    : Colors.black.withValues(
                                                        alpha: 0.3,
                                                      )),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        variantData['variant'] ?? 'Variant',
                                        style: TextStyle(
                                          color: selectedColorIndex == index
                                              ? (widget.isDarkMode
                                                    ? Colors.black
                                                    : Colors.white)
                                              : (widget.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black),
                                          fontWeight: FontWeight.w600,
                                          fontSize: buttonTextFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index < currentColors.length - 1)
                                    const SizedBox(width: 12),
                                ];
                              })
                              .expand((element) => element)
                              .toList(),
                        ],
                      ),
              ] else ...[
                widget.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color :',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: labelFontSize,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: currentColors.asMap().entries.map((
                              entry,
                            ) {
                              int index = entry.key;
                              Map<String, dynamic> colorData = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  print(
                                    'Color $index tapped, imagePath: ${colorData['imagePath']}',
                                  );
                                  setState(() {
                                    selectedColorIndex = index;
                                  });
                                  widget.onColorSelected(
                                    colorData['imagePath'],
                                  );
                                },
                                child: _ColorDot(
                                  isSelected: selectedColorIndex == index,
                                  child: colorData['widget'],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            'Color :',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: labelFontSize,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 14),
                          ...currentColors
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                Map<String, dynamic> colorData = entry.value;
                                return [
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                        'Color $index tapped, imagePath: ${colorData['imagePath']}',
                                      );
                                      setState(() {
                                        selectedColorIndex = index;
                                      });
                                      widget.onColorSelected(
                                        colorData['imagePath'],
                                      );
                                    },
                                    child: _ColorDot(
                                      isSelected: selectedColorIndex == index,
                                      child: colorData['widget'],
                                    ),
                                  ),
                                  if (index < currentColors.length - 1)
                                    const SizedBox(width: 8),
                                ];
                              })
                              .expand((element) => element)
                              .toList(),
                        ],
                      ),
              ],
              const SizedBox(height: 6),
              Text(
                // Show variant-specific description for Steam Deck, general description for others
                widget.currentCategory == 'steamdeck' &&
                        currentColors.isNotEmpty
                    ? currentColors[selectedColorIndex]['description'] ??
                          'Variant description not available.'
                    : currentProduct['description'] ??
                          'Product description not available.',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.84),
                  fontSize: descriptionFontSize,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              widget.isMobile
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: _cta(
                            label: 'ADD TO CART',
                            icon: Icons.add,
                            filled: true,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: _cta(
                            label: 'ADD TO WISHLIST',
                            icon: Icons.favorite_border,
                            filled: false,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _cta(
                          label: 'ADD TO CART',
                          icon: Icons.add,
                          filled: true,
                          isDarkMode: widget.isDarkMode,
                        ),
                        const SizedBox(width: 16),
                        _cta(
                          label: 'ADD TO WISHLIST',
                          icon: Icons.favorite_border,
                          filled: false,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );

    // Rounded outer container like in the screenshot
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          // subtle glass glow
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
            child: SizedBox(width: cardWidth, height: 120),
          ),
          card,
        ],
      ),
    );
  }

  Widget _cta({
    required String label,
    required IconData icon,
    required bool filled,
    required bool isDarkMode,
  }) {
    final basePadding = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 12,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    );

    // Theme-aware colors for buttons
    final filledBgColor = isDarkMode
        ? const Color(0xFFFF8A2A)
        : const Color(0xFF4A90E2);

    final filledTextColor = isDarkMode ? Colors.black : Colors.white;

    final outlinedBorderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.3);

    final outlinedTextColor = isDarkMode ? Colors.white : Colors.black;

    if (filled) {
      return ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: basePadding,
          shape: shape,
          backgroundColor: filledBgColor,
          foregroundColor: filledTextColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: basePadding,
          shape: shape,
          side: BorderSide(color: outlinedBorderColor, width: 1),
          foregroundColor: outlinedTextColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }
  }
}

class _ColorDot extends StatelessWidget {
  final Widget? child;
  final bool isSelected;

  const _ColorDot({this.child, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final inner =
        child ??
        const DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        );
    return Container(
      width: 22,
      height: 22,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.4),
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipOval(child: inner),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Theme-aware colors for category buttons
    final selectedBgColor = isDarkMode
        ? const Color(0xFFFF8A2A)
        : const Color(0xFF4A90E2);

    final unselectedBgColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    final selectedBorderColor = isDarkMode
        ? const Color(0xFFFF8A2A)
        : const Color(0xFF4A90E2);

    final unselectedBorderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.3);

    final selectedTextColor = isDarkMode ? Colors.black : Colors.white;

    final unselectedTextColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : unselectedBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedTextColor : unselectedTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
