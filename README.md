# 🎮 Gaming Controller Showcase

A beautiful Flutter application showcasing gaming controllers, monitors, consoles, and handheld gaming devices with platform-specific responsive design and comprehensive theming support.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue?logo=flutter)
![Platforms](https://img.shields.io/badge/Platforms-Web%20%7C%20iOS%20%7C%20macOS%20%7C%20Android-brightgreen)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🎯 Multi-Product Categories
- **Gaming Controllers** - DualSense controllers with multiple color variants
- **Gaming Monitors** - Sony BRAVIA 4K OLED displays  
- **Gaming Consoles** - PlayStation 5 in different colors
- **Handheld Gaming** - Steam Deck OLED and LCD variants

### 🎨 Comprehensive Theming
- **Dark Mode** - Rich orange gradients with warm tones
- **Light Mode** - Clean blue gradients with professional aesthetics
- **Theme-Aware Components** - All UI elements adapt to selected theme
- **Sony Branding** - Dynamic logo switching based on theme

### 🎮 Interactive Features
- **Color Selection** - Interactive color dots for product variants
- **Variant Selection** - Steam Deck OLED/LCD variant switching
- **Category Switching** - Seamless transition between product categories
- **Responsive Images** - Platform-specific image sizing
- **GAMER Watermarks** - Stylized background text for gaming products

## 🏗️ Project Structure

```
game_controller/
├── lib/
│   └── main.dart                 # Main application with platform detection
├── assets/
│   ├── controller*.png          # Controller variants (default, red, yellow, green)
│   ├── monitor.png              # Gaming monitor
│   ├── ps5_new_*.png           # PlayStation 5 variants (white, blue)
│   ├── steamdeck_*.png         # Steam Deck variants (OLED, LCD)
│   ├── sony_*.png              # Sony logos (black, white)
│   └── README.md               # Asset documentation
├── android/                     # Android platform files
├── ios/                        # iOS platform files
├── web/                        # Web platform files
├── macos/                      # macOS platform files
├── linux/                     # Linux platform files
├── windows/                   # Windows platform files
└── pubspec.yaml              # Project dependencies
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd game_controller
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run on different platforms**

   **Web (Chrome)**
   ```bash
   flutter run -d chrome
   ```

   **iOS Simulator**
   ```bash
   flutter run -d "iPad Pro 13-inch (M4)"
   flutter run -d "iPhone 16 Pro"
   ```

   **macOS Desktop**
   ```bash
   flutter run -d macos
   ```

   **Android**
   ```bash
   flutter run -d android
   ```

## 📱 Platform-Specific Layouts

### 🖥️ Desktop/Web Layout
- **Side-by-side design** with product image and details card
- **Horizontal category buttons** at the top
- **GAMER watermarks** with rotating text effects
- **Original large typography** for desktop viewing
- **Hover interactions** and desktop-optimized spacing

### 📱 iPad Layout  
- **Vertical layout** optimized for tablet interaction
- **Top navigation** with logo and theme toggle
- **Centered product showcase** with tablet-appropriate sizing
- **Bottom product card** with touch-friendly controls
- **Horizontal scrolling** category selector

### 📱 iPhone Layout
- **Mobile-first column design** for narrow screens
- **Stacked layout** with full-width elements
- **Wrap widgets** for color/variant selection to prevent overflow
- **Vertical button stacking** for better mobile UX
- **Compact typography** optimized for small screens

## 🎨 Theming System

### Dark Mode
```dart
backgroundColor: Color(0xFF111111)
gradientColors: [Color(0xFFCC6A1A), Color(0xFF0E0D0D)]
cardColors: [Color(0xFF1A1411), Color(0xFF271A14), Color(0xFF2F221B)]
accentColor: Color(0xFFFF8A2A)
```

### Light Mode  
```dart
backgroundColor: Color(0xFFF5F5F5)
gradientColors: [Color(0xFFFFE0B3), Color(0xFFF0F0F0)]
cardColors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF), Color(0xFFDEE2E6)]
accentColor: Color(0xFF4A90E2)
```

## 🔧 Key Components

### `_DualSenseScreenState`
- Platform detection logic
- Theme management
- Category and image switching
- Responsive layout routing

### `_ProductCard`
- Platform-specific sizing
- Responsive typography
- Theme-aware styling
- Interactive color/variant selection

### `_FloatingController`
- Dynamic image sizing based on platform
- Product-specific dimensions
- Error handling with fallback UI

### `_CategoryButton`
- Theme-aware button styling
- Selection state management
- Touch-friendly interaction

## 📊 Platform Detection

```dart
bool isWeb = kIsWeb;
bool isMacOS = !kIsWeb && Platform.isMacOS;
bool isIPad = !kIsWeb && Platform.isIOS && screenWidth >= 768;
bool isIPhone = !kIsWeb && Platform.isIOS && screenWidth < 768;
```

## 🎮 Product Categories

| Category | Products | Features |
|----------|----------|----------|
| **Controller** | DualSense variants | 4 color options, interactive selection |
| **Monitor** | Sony BRAVIA 5 | 4K OLED display showcase |
| **Console** | PlayStation 5 | White and blue variants |
| **Steam Deck** | Handheld gaming PC | OLED/LCD variants with descriptions |

## 🎨 Design Features

- **Gradient Backgrounds** - Dynamic themes with smooth transitions
- **Glass Morphism** - Subtle backdrop blur effects
- **Responsive Typography** - Platform-specific font scaling
- **Interactive Elements** - Touch-friendly controls across all platforms
- **Sony Branding** - Professional brand integration
- **GAMER Watermarks** - Stylized background elements for gaming products

## 🔧 Technical Implementation

### Responsive Font Sizing
```dart
double get brandNameFontSize => widget.isMobile ? 24.0 : widget.isTablet ? 32.0 : 40.0;
double get productNameFontSize => widget.isMobile ? 36.0 : widget.isTablet ? 48.0 : 60.0;
```

### Platform-Specific Image Sizing
```dart
// iPhone: 320x220, iPad: 500x350, Desktop: 900x700
if (isMobile) {
  containerWidth = 320; containerHeight = 220;
} else if (isTablet) {
  containerWidth = 500; containerHeight = 350;  
} else {
  containerWidth = 900; containerHeight = 700;
}
```

## 🎯 User Experience

- **Seamless Platform Adaptation** - Automatic layout optimization
- **Consistent Theming** - Unified design language across platforms
- **Smooth Interactions** - Responsive touch and click interactions
- **Accessibility** - Touch-friendly sizing and clear visual hierarchy
- **Performance** - Optimized rendering and efficient state management

## 🔮 Future Enhancements

- [ ] Add product animations and transitions
- [ ] Implement shopping cart functionality
- [ ] Add product comparison features
- [ ] Include 3D product models
- [ ] Add user reviews and ratings
- [ ] Implement search and filtering
- [ ] Add AR product visualization
- [ ] Include gaming news integration

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Sony for the DualSense controller design inspiration
- Flutter team for the amazing framework
- Material Design for the design system
- Gaming community for the feedback and inspiration

---

**Made with ❤️ and Flutter**
- **Color Selection**: Multiple color dot options
- **Call-to-Action Buttons**: Styled primary and secondary buttons

### Design Elements
- Radial gradient vignette effects
- Backdrop blur filters for glass effect
- Custom shadows and border radius
- Typography with custom font weights and spacing
- Color variants with gradients and solid colors

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Your preferred IDE (VS Code, Android Studio, etc.)

### Installation

1. **Clone or download the project**
2. **Navigate to the project directory**
   ```bash
   cd game_controller
   ```

3. **Get dependencies**
   ```bash
   flutter pub get
   ```

4. **Add Controller Asset (Optional)**
   - Place a transparent PNG image of a DualSense controller in `assets/controller.png`
   - Recommended size: 520px width
   - If no asset is provided, a beautiful gradient fallback will be shown

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run on web (Chrome)
flutter run -d chrome

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Building the App

```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for Web
flutter build web

