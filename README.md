<div align="center">

# 🍗 Chicket

**Self-Service Food Ordering Kiosk**

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-Kiosk-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)

A Flutter-based self-service kiosk application for food ordering, designed for Android kiosk devices.

---

[Features](#-features) •
[Tech Stack](#-tech-stack) •
[Getting Started](#-getting-started) •
[Deployment](#-kiosk-deployment) •
[Project Structure](#-project-structure)

</div>

---

## ✨ Features

<table>
<tr>
<td>

🛒 **Self-Service Ordering**
> Browse menu, customize items with add-ons, and place orders

🔒 **Kiosk Mode**
> Full immersive mode with locked navigation (blocks home, back, volume keys)

⏱️ **Idle Detection**
> Auto-reset to home screen after inactivity

💾 **Menu Caching**
> Offline menu caching with Hive, auto-refresh every 15 minutes

</td>
<td>

🌐 **Multi-language Support**
> English & Arabic with RTL layout support

📱 **QR Code Generation**
> Order confirmation with QR codes for e-receipt

💳 **Payment Selection**
> Dynamic payment methods from Syrve API

💡 **Wake Lock**
> Screen stays on continuously for kiosk use

</td>
</tr>
</table>

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.10+ |
| **State Management** | GetX |
| **Navigation** | GetX Routes |
| **API Client** | Retrofit + Dio |
| **Serialization** | json_serializable, freezed |
| **Backend** | Syrve Live API |
| **Local Storage** | Hive (menu caching) |
| **Localization** | GetX Translations (EN/AR) |
| **UI Scaling** | flutter_screenutil (1080x1920) |
| **Assets** | flutter_gen (type-safe) |
| **Images** | flutter_svg, cached_network_image |
| **QR Codes** | qr_flutter |
| **Loading** | shimmer |
| **Screen** | wakelock_plus |

---

## 🔌 API Integration

The app integrates with **Syrve Live API** for real-time menu and order management.

### API Data Flow

```mermaid
flowchart TD
    subgraph "🔧 One-Time Setup (Setup Screen)"
        A[API Key] --> B[Access Token]
        B --> C[Organizations]
        C --> D[Terminal Groups]
        C --> E[External Menus]
    end
    
    subgraph "💾 Cached on Device"
        D --> F[(Kiosk Config)]
        E --> F
        F --> |organizationId| G[Order Creation]
        F --> |terminalGroupId| G
        F --> |externalMenuId| H[Menu Loading]
    end
    
    subgraph "📱 Runtime (App Usage)"
        B --> I[Order Types]
        B --> J[Payment Types]
        H --> K[Menu Categories & Items]
        B --> L[Stop Lists]
        
        I --> |Cached| M[Dine-In / Takeaway]
        J --> |Cached| N[Payment Selection]
        K --> |Cached 15min| O[Menu Display]
        L --> |Filter| O
    end
    
    subgraph "🛒 Order Flow"
        M --> G
        N --> G
        O --> |Cart Items| G
        G --> P[Order Confirmation]
    end
```

### API Relationships

| Step | API | Data Cached | Used For |
|------|-----|-------------|----------|
| 1️⃣ | **Access Token** | Token (session) | All subsequent API calls |
| 2️⃣ | **Organizations** | `organizationId` | Kiosk config, order creation |
| 3️⃣ | **Terminal Groups** | `terminalGroupId` | Order routing to specific terminal |
| 4️⃣ | **External Menus** | `externalMenuId` | Fetching correct menu |
| 5️⃣ | **Order Types** | List in memory | Map Dine-In → `Common`, Takeaway → `DeliveryByClient` |
| 6️⃣ | **Payment Types** | List in memory | Display payment options, include in order |
| 7️⃣ | **Menu by ID** | Hive (15 min TTL) | Display products, categories |
| 8️⃣ | **Stop Lists** | Product IDs | Filter out-of-stock items from menu |
| 9️⃣ | **Create Order** | Response | Order number, confirmation |

### Data Filtering

| Data | Filter Applied |
|------|----------------|
| **Categories** | `isHidden != true` - Hide internal categories |
| **Menu Items** | `isHidden != true` - Hide unavailable items |
| **Products** | Cross-reference with Stop Lists to hide out-of-stock |
| **Payment Types** | `isDeleted != true` - Show only active methods |
| **Order Types** | Match by `orderServiceType` for kiosk flow |

### API Endpoints

| Feature | Endpoint |
|---------|----------|
| 🔐 Authentication | `/api/1/access_token` |
| 🏢 Organizations | `/api/1/organizations` |
| 🖥️ Terminal Groups | `/api/1/terminal_groups` |
| 📋 Order Types | `/api/1/deliveries/order_types` |
| 💳 Payment Types | `/api/1/payment_types` |
| 📖 External Menus | `/api/2/menu` |
| 🍔 Menu by ID | `/api/2/menu/by_id` |
| 🚫 Stop Lists | `/api/1/stop_lists` |
| 🛒 Create Order | `/api/1/deliveries/create` |
| 📦 Retrieve Order | `/api/1/deliveries/by_id` |

---

## 🚀 Getting Started

### Prerequisites

```
✅ Flutter SDK ^3.10.8
✅ Android SDK
✅ ADB (for kiosk deployment)
```

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd chicket_flutter

# Install dependencies
flutter pub get

# Generate code (API models + assets)
dart run build_runner build --delete-conflicting-outputs

# Run in debug mode
flutter run
```

### Build Release

```bash
flutter build apk --release
```

> 📦 Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📲 Kiosk Deployment

The project includes batch scripts for deploying to Android kiosk devices:

| Script | Description |
|--------|-------------|
| 🔧 `kiosk_setup.bat` | Full device setup (factory reset device required) |
| 🔄 `kiosk_reset.bat` | Reset kiosk configuration |
| 🔍 `kiosk_diagnostics.bat` | Debug and diagnose kiosk issues |

### Requirements

> ⚠️ **Important**: Device must be factory reset with no accounts added

- ✅ USB debugging enabled
- ✅ Device connected via USB
- ✅ ADB installed and in PATH

### Setup Process

```bash
kiosk_setup.bat
```

<details>
<summary>📋 What the setup does</summary>

1. Install the APK
2. Set as device owner
3. Enable kiosk lock task mode
4. Configure auto-start on boot
5. Hide system UI and navigation

</details>

---

## 🗺 App Flow

```mermaid
graph LR
    A[Splash] --> B[Homepage]
    B --> C[Menu]
    C --> D[Cart]
    D --> E[Mobile Number]
    E --> F[Select Payment]
    F --> G[Processing]
    G --> H[Confirmed]
    H -.->|New Order| B
    C -.->|Idle Timeout| B
```

---

## 📁 Project Structure

```
lib/
├── 📄 main.dart              # App entry point
├── 📄 init.dart              # Controller initialization
├── 📄 routes.dart            # GetX route definitions
├── 📄 constants.dart         # App constants
│
├── 📂 api/                   # API layer
│   ├── api_constants.dart    # API configuration
│   ├── 📂 models/            # API DTOs
│   │   ├── auth_models.dart
│   │   ├── menu_models.dart
│   │   ├── order_type_models.dart
│   │   ├── payment_models.dart
│   │   ├── delivery_models.dart
│   │   └── ...
│   ├── 📂 services/          # API services
│   │   ├── dio_client.dart
│   │   └── syrve_api_service.dart
│   └── 📂 repositories/      # Data repositories
│       └── syrve_repository.dart
│
├── 📂 controllers/           # GetX controllers
│   ├── idle_controller.dart
│   ├── order_controller.dart
│   ├── language_controller.dart
│   └── syrve_controller.dart # API data controller
│
├── 📂 localization/          # Translations
│   └── app_translations.dart # EN/AR strings
│
├── 📂 services/              # App services
│   ├── kiosk_config_service.dart
│   └── menu_cache_service.dart
│
├── 📂 theme/                 # App theming
│   └── colors.dart
│
├── 📂 utils/                 # Utilities
│   ├── kiosk_service.dart
│   └── color_filter.dart
│
├── 📂 views/                 # UI screens
│   ├── splash/
│   ├── homepage/
│   ├── menu/
│   ├── cart/
│   ├── mob/                  # Mobile number entry
│   ├── select_payment/
│   ├── order_processing/
│   ├── confirmed/
│   └── setup/                # Kiosk configuration
│
└── 📂 gen/                   # Generated assets
```

---

## ⚙️ Configuration

| Setting | Value |
|---------|-------|
| **Design Size** | 1080 x 1920 (portrait) |
| **Package Name** | `com.diode.chicket` |
| **Min SDK** | Android 5.0+ |

---

<div align="center">

## 📄 License

**Proprietary** - © Diode

---

Made with ❤️ and Flutter

</div>
