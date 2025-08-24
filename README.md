# Uber Clean – iOS Application

The **Uber Clean iOS app** is the mobile client for customers and cleaners to access the Uber Clean on-demand cleaning platform. It connects with the Uber Clean backend (web application) to manage bookings, profiles, payments, and real-time updates.  

---

## 📱 Features
- **User App**
  - Book on-demand or scheduled cleaning services.  
  - Real-time cleaner tracking on map.  
  - In-app payments (Stripe/PayPal).  
  - Booking history and invoices.  
  - Push notifications for status updates.  

- **Cleaner App**
  - Accept/decline booking requests.  
  - Navigate to customer location via map integration.  
  - Manage availability and work schedule.  
  - Track earnings and payouts.  

---

## 🛠️ Tech Stack
- **Language:** Swift 5+  
- **Framework:** UIKit / SwiftUI (depending on build)  
- **Networking:** Alamofire / URLSession (REST API integration)  
- **Push Notifications:** Firebase Cloud Messaging (FCM) / APNs  
- **Payments:** Stripe iOS SDK / PayPal SDK  
- **Maps & Location:** Apple MapKit / Google Maps SDK  
- **Persistence:** CoreData / Realm (optional for caching)  

---

## ⚙️ Setup & Installation

### 1. Prerequisites
- macOS with **Xcode 14+**  
- **CocoaPods** or **Swift Package Manager**  
- Apple Developer account (for signing & distribution)  
- Access to Uber Clean backend API  

### 2. Clone Repository
```bash
git clone https://github.com/your-org/uber-clean-ios.git
cd uber-clean-ios
```

### 3. Install Dependencies
If using **CocoaPods**:  
```bash
pod install
open UberClean.xcworkspace
```

If using **Swift Package Manager**:  
Dependencies are auto-resolved when opening the project in Xcode.  

### 4. Configure Environment
Create a file `Config.plist` (or `.xcconfig`) with your API keys and endpoints:  

```
API_BASE_URL = https://api.uberclean.com
STRIPE_KEY   = your_stripe_publishable_key
FIREBASE_KEY = your_firebase_key
```

Update **Bundle Identifier** and enable **Push Notifications** in Xcode project settings.  

### 5. Build & Run
- Select **UberClean** target.  
- Choose a simulator or real device.  
- Press **Run ▶** in Xcode.  

---

## 🔗 API Integration
The iOS app communicates with the backend via secure REST APIs:  

- `POST /api/login` – User/cleaner authentication  
- `POST /api/register` – Create new account  
- `GET /api/bookings` – Retrieve user/cleaner bookings  
- `POST /api/bookings` – Create booking  
- `POST /api/payments` – Process payments  

---

## 🔔 Push Notifications
- Configured via **Firebase Cloud Messaging (FCM)**.  
- Supports booking requests, job acceptance, cancellations, and reminders.  

---

## 🧪 Testing
- Unit Tests → XCTest framework  
- UI Tests → XCUITest  
Run from Xcode menu: **Product > Test** or use CLI:  
```bash
xcodebuild test -scheme UberClean -destination 'platform=iOS Simulator,name=iPhone 14'
```

---

## 📦 Deployment
1. Update version in **Xcode → General → Version & Build**.  
2. Archive the app: **Product → Archive**.  
3. Upload to **App Store Connect**.  
4. Configure screenshots, app description, and publish on App Store.  

---

## 👨‍💻 Default Test Accounts
- **Customer:** `user@uberclean.com / password`  
- **Cleaner:** `cleaner@uberclean.com / password`  

---

## 📞 Support
This app is part of the Uber Clean suite (Web + iOS + Android).  
Originally developed by **[Uplogic Technologies](https://www.uplogictech.com/)** and customized for Uber Clean.  

For technical support: `support@uberclean.com`  
