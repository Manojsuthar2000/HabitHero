# HabitHero 🦸‍♂️ - AI-Powered Productivity App

![iOS](https://img.shields.io/badge/iOS-14.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange)
![UIKit](https://img.shields.io/badge/UIKit-MVVM-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

An intelligent habit tracking iOS app that uses AI to suggest personalized habits and helps users build lasting positive routines.

## ✨ Features

### Core Functionality
- ✅ **Smart Habit Tracking** - Track daily, weekly, or custom habits
- 🤖 **AI Habit Suggestions** - Get personalized habit recommendations powered by OpenAI
- 📊 **Beautiful Analytics** - Visualize progress with custom charts and rings
- 🔔 **Smart Notifications** - Never miss a habit with intelligent reminders
- 🌙 **Dark Mode Support** - Beautiful UI in both light and dark themes
- 💾 **Offline Mode** - All data stored locally with CoreData
- 🔄 **Background Sync** - Automatic habit reset and streak updates

### Technical Features
- Clean MVVM + Coordinator architecture
- Protocol-oriented programming
- Dependency injection
- Async/await networking
- Custom CAShapeLayer animations
- CoreData persistence
- Background task scheduling

## 🏗 Architecture
```
┌─────────────────────────────────────────┐
│            Coordinators                  │
├─────────────────────────────────────────┤
│                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────┐  │
│  │   View   │──│ViewModel │──│Model │  │
│  │Controller│  │          │  │      │  │
│  └──────────┘  └──────────┘  └──────┘  │
│                      │                   │
├──────────────────────┼───────────────────┤
│                  Services                │
│  ┌──────────┐  ┌──────────┐  ┌──────┐  │
│  │    AI    │  │ CoreData │  │Notif.│  │
│  │  Service │  │  Service │  │Service│  │
│  └──────────┘  └──────────┘  └──────┘  │
└─────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 14.0+
- OpenAI API Key

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/HabitHero.git
cd HabitHero
```

2. Install dependencies (if using CocoaPods/SPM)
```bash
pod install  # or
swift package resolve
```

3. Add your OpenAI API key
```swift
// In APIKeys.swift
struct APIKeys {
    static let openAIKey = "YOUR_API_KEY_HERE"
}
```

4. Open `HabitHero.xcworkspace` and run

## 📱 App Screens

| Dashboard | Add Habit | Analytics | Settings |
|-----------|-----------|-----------|----------|
| ![Dashboard](#) | ![Add](#) | ![Analytics](#) | ![Settings](#) |

## 🛠 Tech Stack

- **Language:** Swift 5+
- **UI Framework:** UIKit (Programmatic)
- **Architecture:** MVVM + Coordinator
- **Database:** CoreData
- **Networking:** URLSession + async/await
- **AI Integration:** OpenAI API
- **Notifications:** UserNotifications Framework
- **Design Patterns:** 
  - Dependency Injection
  - Protocol-Oriented Programming
  - Repository Pattern
  - Observer Pattern

## 📂 Project Structure
```
HabitHero/
├── App/                    # App lifecycle & coordinators
├── Modules/                # Feature modules (MVVM)
│   ├── HabitList/
│   ├── AddHabit/
│   ├── Analytics/
│   └── Settings/
├── Services/               # Business logic & APIs
│   ├── AIService/
│   ├── CoreDataService/
│   └── NotificationService/
├── Models/                 # Data models
├── Utilities/              # Extensions & helpers
└── Resources/              # Assets & configs
```

## 🔮 Future Improvements

- [ ] **iOS Widgets** - Quick habit check from home screen
- [ ] **iCloud Sync** - Sync habits across devices
- [ ] **Siri Shortcuts** - Voice control for habits
- [ ] **Apple Watch App** - Track habits from your wrist
- [ ] **Social Features** - Share progress with friends
- [ ] **Gamification** - Achievements and rewards
- [ ] **Advanced Analytics** - ML-powered insights
- [ ] **Export Data** - PDF reports and CSV export

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Your Name**
- GitHub: [@Manojsuthar2000](https://github.com/manojsuthar2000)
- LinkedIn: [Manoj Suthar](https://www.linkedin.com/in/manoj-suthar-0a8a99171/)

## 🙏 Acknowledgments

- OpenAI for the GPT API
- Apple Developer Documentation
- The iOS Developer Community

---

Made with ❤️ and ☕ by an iOS Developer