# Build for macOS
flutter build macos
```

## Project Structure

```
lib/
├── main.dart                 # Main app entry point and all UI components
assets/
├── controller.png           # Controller image asset (add your own)
├── README.md               # Asset information
```

## Customization

### Colors
The app uses these main colors that can be customized:
- Background: `Color(0xFF111111)`
- Orange gradient: `Color(0xFFFF7A1A)` to `Color(0xFFCC6A1A)`
- Card gradient: `Color(0xFF1A1411)` to `Color(0xFF2F221B)`
- Accent: `Color(0xFF7A3CFF)`

### Typography
- Primary font: 'SF' (falls back to system font)
- Various font weights from w600 to w900
- Custom letter spacing and line heights

### Layout
- Main container: 16:9 aspect ratio
- Card width: 760px
- Controller image: 520px width
- Corner radius: 28-36px throughout

## Components Overview

### DualSenseApp
Main application widget with Material3 theme and custom font configuration.

### DualSenseScreen
Main screen containing the complete layout with background, tiles, and overlays.

### _FloatingController
Handles the controller image display with error handling and fallback UI.

### _ProductCard
Contains all product information, pricing, description, and action buttons.

### _ColorDot
Reusable component for color selection indicators with custom styling.

## Platform Support

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- Inspired by modern gaming UI designs
- Built with Flutter's powerful UI framework
- Uses Material3 design principles
