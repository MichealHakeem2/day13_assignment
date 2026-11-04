# Shopping App with State Management (Repository Pattern & BLoC / Cubit) 🛒

A modern, responsive Flutter E-Commerce application built as part of the **EraaSoft Flutter Course (Day 13)**. This project demonstrates clean state management using **Flutter BLoC (Cubit)**, the **Repository Pattern** with interfaces, feature-based architecture, full remote REST API integration with offline SQLite caching across every feature, reactive UI states, local notifications with timezones, and persistent bottom navigation.

---

## 📱 App Screenshots

| Splash Screen | Login Screen | Sign Up Screen |
|![Splash Screen](assets/images/splash.png)|![Login Screen](assets/images/login.png)|![Sign Up Screen](assets/images/sign_up.png)|
| White splash branding with asset logo | User authentication & validation | Form validation & account creation |

| Home Screen | Cart Screen | Favorites Screen | Account Screen |
|![Home Screen](assets/images/home.png)|![Cart Screen](assets/images/cart.png)|![Favorites Screen](assets/images/favorite.png)|![Account Screen](assets/images/account.png)|
| BLoC reactive grid & category chips | SQLite + API synced cart | SQLite + API synced favorites | Remote profile with offline fallback |

---

## ✨ Features

- **State Management with BLoC (Cubit):** Clean separation of UI and business logic using `flutter_bloc` with `HomeCubit`, `LoginCubit`, and `RegisterCubit`.
- **Repository Pattern Architecture:** Full data abstraction separating remote REST APIs, local SQLite caching, and presentation layers across every feature.
- **Full Remote API + Local Sync:** Every feature (products, categories, cart, favorites, user profile, auth) posts and fetches data from the backend API and synchronizes with the local SQLite database.
- **Offline Fallback:** When the network is unavailable, the app serves products, categories, cart, favorites, and user profile from SQLite automatically.
- **Reactive UI States:**
  - **Loading:** Smooth circular progress indicators while fetching data.
  - **Success:** Displays categories horizontally and products in a responsive grid.
  - **Error & Retry:** Clean error UI with a retry mechanism on failure.
- **Infinite Scroll Pagination:** Automatically loads more products as the user scrolls toward the bottom using a `ScrollController` listener.
- **Horizontal Categories:** Scrollable category chips with active styling and slug-based product filtering, cached locally after first fetch.
- **Cart Management:** Add, remove, and update quantities with live badge counters. All cart changes sync to `POST /user/addCart` and `DELETE /user/deleteCart` with local SQLite as the source of truth.
- **Favorites Management:** Instant toggle with heart icon. All changes sync to `POST /user/addFavorite` and `DELETE /user/deleteFavorite` with local SQLite as the source of truth.
- **User Profile:** Loads from `GET /portfoilo/userData`, cached to SQLite. Profile edits POST to the backend and are immediately reflected in local cache.
- **Authentication & Persistence:** Secure login (`POST /auth/signIn`) and registration (`POST /auth/signUp`) with JWT tokens stored in `shared_preferences` and SQLite. Logout clears all local tables.
- **Reusable Widgets:** Modular components including `CategoryItem`, `ProductItem` (with `CachedNetworkImage`), `CustomElevatedButton`, and `CustomTextFormField`.
- **Bottom Navigation Shell (`AppSection`):** Layout shell hosting 4 main tabs with active icon coloring.
- **Local Notifications & Timezones:** Immediate local notifications and timezone-aware 5-second scheduled notifications using `flutter_local_notifications` and `timezone`.
- **Web SQLite Support:** SQLite runs on Flutter Web via WebAssembly (`sqflite_common_ffi_web`).

---

## 📁 Project Architecture

