# Union Shop - Flutter E-Commerce Application

## 📱 Project Overview

Union shop is my attempt at the flutter coursework



### 🎯 Key Features

- **Product Catalog**: Browse a wide range of university merchandise with detailed product pages
- **Collections**: Organized product categories including "On Sale!", "Winter Warmers", "Summer Sale", and more
- **Advanced Search**: Quick product search functionality with real-time results
- **Shopping Cart**: Full cart management with quantity controls, item removal, and price calculations
- **The Print Shack**: Exclusive personalization service for custom merchandise
- **Responsive Design**: Optimized for both mobile devices and desktop browsers
- **User Authentication**: Sign-in functionality for personalized shopping experience
- **Product Filtering & Sorting**: Sort products by price (low to high, high to low) and alphabetically (A-Z, Z-A)
- **Sale Pricing**: Support for discounted items with original price strikethrough

---

## 🏗️ Architecture & Project Structure

### Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider pattern
- **UI Components**: Material Design 3
- **Navigation**: Named routes with arguments

### Directory Structure

```
lib/
├── main.dart                    # Application entry point
├── about/                       # About pages
│   └── about_page.dart         # General about page
├── auth/                        # Authentication
│   └── sign_in_page.dart       # User sign-in interface
├── cart/                        # Shopping cart
│   └── cart_page.dart          # Cart management page
├── collections/                 # Product collections
│   ├── collections_page.dart   # Collections overview
│   └── collection_detail.dart  # Individual collection details
├── contact/                     # Contact information
│   └── contact_page.dart       # Contact details page
├── data/                        # Data layer
│   ├── catalog.dart            # Product catalog data
│   └── products.dart           # Product list
├── models/                      # Data models
│   ├── cart_item.dart          # Shopping cart item model
│   └── product.dart            # Product data model
├── print_shack/                 # Personalization service
│   ├── about_print_shack_page.dart  # Service information
│   └── personalise_page.dart   # Customization interface
├── product_page.dart            # Individual product display
├── providers/                   # State management
│   └── cart_provider.dart      # Cart state provider
├── search/                      # Search functionality
│   └── product_search.dart     # Product search delegate
└── widgets/                     # Reusable components
    ├── about_button.dart       # About navigation button
    ├── header_bar.dart         # Application header
    └── mobile_drawer.dart      # Navigation drawer

test/                            # Test suite
├── about_print_shack_test.dart
├── cart_page_test.dart
├── collection_detail_test.dart
├── collections_page_test.dart
├── home_test.dart
├── print_shack_test.dart
├── product_test.dart
└── Sign_in_test.dart

assets/
└── images/                      # Image resources
    ├── Banner_1.png
    └── Banner_2.png
```

---

## 🚀 Getting Started

### Prerequisites

Before running this application, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (2.17.0 or higher)
   - Included with Flutter SDK

3. **IDE** (Choose one):
   - Visual Studio Code with Flutter extension
   - Android Studio with Flutter plugin
   - IntelliJ IDEA with Flutter plugin

4. **Development Devices** (Optional):
   - Android Emulator or Physical Android Device
   - iOS Simulator (macOS only) or Physical iOS Device
   - Chrome browser for web testing

### Installation Steps

1. **Clone or Download the Repository**
   ```bash
   cd "path/to/union_shop"
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Resolve any issues indicated by the doctor command.



#### Option 2: Run on Web Browser

```bash
# Run on Chrome
flutter run -d chrome

# Run on Edge
flutter run -d edge

# Run on any available web browser
flutter run -d web-server
```

#### Option 3: Run from IDE

**Visual Studio Code:**
1. Open the project folder
2. Press `F5` or click "Run > Start Debugging"
3. Select target device from status bar

**Android Studio:**
1. Open the project
2. Select target device from dropdown
3. Click the green "Run" button or press `Shift + F10`


### Running Tests

The application includes a comprehensive test suite covering all major features.

**Run all tests:**
```bash
flutter test
```

**Run specific test file:**
```bash
flutter test test/cart_page_test.dart
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

### Test Coverage

- **Unit Tests**: 34+ widget tests
- **Integration Tests**: Cart functionality, navigation, form submissions
- **Widget Tests**: All major pages and components
- **Coverage Areas**:
  - Home page and product catalog
  - Shopping cart operations
  - Collections and filtering
  - Product detail pages
  - Sign-in forms
  - About and contact pages
  - Print Shack personalization

