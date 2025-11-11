# Workers Welfare Fund (WWF) Management Information System - Mobile Application

![MIS Logo](https://freepngimg.com/thumb/categories/1424.png)

A comprehensive Flutter mobile application for managing workers' welfare claims, grants, and employee records for the Workers Welfare Fund under the **Ministry of Overseas Pakistanis and Human Resource Development, Government of Pakistan**.

## Table of Contents

- [Introduction](#introduction)
- [Application Version](#application-version)
- [System Requirements](#system-requirements)
- [Technology Stack](#technology-stack)
- [Dependencies & Versions](#dependencies--versions)
- [Project Structure](#project-structure)
- [User Roles & Access Control](#user-roles--access-control)
- [Core Modules & Features](#core-modules--features)
- [API Integration](#api-integration)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Build & Deployment](#build--deployment)
- [Usage Guidelines](#usage-guidelines)
- [Architecture Overview](#architecture-overview)
- [Security Features](#security-features)
- [Support and Issues](#support-and-issues)
- [License](#license)

## Introduction

The WWF MIS Mobile Application is a Flutter-based solution designed to streamline the administration of grants and claims for workers across Pakistan. The system handles multiple types of grants including Marriage, Death, Estate, Hajj, and Educational grants, serving both government and private sector workers.

### Key Highlights

- **Multi-role Support**: Handles 5+ distinct user roles with role-based access control
- **Comprehensive Claim Management**: Supports 5 types of grants with document upload capabilities
- **Real-time Notifications**: Firebase Cloud Messaging integration for push notifications
- **Offline Capability**: Connectivity checking and error handling
- **Secure Authentication**: Token-based session management with expiry tracking

## Application Version

- **Version**: 1.0.0+1
- **Build Number**: 1
- **Flutter SDK**: >=2.7.0 <3.0.0
- **Dart SDK**: >=2.7.0 <3.0.0

## System Requirements

### Development Environment

- **Flutter SDK**: 2.7.0 or higher (but less than 3.0.0)
- **Dart SDK**: 2.7.0 or higher
- **Android Studio**: Latest stable version
- **Xcode**: 12.0+ (for iOS development)
- **Java JDK**: 8 or higher
- **CocoaPods**: Latest version (for iOS)

### Runtime Requirements

- **Android**: Minimum SDK 21 (Android 5.0 Lollipop)
- **iOS**: iOS 12.0 or higher
- **Internet Connection**: Required for API calls
- **Permissions**: 
  - Camera (for document scanning)
  - Storage (for file uploads)
  - Location (for address selection)
  - Notifications (for push notifications)

## Technology Stack

### Frontend Framework
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language

### State Management
- **GetX**: ^4.6.5 - State management, dependency injection, and routing

### Backend Integration
- **RESTful API**: PHP CodeIgniter backend
- **Base URL**: `https://mis.wwf.gov.pk/api/`
- **Image Base URL**: `https://mis.wwf.gov.pk/`

### Local Storage
- **SharedPreferences**: ^2.0.6 - Key-value storage for user sessions

### Push Notifications
- **Firebase Core**: ^1.10.0
- **Firebase Messaging**: ^10.0.0
- **Flutter Local Notifications**: ^9.9.0

## Dependencies & Versions

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI Components
  cupertino_icons: ^1.0.4
  
  # Networking
  http: ^0.13.3
  connectivity: ^3.0.6
  
  # State Management
  get: ^4.6.5
  
  # Local Storage
  shared_preferences: ^2.0.6
  
  # Firebase
  firebase_core: ^1.10.0
  firebase_messaging: ^10.0.0
  firebase_core_platform_interface: 4.5.1
  flutter_local_notifications: ^9.9.0
  
  # File Handling
  file_picker: ^4.2.3
  permission_handler: ^10.2.0
  mime: ^1.0.1
  
  # Location Services
  google_maps_flutter: ^2.0.0
  geolocator: ^9.0.2
  geocoding: ^2.0.5
  
  # Utilities
  email_validator: ^2.0.1
  intl: ^0.17.0
  date_format: ^2.0.4
  mask_text_input_formatter: ^2.0.0
  device_info: ^2.0.3
  package_info_plus: latest
  new_version: ^0.2.0
  gson: ^0.1.6-dev
  simple_fontellico_progress_dialog: ^0.2.1
  
  # Development Tools
  flutter_launcher_icons: ^0.11.0
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

## Project Structure

```
lib/
├── colors/                    # Color theme definitions
│   ├── app_colors.dart
│   └── colors.dart
├── constants/                 # Application constants
│   └── Constants.dart
├── controllers/               # Business logic controllers
│   └── authentication/
│       └── login.dart
├── dialogs/                   # Custom dialog widgets (27 dialogs)
│   ├── app_update_dialog.dart
│   ├── banks_dialog_model.dart
│   ├── complaint_type_dialog_model.dart
│   └── ... (24 more)
├── itemviews/                 # List item widgets (19 items)
│   ├── children_list_itemview.dart
│   ├── complaint_list_item.dart
│   ├── fee_claim_list_item.dart
│   └── ... (16 more)
├── models/                    # Data models (33 models)
│   ├── ChildModel.dart
│   ├── ChildrenModel.dart
│   ├── FeeClaimModel.dart
│   ├── DeathClaimModel.dart
│   ├── MarriageClaimModel.dart
│   └── ... (28 more)
├── network/                   # API service layer
│   └── api_service.dart
├── screens/                   # Application screens
│   ├── authentication/        # Login, Signup, Verification
│   ├── general/              # Common screens (14 screens)
│   ├── home/
│   │   ├── EmployeeHomeData/ # Worker screens (27 screens)
│   │   └── EmployerHomeData/ # Company screens (15 screens)
│   └── SectorInformationForms/ # Registration forms
├── Strings/                   # String resources
│   └── Strings.dart
├── uiupdates/                 # UI utility functions
│   └── UIUpdates.dart
├── usersessions/              # Session management
│   └── UserSessions.dart
├── ImageViewer/               # Image viewing utility
│   └── ImageViewer.dart
└── main.dart                  # Application entry point

assets/
└── images/                    # Application images (50+ images)

fonts/
└── varela_round_regular.otf   # Custom font
```

## User Roles & Access Control

The application supports multiple user roles with different access levels:

### 1. WWF Employee
- **Sector Code**: 7, Role: 6 (or Sector: 4, Role: 3)
- **Access**: Employee home dashboard
- **Features**: View/manage claims, notifications, profile management
- **Initial Setup**: Must complete WWF Employee Information Form

### 2. Company Worker
- **Sector Code**: 8, Role: 9
- **Access**: Employee home interface
- **Features**: 
  - Submit claims (Education, Marriage, Death, Estate, Hajj)
  - Manage children records
  - Add educational records
  - View claim status and history
  - Manage beneficiaries
- **Initial Setup**: Must complete Employee Information Form

### 3. Company CEO
- **Sector Code**: 8, Role: 7
- **Access**: Employer home dashboard
- **Features**:
  - View company statistics
  - Employee verification
  - Manage contributions (Annexure-III, Annexure-III(A))
  - View WPF and Interest Distribution Sheets
  - Manage DEO and Contact Persons
  - View company claims overview
- **Initial Setup**: Must complete Company Information Form

### 4. Data Entry Operator (DEO)
- **Sector Code**: 8, Role: 8
- **Access**: Employer home (direct access)
- **Features**: Data entry operations for companies

### 5. Manager Fee School
- **Sector Code**: 9, Role: 10
- **Status**: Placeholder for future implementation

## Core Modules & Features

### 1. Authentication Module
- **Login**: CNIC-based authentication with password
- **Signup**: User registration with role selection
- **Verification**: Email/phone verification
- **Forgot Password**: Password recovery
- **Session Management**: Token-based with expiry tracking
- **Device Tracking**: IP, platform, and device model logging

### 2. Claims Management Module

#### Educational Claims
- **Fee Claims**: Tuition, registration, exam, library, computer, sports fees
- **School Basics**: School supplies and materials
- **Transport Claims**: Transportation cost reimbursement
- **Residence Claims**: Hostel rent and mess charges
- **Features**:
  - Self or child education claims
  - Document upload (application forms, vouchers)
  - Date range selection
  - Amount calculation and tracking
  - Status monitoring (In Progress, Delivered, Reimbursed)

#### Marriage Claims
- **Types**: Self marriage or daughter's marriage
- **Required Documents**:
  - Marriage certificate (Nikahnama)
  - Service certificate
  - Affidavit (not claimed before)
  - Compensation award
- **Features**: Status tracking, amount reimbursement

#### Death Claims
- **Purpose**: Financial assistance for deceased workers
- **Required Documents**:
  - Death certificate
  - EOBI pension documents
  - Affidavits (not claimed, not married)
  - Compensation award
- **Features**: Beneficiary management, claim tracking

#### Estate Claims
- **Purpose**: Posthumous estate distribution
- **Features**: Inheritor management, estate tracking

#### Hajj Claims
- **Purpose**: Financial support for Hajj pilgrimage
- **Features**: Document verification, status tracking

### 3. Children Management Module
- **Add Children**: Name, CNIC/B-Form, photo, identity documents
- **Features**:
  - Gender selection
  - Date of birth tracking
  - CNIC issue/expiry dates
  - Identity type (CNIC/B-Form)
  - Photo and document upload
  - Link to educational claims

### 4. Educational Records Module

#### Self Education
- Add personal education records
- Education level (Under Matric/Post Matric)
- School/Institution information
- Year and month tracking

#### Children Education
- Link education to specific children
- Track educational progress
- Required before submitting educational claims

### 5. Employee/Company Information Module

#### Employee Information Form
- **Tab 1**: Personal details
- **Tab 2**: Employment information
- **Tab 3**: Bank account details
- Company association

#### Company Information Form
- **Tab 1**: Company details
- **Tab 2**: Additional information
- Contact person management
- DEO management

### 6. Company/Employer Features Module

#### Employee Verification
- View unverified employees list
- Verify/reject employees with remarks
- Match employee data with company records
- Status tracking

#### Contribution Management
- **Annexure-III**: Contribution tracking
- **Annexure-III(A)**: Additional contribution tracking
- Total contribution calculation
- **WPF Distribution Sheet**: View distribution
- **Interest Distribution Sheet**: Interest tracking

#### Dashboard Metrics
- Total employees count
- Disabled employees
- Employees availing benefits
- Total claims (reimbursed/in progress)
- Reimbursed amounts
- Claim breakdowns by type
- Notice board (2 notices)

### 7. General Features Module

#### Notifications & Alerts
- Firebase push notifications
- Local notifications
- Notice board display
- Alert system

#### Complaints & Feedback
- Submit complaints (Management criticism, Payment issues)
- Send feedback
- View complaint history

#### Profile Management
- View/edit profile
- Change password
- Profile image management
- Update personal information

#### Turnover Management
- Employee turnover tracking
- Current/Previous employment
- Turnover history

#### Beneficiary Management
- Add beneficiaries (Son, Daughter, Widow)
- Beneficiary details
- Link to death claims

## API Integration

### Base Configuration
- **API Base URL**: `https://mis.wwf.gov.pk/api/`
- **Image Base URL**: `https://mis.wwf.gov.pk/`
- **Timeout**: 30 seconds
- **Encoding**: UTF-8

### API Endpoints Structure

```
authenticate/
  ├── login
  ├── signup
  ├── forgot_password
  ├── information
  └── gadget (FCM token registration)

companies/
  ├── verify (employee verification)
  └── index

employees/
  └── index

education/
  ├── create (self education)
  └── child_create (children education)

children/
  └── create

claims/
  ├── fee_claim
  ├── marriage_claim
  ├── deceased_claim
  ├── estate_claim
  └── hajj_claim

homescreen/
  ├── employees/{user_id}/{token}/{emp_id}
  └── companies/{user_id}/{token}/{ref_id}

alerts/
  └── (notification endpoints)
```

### API Features
- Connectivity checking before requests
- Error handling with user-friendly messages
- Response code validation
- Multipart file uploads
- Token-based authentication
- Session expiry handling

## Installation Guide

### Prerequisites

1. **Install Flutter SDK**
   ```bash
   # Download Flutter from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   flutter doctor
   ```

2. **Install Android Studio / Xcode**
   - Android Studio for Android development
   - Xcode for iOS development (macOS only)

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone git@github.com:attaatariq/mis_ww_fund_apps.git
   cd mis_ww_fund_apps
   ```

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Configure Firebase project in Firebase Console

4. **Configure API Endpoints**
   - Update API base URL in `lib/constants/Constants.dart` if needed
   - Verify image base URL configuration

5. **Run the Application**
   ```bash
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run
   ```

## Configuration

### Android Configuration

1. **Minimum SDK**: 21 (Android 5.0)
2. **Target SDK**: Latest stable
3. **Permissions** (in `android/app/src/main/AndroidManifest.xml`):
   - Internet
   - Camera
   - Storage
   - Location
   - Notifications

### iOS Configuration

1. **Minimum iOS**: 12.0
2. **Permissions** (in `ios/Runner/Info.plist`):
   - Camera Usage Description
   - Photo Library Usage Description
   - Location When In Use
   - Notification permissions

### Firebase Configuration

1. Create Firebase project
2. Add Android app (package: `com.fi9solutions.welfare_claims_app`)
3. Add iOS app (bundle ID: `com.fi9solutions.welfareClaimsApp`)
4. Download configuration files
5. Place in respective directories

### Environment Variables

Update the following in `lib/constants/Constants.dart`:
- `ApiBaseURL`: API endpoint
- `ImageBaseURL`: Image server URL

## Build & Deployment

### Android Build

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

### iOS Build

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### Build Configuration

- **App Name**: Workers Welfare Fund MIS
- **Package Name**: `com.fi9solutions.welfare_claims_app`
- **Version**: 1.0.0+1
- **Icon**: Configured via `flutter_launcher_icons`

## Usage Guidelines

### For Workers/Employees

1. **Registration**: Sign up with CNIC and complete employee information form
2. **Add Children**: Register children before submitting education claims
3. **Add Education**: Add educational records (self or children)
4. **Submit Claims**: 
   - Select claim type
   - Fill required information
   - Upload necessary documents
   - Submit and track status
5. **View Dashboard**: Monitor claim status, reimbursements, and notices

### For Companies/CEOs

1. **Registration**: Sign up and complete company information form
2. **Employee Verification**: Verify workers registered under your company
3. **Manage Contributions**: View and track Annexure contributions
4. **View Statistics**: Monitor company dashboard metrics
5. **Manage Staff**: Add DEO and contact persons

## Architecture Overview

### State Management
- **GetX**: Used for state management, dependency injection, and navigation
- **Controllers**: Business logic separated in controller classes
- **Reactive Programming**: Observable variables for state updates

### Data Flow
1. **UI Layer**: Screens and widgets
2. **Controller Layer**: Business logic and state management
3. **Service Layer**: API calls and data processing
4. **Model Layer**: Data models and structures
5. **Storage Layer**: SharedPreferences for local data

### Security Architecture
- Token-based authentication
- Session expiry management
- Device tracking
- Secure file uploads
- Input validation

## Security Features

1. **Authentication**
   - CNIC-based login with password
   - Token-based session management
   - Session expiry checking
   - Auto-logout on token expiry

2. **Data Security**
   - Secure API communication (HTTPS)
   - Token storage in SharedPreferences
   - Input validation and sanitization
   - CNIC masking in UI

3. **Device Security**
   - Device information tracking
   - IP address logging
   - Platform detection
   - FCM token registration

4. **File Security**
   - Secure file uploads
   - Document validation
   - File type checking

## Support and Issues

For any issues, queries, or support requests, please contact:

- **Inixio Technologies**
  - Email: support@inixiotechnologies.com

### Common Issues

1. **Build Errors**: Run `flutter clean` and `flutter pub get`
2. **Firebase Issues**: Verify configuration files are in correct locations
3. **API Connection**: Check internet connectivity and API base URL
4. **Permission Errors**: Verify permissions in AndroidManifest.xml and Info.plist

## License

This project is licensed under MIT License. See the **MIT License** file for details.

---

**Developed for**: Workers Welfare Fund, Ministry of Overseas Pakistanis and Human Resource Development, Government of Pakistan

**Version**: 1.0.0+1

**Last Updated**: 2024
