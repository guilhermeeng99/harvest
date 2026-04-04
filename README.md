# 🌿 Harvest

**Fresh from the farm. Direct to your community.**

Harvest is a fresh food e-commerce app focused on perishable products (fruits, vegetables, greens) connecting communities directly with local farmers. The goal is to make healthy food easily accessible with a fast and reliable experience.

---

## Screenshots

| Home | Search | Cart | Product Details |
|------|--------|------|-----------------|
| Categories, featured & popular products | Browse by category or search | Review items & checkout | Full product info + nutrition |

---

## Features

- **Onboarding** — 3-step introduction to the app
- **Authentication** — Email/password sign-in & sign-up via Firebase Auth
- **Home** — Address selector, categories, featured & popular product sections
- **Search** — Browse by category cards or text search with organic filter
- **Product Details** — Full product info, nutrition facts, farm origin, add-to-cart
- **Cart** — Quantity management, swipe-to-delete, order summary
- **Checkout** — Delivery address, payment method selection, order placement
- **Orders** — Order history with status tracking (pending → delivered)
- **Profile** — User info, addresses, notifications, admin access
- **Addresses** — CRUD for delivery addresses with default selection
- **Notifications** — In-app notification center
- **Admin Panel** — Full CRUD for products, categories, and user management

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter (Android, iOS, Web) |
| **SDK** | Dart ^3.11.3 |
| **Architecture** | Clean Architecture (Feature-First) + SOLID |
| **State Management** | `flutter_bloc` (Bloc + Cubit) |
| **DI** | `get_it` (service locator) |
| **Routing** | `go_router` (declarative, path-based, shell routes) |
| **Backend** | Firebase (Auth + Cloud Firestore + Storage) |
| **i18n** | `slang` / `slang_flutter` (type-safe, JSON-based) |
| **Linting** | `very_good_analysis` (strict) |
| **Images** | `cached_network_image` + `shimmer` |
| **Error Handling** | `dartz` (`Either<Failure, T>`) |
| **Fonts** | Google Fonts — Poppins (headings), Inter (body) |
| **Theme** | Light-only Material 3, custom "Fresh Harvest" palette |

---

## Project Structure

```
lib/
├── app/                          # App-level setup
│   ├── assets/i18n/              # Translation JSON files
│   ├── di/                       # get_it dependency injection
│   ├── routes/                   # GoRouter config + route constants
│   ├── theme/                    # AppColors, AppTheme, AppTypography
│   └── widgets/                  # Shared reusable widgets
├── core/                         # Shared utilities & error handling
│   ├── errors/                   # Failure & Exception classes
│   ├── extensions/               # BuildContext extensions
│   └── utils/                    # Validators, currency formatter
├── features/
│   ├── onboarding/               # 3-step onboarding flow
│   ├── auth/                     # Firebase Auth (sign-in, sign-up)
│   ├── home/                     # Categories + featured/popular products
│   ├── search/                   # Category browse + text search + filters
│   ├── product_details/          # Product detail page
│   ├── cart/                     # Cart management (local state)
│   ├── checkout/                 # Address + payment + order placement
│   ├── orders/                   # Order history from Firestore
│   ├── profile/                  # User profile menu
│   ├── address/                  # Delivery address CRUD
│   ├── notifications/            # In-app notifications
│   └── admin/                    # Admin panel (products, categories, users)
├── gen/i18n/                     # Auto-generated slang translations
└── main.dart
```

Each feature follows Clean Architecture:

```
feature/
├── data/
│   ├── datasources/    # Firebase data sources
│   ├── models/         # fromJson / toJson / fromFirestore
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Pure Dart classes
│   ├── repositories/   # Abstract contracts
│   └── usecases/       # Single-responsibility use cases
└── presentation/
    ├── bloc/ or cubit/  # State management
    ├── pages/           # Route-level screens
    └── widgets/         # Feature-specific widgets
```

---

## Getting Started

### Prerequisites

- Flutter SDK ^3.11.3
- Firebase project configured (Auth + Firestore + Storage)
- Node.js (optional, for Firebase CLI deployment)

### Setup

```bash
# Clone the repository
git clone https://github.com/your-username/harvest.git
cd harvest

# Install dependencies
flutter pub get

# Generate i18n files
dart run slang

# Run the app
flutter run
```

### Firebase Configuration

The project uses Firebase with FlutterFire CLI. Configuration files:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

### Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

---

## Colour Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#2D6A4F` | Buttons, CTAs, navbar |
| `primaryLight` | `#52B788` | Highlights, badges |
| `secondary` | `#E76F51` | Prices, alt CTA |
| `background` | `#FAFAF5` | Main background |
| `surface` | `#FFFFFF` | Cards, containers |
| `success` | `#40916C` | Positive status |
| `error` | `#D62828` | Errors, validation |

---

## License

This project is for educational and portfolio purposes.