```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_assets.dart
│   │   └── app_colors.dart
│   ├── database/
│   │   └── sqflite_helper.dart       ← Tables: users, products, categories, cart, favorites, user_profile
│   ├── local_storage/
│   │   └── cache_helper.dart         ← Token persistence + logout cleanup
│   ├── network/
│   │   └── api_result.dart
│   ├── routes/
│   │   └── app_routes.dart
│   ├── services/
│   │   └── notification_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── app_validator.dart
│   └── widgets/
│       ├── custom_elevated_button.dart
│       └── custom_text_form_field.dart
├── features/
│   ├── account/
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   │   ├── user_remote_data_source.dart
│   │   │   │   └── user_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   └── repositories/
│   │   │       └── user_repository.dart
│   │   └── presentation/
│   │       └── view/
│   │           └── account_screen.dart
│   ├── app_section/
│   │   └── screens/
│   │       └── app_section.dart
│   ├── auth/
│   │   ├── data/
│   │   │   ├── api/
│   │   │   │   └── auth_api.dart
│   │   │   ├── local/
│   │   │   │   └── auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   ├── remote/
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   └── repository/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── view/
│   │       │   ├── login_view.dart
│   │       │   └── register_view.dart
│   │       └── view_model/
│   │           ├── login/
│   │           │   ├── login_cubit.dart
│   │           │   └── login_state.dart
│   │           └── register/
│   │               ├── register_cubit.dart
│   │               └── register_state.dart
│   ├── cart/
│   │   ├── data/
│   │   │   ├── local/
│   │   │   │   └── cart_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── cart_item_model.dart
│   │   │   ├── remote/
│   │   │   │   └── cart_remote_data_source.dart
│   │   │   └── repository/
│   │   │       └── cart_repository.dart
│   │   └── presentation/
│   │       └── view/
│   │           └── cart_screen.dart
│   ├── favorite/
│   │   ├── data/
│   │   │   ├── local/
│   │   │   │   └── favorite_local_data_source.dart
│   │   │   ├── remote/
│   │   │   │   └── favorite_remote_data_source.dart
│   │   │   └── repository/
│   │   │       └── favorite_repository.dart
│   │   └── presentation/
│   │       └── view/
│   │           └── favorite_screen.dart
│   ├── home/
│   │   ├── data/
│   │   │   ├── local/
│   │   │   │   └── home_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── category_model.dart
│   │   │   │   └── product_model.dart
│   │   │   └── repo/
│   │   │       ├── data_source/
│   │   │       │   ├── home_data_source_interface.dart
│   │   │       │   └── home_data_source_imp.dart
│   │   │       └── repo/
│   │   │           ├── home_repo_interface.dart
│   │   │           └── home_repo_imp.dart
│   │   └── presentation/
│   │       ├── view/
│   │       │   └── home_screen.dart
│   │       ├── view_model/
│   │       │   ├── home_cubit.dart
│   │       │   └── home_state.dart
│   │       └── widgets/
│   │           ├── banner_widget.dart
│   │           ├── category_item.dart
│   │           └── product_item.dart
│   ├── notifications/
│   │   └── presentation/
│   │       └── notifications_demo_screen.dart
│   └── splash/
│       └── splash_screen.dart
└── main.dart
```

---

## 🛠️ Tech Stack & Dependencies

| Package | Purpose |
|---|---|
| [Flutter](https://flutter.dev/) | Framework (SDK ^3.13.2) |
| [Dart](https://dart.dev/) | Language |
| [flutter_bloc](https://pub.dev/packages/flutter_bloc) | State management (Cubit) |
| [http](https://pub.dev/packages/http) | REST API calls |
| [sqflite](https://pub.dev/packages/sqflite) | Local SQLite database |
| [sqflite_common_ffi_web](https://pub.dev/packages/sqflite_common_ffi_web) | SQLite on Flutter Web (WASM) |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Token & session persistence |
| [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | Local & scheduled notifications |
| [timezone](https://pub.dev/packages/timezone) | Timezone-aware scheduling |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | Cached product images |
| [Supermarket API](https://supermarket-dan1.onrender.com/api/v1) | Backend REST API |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13 or newer)
- Dart SDK
- Android Studio / VS Code with Flutter & Dart extensions
- Android device, iOS simulator, or Chrome browser

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/day13-shopping-app.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd day13
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```
   *To run on Chrome:*
   ```bash
   flutter run -d chrome
   ```

---

## 🔄 Data Flow: Remote API ↔ Local SQLite

```text
[UI Screen]
     │
     ▼ (user action or screen load)
[Cubit / Repository]
     │
     ├──► [Remote Data Source]  ──► POST / GET to REST API
     │          │
     │          ▼ (on success)
     │    [Local Data Source]  ──► Cache result to SQLite
     │
     └──► [Local Data Source]  ──► Serve from SQLite (offline fallback)
```

**Feature-by-feature API endpoints:**

| Feature | Remote Endpoints |
|---|---|
| Auth – Login | `POST /auth/signIn` |
| Auth – Register | `POST /auth/signUp` |
| Products | `GET /home/products` |
| Product Detail | `GET /home/products/:id` |
| Products by Category | `GET /home/products/category/:name` |
| Search | `POST /home/productsFilter` |
| Categories | `GET /home/categories` |
| Cart – Get | `GET /user/getCart` |
| Cart – Add | `POST /user/addCart` |
| Cart – Delete | `DELETE /user/deleteCart` |
| Favorites – Get | `GET /user/getFavorite` |
| Favorites – Add | `POST /user/addFavorite` |
| Favorites – Delete | `DELETE /user/deleteFavorite` |
| Profile – Get | `GET /portfoilo/userData` |
| Profile – Edit | `POST /portfoilo/editUserData` |

---

## 📱 State Management Flow (HomeCubit)

```text
[UI: HomeScreen (BlocBuilder)]
           │
           ▼ (calls getAllProducts / getAllCategories)
      [HomeCubit]
           │
           ▼ (calls abstraction)
   [HomeRepoInterface]
           │
           ▼ (implemented by)
     [HomeRepoImp]
     ┌─────┴─────────────────────────┐
     ▼                               ▼
[HomeDataSourceImp]         [HomeLocalDataSource]
  (Remote REST API)            (SQLite Cache)
     │                               │
     ▼ (returns List<ProductModel>)  ▼ (offline fallback)
[HomeProductLoading / HomeProductSuccess / HomeProductError]
           │
           ▼ (listens & rebuilds)
[BlocBuilder in HomeScreen]
```