### Test Files Overview

| Test File | Purpose | Test Count |
|-----------|---------|------------|
| `home_test.dart` | Home page rendering and navigation | 8 tests |
| `cart_page_test.dart` | Cart operations and calculations | 23 tests |
| `collections_page_test.dart` | Collection browsing and sorting | 17 tests |
| `collection_detail_test.dart` | Individual collection details | 20 tests |
| `product_test.dart` | Product page functionality | 10 tests |
| `Sign_in_test.dart` | Authentication form widgets | 34 tests |
| `print_shack_test.dart` | Personalization features | 16 tests |
| `about_print_shack_test.dart` | Service information display | 3 tests |

---

## 📦 Dependencies

### Production Dependencies

```yaml
flutter:            # Flutter framework
cupertino_icons:    # iOS-style icons
provider: ^6.0.0    # State management solution
```

### Development Dependencies

```yaml
flutter_test:       # Testing framework
flutter_lints:      # Code quality and style rules
```

---

## 🎨 Features & Functionality

### 1. Home Screen
- **Carousel Hero Section**: Auto-rotating promotional banners with manual controls
- **Product Grid**: Responsive layout displaying featured products
- **Sorting Options**: All, Price (Low/High), Alphabetical (A-Z/Z-A)
- **Quick Navigation**: Header with search, account, cart, and menu icons
- **Footer**: Opening hours and contact information

### 2. Product Catalog
- **Product Cards**: Image, title, price display
- **Product Details**: Full-size images, descriptions, pricing
- **Size Selection**: S, M, L, XL options via choice chips
- **Quantity Control**: Numeric input field and dropdown selector (1-10)
- **Add to Cart**: Instant feedback with snackbar notifications
- **Sale Pricing**: Original price strikethrough for discounted items

### 3. Shopping Cart
- **Empty State**: Friendly message with "Continue Shopping" button
- **Item Management**:
  - Product thumbnail, title, size, and price
  - Quantity increment/decrement buttons
  - Remove item functionality
  - Real-time subtotal and total calculations
- **Cart Badge**: Header icon shows current item count
- **Checkout**: Proceed to checkout button with notification

### 4. Collections
- **8 Curated Collections**:
  - Autumn Favourites
  - On sale! (with special promotional banner)
  - Winter Warmers
  - Summer Sale
  - New Arrivals
  - Sports & Leisure
  - Stationery & Accessories
  - Gift Ideas
- **Sorting**: All, A-Z, Z-A options
- **Navigation**: Tap any collection to view products
- **Collection Detail**: 
  - Banner image
  - Product grid with responsive layout
  - Price sorting (Low to High, High to Low)

### 5. The Print Shack
- **About Page**: Service information and capabilities
- **Personalization Tool**:
  - Size selection
  - Number of text lines (1-3)
  - Text input for customization
  - Font selection dropdown
  - Color picker for text
  - Preview functionality
  - Add to cart with custom details

### 6. Search Functionality
- **Live Search**: Real-time filtering as you type
- **Product Results**: Title and price displayed
- **Quick Navigation**: Tap to view product details
- **Search History**: Recent searches maintained

### 7. User Authentication
- **Sign In Page**:
  - Email input (with email keyboard type)
  - Password field (obscured text)
  - Form validation ready
  - Success feedback via snackbar

### 8. Responsive Design
- **Mobile First**: Optimized for smartphone displays
- **Tablet Support**: Adaptive grid layouts (1-4 columns)
- **Desktop Ready**: Wide-screen layouts with constrained content
- **Touch Optimized**: Large tap targets and gesture support

---

## 🎯 State Management

### Provider Pattern Implementation

The application uses the **Provider** package for efficient state management:

#### CartProvider
```dart
class CartProvider extends ChangeNotifier {
  // Properties
  Map<String, CartItem> _items = {};
  
  // Getters
  int get itemCount
  int get totalQuantity
  double get totalAmount
  List<CartItem> get items
  
  // Methods
  void addItem(...)
  void removeItem(String key)
  void updateQuantity(String key, int quantity)
  void clear()
}
```

