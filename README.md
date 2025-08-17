# Expense Tracker App

A simple and intuitive expense tracker app to help you manage your finances, track spending, and stay on top of your financial goals.

## 🚀 Features

- 💸 Add and categorize expenses easily
- 📊 View spending reports and analytics
- 🏦 Set monthly budgets and monitor progress
- 🔔 Get notifications for budget limits
- 🔒 Secure and private — your data is safe
- 🌙 Light and dark modes
- 🔗 Sync across devices (optional, if supported)

## 📱 Screenshots

![Sonny and Mariel high fiving.](https://github.com/aceMediaDigital/expense_tracker/blob/main/cover.png)

| Intro Screen                                                                       | Transactions                                                                       |
|------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| ![](https://github.com/aceMediaDigital/expense_tracker/blob/main/intro-screen.png) | ![](https://github.com/aceMediaDigital/expense_tracker/blob/main/transactions.png) |


## 🛠️ Tech Stack

- **Frontend:** Flutter
- **Backend:** Laravel
- **Database:** MySQL
- **Authentication:** JWT 
- **Deployment:** Docker on AWS 

## 🔧 Installation

### Frontend Setup

#### Frontend Requirements

As of the dev of this project on a Mac, these was the environment

```shell
  [✓] Flutter (Channel stable, 3.32.0)
  [✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
  [✓] Xcode - develop for iOS and macOS (Xcode 16.4)
  [✓] Chrome - develop for the web
  [✓] Android Studio (version 2024.3)
  [✓] VS Code (version 1.101.1)
  [✓] Connected device (3 available)
  [✓] Network resources
```


```bash
git clone https://github.com/aceMediaDigital/expense_tracker.git
cd expense_tracker
flutter pub get
flutter run
```
### Backend Setup

#### Backend Requirements
- MySQL ver: 5.7 & above
- PHP ver 7.3 & above

```bash
git clone https://github.com/aceMediaDigital/expense_tracker.git
cd expense-tracker/backend
cp .env.example .env
# Configure your environment variables


composer install
php artisan migrate
php artisan serve
```