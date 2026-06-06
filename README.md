<p align="center">
  <img alt="FanFun Hero Image" src="https://github.com/user-attachments/assets/f130a9a4-4779-4bdc-9eaf-99cde1e9dfed" width="100%" />
</p>
<h1 align="center">FanFun 🏟️</h1>

<p align="center">
  <b>A comprehensive iOS sports hub built with strict Clean Architecture and MVP principles.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-13.0%2B-blue.svg" alt="iOS 13.0+" />
  <img src="https://img.shields.io/badge/Swift-5.0%2B-orange.svg" alt="Swift 5.0+" />
  <img src="https://img.shields.io/badge/Architecture-MVP%20%7C%20Clean-success.svg" alt="MVP & Clean Architecture" />
</p>

---

FanFun is an iOS application designed for sports enthusiasts. It allows users to explore various sports (Football, Tennis, Cricket, Basketball), discover leagues, view upcoming and previous fixtures, check out team or player details, and save their favorite leagues for offline access.

<p align="center">
  <img alt="FanFun UI Showcase" src="https://github.com/user-attachments/assets/dc6ba0d6-b21c-4c8d-b3f1-7ee5ba441713" width="100%" />
</p>

## Features ✨

* **Multi-Sport Support:** Browse leagues across Football, Tennis, Cricket, and Basketball.
* **League Details:** View comprehensive information about a league, including upcoming fixtures, past results, and participating teams or players.
* **Team & Player Details:** Deep dive into specific team statistics, player rosters, and individual tennis player details.
* **Favorites & Offline Mode:** Save your favorite leagues. All fixtures, teams, and data for favorite leagues are automatically cached locally (via CoreData) so you can view them even without an internet connection.
* **Dark & Light Theme Toggling:** Switch seamlessly between dark and light themes straight from the Home screen. Theme preferences are persisted securely via a local preferences data source.
* **Empty States & Error Handling:** Beautiful and clear empty states (e.g., when a search yields no results) and robust error handling when offline without cached data.

## Architecture & Structure 🏗️

This project follows a strict **MVP (Model-View-Presenter)** architecture combined with **Clean Architecture** principles to ensure separation of concerns, high testability, and scalability.

* **Presentation Layer (`/Presentation`):** Contains all the Views (ViewControllers) and Presenters. Each screen is governed by a `Contract` (e.g., `HomeContract.swift`) that protocols the strict communication between the View and the Presenter.
* **Data Layer (`/Data`):**
  * **Remote:** Handles network calls using `NetworkService` communicating with the remote API.
  * **Local:** Handles local caching and persistence using CoreData (`LeagueLocalDataSource`, `FavoriteLocalDataSource`) and UserDefaults (`LocalPreferencesDataSource`).
  * **Repository:** The `SportsRepository` acts as the **single source of truth**. Presenters only interact with the repository, which intelligently orchestrates data fetching between the network and the local cache.
* **Models:** Structs and classes representing the data payload (e.g., `League`, `Fixture`, `Team`, `TeamDetail`).
* **Tests (`/FanFunTests`):** Extensive unit test coverage for Presenters, Repositories, and Local Data Sources utilizing custom mock objects.

## Requirements 📋

* iOS 13.0+
* Xcode 14.0+
* Swift 5.0+

## Getting Started 🚀

### 1. Clone the repository
```bash
git clone https://github.com/your-username/FanFun.git
cd FanFun
```

### 2. Open the project
Open `FanFun.xcodeproj` in Xcode.

### 3. Add Your API Key 🔑
FanFun uses the [AllSportsAPI](https://allsportsapi.com/). You must provide your own API key to fetch live data.

1. Navigate to the `FanFun/Data/Remote/` directory in the project navigator.
2. Locate the `Secrets.template.swift` file.
3. Duplicate this file and rename the copy to **`Secrets.swift`** (ensure it remains in the same directory).
4. Open `Secrets.swift`, uncomment the code, and replace `"YOUR_API_KEY_HERE"` with your actual API key:

```swift
enum Secrets {
    static let apiKey = "YOUR_ACTUAL_API_KEY_HERE"
}
```
> **Note:** `Secrets.swift` is automatically ignored by version control to protect your sensitive keys.

### 4. Build and Run
Select your preferred simulator or connect a physical iOS device, and press `Cmd + R` (or click the Play button) to build and run the application.

## Testing 🧪
The project comes with a comprehensive suite of Unit Tests. To run them:
1. Open the project in Xcode.
2. Press `Cmd + U` to execute the test suite. 
3. The tests validate Presenter logic, Repository caching mechanisms, Data Sources, and Theme Toggling using Mock objects.
