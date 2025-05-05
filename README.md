# 📚 Study Flow

[![Flutter](https://img.shields.io/badge/Flutter-3.10.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-orange)](https://github.com/Jacob-webdevstudyflow/releases)

A modern, responsive Flutter application for educational management, featuring intuitive student, course, and enrollment tracking with a professional UI design and a collapsible sidebar navigation.

## 🔥 Features

- ✅ **Modern UI Design** – Clean and professional interface with collapsible sidebar navigation for optimal space usage. 🎨
- ✅ **Responsive Layout** – Optimized for desktops, tablets, and mobile devices with adaptive layouts that adjust automatically. 📱💻
- ✅ **Complete Student Management** – Register, view, edit, and delete students with comprehensive profile information. 👨‍🎓
- ✅ **Course Catalog** – Organize course offerings with details including instructor, price, and comprehensive descriptions. 📚
- ✅ **Enrollment Tracking** – Monitor which students are enrolled in specific courses with easy-to-navigate reports. ✅
- ✅ **Advanced Search** – Quickly locate students or courses using the integrated search functionality. 🔍
- ✅ **REST API Integration** – Seamless backend connectivity through a robust RESTful API service. 🔄

## 📸 Screenshots

### 🔹 Dashboard Home

<img src="https://github.com/tononjacopo/StudyFlow/blob/80c64c38bc7c517a4c46bdb7a9ba8801eb7cb4e8/assets/screenshot/home.png" width="700">
*Main dashboard featuring the Study Flow logo and expanded sidebar navigation.*

### 🔹 Dashboard mobile

<img src="https://github.com/tononjacopo/StudyFlow/blob/80c64c38bc7c517a4c46bdb7a9ba8801eb7cb4e8/assets/screenshot/mobile.png" heigth="270">

*Space-efficient view with collapsed sidebar showing only icons for navigation.*

### 🔹 Students Management

<img src="https://github.com/tononjacopo/StudyFlow/blob/80c64c38bc7c517a4c46bdb7a9ba8801eb7cb4e8/assets/screenshot/studenti.png" width="700">

*Complete student management interface with search functionality and list view.*

### 🔹 Subscriptions Management

<img src="https://github.com/tononjacopo/StudyFlow/blob/80c64c38bc7c517a4c46bdb7a9ba8801eb7cb4e8/assets/screenshot/iscrizioni.png" width="700">

*Course catalog with detailed information and management options.*

### 🔹 Courses View

<img src="https://github.com/tononjacopo/StudyFlow/blob/80c64c38bc7c517a4c46bdb7a9ba8801eb7cb4e8/assets/screenshot/corsi.png" width="700">

*Comprehensive view of student enrollments in courses with filtering options.*

## 🗁 Project Structure

```plaintext
📚 study-flow
├── .gitignore               # Git ignore file for Flutter project
├── README.md                # Project documentation
├── pubspec.yaml             # Flutter dependencies and project configuration
├── assets/                  
│   └── logo-studyflow.png   # Application logo
├── database/                
│   └── schema.sql           # SQL schema for database setup
├── api/                     
│   ├── api.php              # PHP file handling API requests
│   └── .htaccess            # Configuration file for server rules (Apache)
└── lib/                     # Main Dart code directory
    ├── main.dart            # Entry point of the application
    ├── models/              
    │   ├── corso.dart       # Course model
    │   ├── iscrizione.dart  # Enrollment model
    │   └── studente.dart    # Student model
    ├── screens/             
    │   ├── corsi_page.dart        # Courses management page
    │   ├── dashboard_layout.dart  # Main dashboard layout
    │   ├── home_page.dart         # Home welcome page
    │   ├── iscrizioni_page.dart   # Enrollments page
    │   └── studenti_page.dart     # Students management page
    ├── services/      
    │   └── api_service.dart       # REST API integration service
    └── widgets/       
        ├── responsive_layout.dart  # Responsive design helper
        └── sidebar.dart            # Collapsible sidebar navigation
```

## 🛠️ Technologies Used

- 🎯 **Dart** – Modern, object-oriented programming language optimized for building UIs, powered by a fast, portable runtime.
- 📱 **Flutter** – Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- 🌐 **RESTful API** – Backend communication through a custom API to manage data storage and retrieval.
- 🎨 **Google Fonts** – Typography enhancement with the Poppins font family for a clean, professional look.
- 📊 **Responsive Layout** – Custom-built responsive system to ensure optimal experience across all device sizes.

## 🚀 Installation

To run this project locally, follow these steps:

1. **Ensure Flutter is installed**

   ```bash
   flutter --version
   ```
   If not installed, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. **Clone the repository**

   ```bash
   git clone https://github.com/tononjacopo/StudyFlow.git
   ```

3. **Navigate to the project directory**

   ```bash
   cd studyflow
   ```

4. **Install dependencies**

   ```bash
   flutter pub get
   ```

5. **Run the application**

   ```bash
   flutter run
   ```
   
   For web deployment:
   ```bash
   flutter run -d chrome
   ```

## 🔧 Backend Configuration

The application connects to a REST API for data management. Ensure the API is properly configured:

1. The API endpoints are defined in `lib/services/api_service.dart`
2. Default API path is set to `localhost` for development
3. Modify the API base URL if deploying to production

## 📩 Contact

- [🌐 Portfolio](https://tononjacopo.com)
- [🔗 LinkedIn](https://linkedin.com/in/tononjacopo)
- [💻 GitHub](https://github.com/tononjacopo)
- [📧 Email](mailto:info@tononjacopo.com)

## 📝 License

This project is distributed under the **MIT** license. You are free to use, modify, and distribute it! 🚀

---

**🔗Leave a ⭐ on GitHub if you found it useful!** 😊✨