**Key Features:**
- Reactive updates across the app
- Centralized cart state
- Automatic UI rebuilds on state changes
- Memory-efficient with `listen: false` for one-time reads

**Usage Example:**
```dart
// Add to cart
Provider.of<CartProvider>(context, listen: false).addItem(...);

// Display cart count
Consumer<CartProvider>(
  builder: (ctx, cart, child) => Text('${cart.totalQuantity}')
)
```

---

## 🎨 UI/UX Design

### Color Scheme
- **Primary Brand Color**: `#4d2963` (Purple)
- **Accent Colors**: Red for sale badges, white for primary text
- **Background**: White and light grey (`Colors.grey[50]`)
- **Error/Delete**: `Colors.red[400]`

### Typography
- **Headlines**: 28px, bold
- **Subheadings**: 18-20px, semi-bold
- **Body Text**: 14-16px, regular
- **Captions**: 12-14px, grey

### Components
- **Cards**: Elevated with 2-8dp shadow, rounded corners (8px)
- **Buttons**: 
  - Primary: Purple background, white text, 14-16px vertical padding
  - Secondary: Outlined, purple border
- **Chips**: Choice chips for size selection
- **Text Fields**: Outlined border, focused state highlighting
- **Snackbars**: Bottom-positioned with action buttons

---

## 🔧 Configuration & Customization

### Modifying Products

Edit `lib/data/products.dart`:
```dart
final products = [
  Product(
    title: 'Your Product Name',
    price: '£XX.XX',
    imageUrl: 'https://example.com/image.jpg',
    description: 'Product description...',
  ),
  // Add more products...
];
```

### Modifying Collections

Edit `lib/collections/collection_detail.dart`:
- Add new collections in the collections data
- Update collection images and titles
- Modify product lists per collection

### Customizing Theme

Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4d2963), // Change primary color
  ),
),
```

### Changing Navigation Routes

Edit `lib/main.dart` routes:
```dart
routes: {
  '/': (context) => const HomeScreen(),
  '/product': (context) => const ProductPage(),
  // Add or modify routes...
},
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Dependencies not installing:**
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**2. Build errors after update:**
```bash
flutter clean
flutter pub upgrade
flutter run
```

**3. Hot reload not working:**
- Press `r` in terminal to manually reload
- Press `R` for full restart
- Check for syntax errors in console

**4. Images not loading:**
- Verify `pubspec.yaml` includes `assets/images/`
- Run `flutter pub get` after modifying assets
- Check image paths are correct

**5. Provider state not updating:**
- Ensure `ChangeNotifierProvider` wraps MaterialApp
- Use `Consumer` or `Provider.of<T>(context)` correctly
- Call `notifyListeners()` after state changes

**6. Tests failing:**
```bash
# Clear test cache
flutter clean
# Run specific test
flutter test test/your_test.dart
```

---

## 📱 Platform-Specific Notes

### Android
- **Minimum SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: Latest (configured in `android/app/build.gradle.kts`)
- **Permissions**: Internet access (pre-configured)

### iOS
- **Minimum Version**: iOS 11.0
- **Deployment Target**: Configured in `ios/Runner.xcodeproj`
- **Info.plist**: Network usage configured

### Web
- **Browser Support**: Chrome, Firefox, Safari, Edge (latest versions)
- **PWA Ready**: Can be configured as Progressive Web App
- **URL Strategy**: Hash routing (default)

---



### Code Style Guidelines

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check code quality
- Run `flutter format .` before committing
- Maintain test coverage for new features

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: descriptive message"

# Push changes
git push origin feature/your-feature-name
```

### Adding New Features

1. Create necessary files in appropriate directories
2. Update routes in `main.dart` if adding new pages
3. Add state management in `providers/` if needed
4. Create corresponding test files in `test/`
5. Update this README with new features

---


## 📊 Project Statistics

- **Total Lines of Code**: ~3,000+ (excluding comments and tests)
- **Number of Screens**: 10+
- **Test Coverage**: 100+ test cases
- **Supported Platforms**: Android, iOS, Web
- **Dependencies**: 3 production, 2 development
- **State Management**: Provider pattern
- **Architecture**: Feature-based modular structure


*This README is part of the Union Shop Flutter coursework project for the University of Portsmouth.*
