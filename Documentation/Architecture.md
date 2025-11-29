# HabitHero Architecture

## Overview
HabitHero follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern combined with dependency injection and protocol-oriented programming.

## Core Components

### 1. Model Layer
- **Purpose**: Data representation and business logic
- **Components**: 
  - `Habit` - Main data model
  - `HabitCategory` - Enumeration for categories
  - `HabitFrequency` - Frequency options
  - CoreData entities

### 2. View Layer
- **Purpose**: UI presentation and user interaction
- **Components**:
  - ViewControllers
  - Custom UIViews
  - UITableViewCells
  - CALayer animations

### 3. ViewModel Layer
- **Purpose**: Presentation logic and data transformation
- **Responsibilities**:
  - Data formatting for views
  - Business logic orchestration
  - State management
  - Combine publishers

### 4. Coordinator Layer
- **Purpose**: Navigation flow and module coordination
- **Benefits**:
  - Decoupled navigation
  - Reusable ViewControllers
  - Clear navigation flow
  - Deep linking support

## Data Flow
```
User Input → View → ViewModel → Service → Repository → CoreData
                ↑                                           ↓
              Update ← ViewModel ← Service ← Repository ←─┘
```

## Dependency Injection

All dependencies are injected through initializers:
```swift
class HabitListViewModel {
    init(repository: HabitRepository = HabitRepository())
}
```

## Protocol-Oriented Design

Key protocols:
- `Coordinator` - Navigation coordination
- `Repository` - Data access abstraction
- `NetworkService` - API abstraction
