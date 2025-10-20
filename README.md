Ghaith Test Repo ITLegend
 Marketplace App (Flutter + SQLite + Cubit)

This project is a mini marketplace system developed as part of a technical assessment for ITLegend.
It demonstrates strong understanding of Flutter architecture, local database integration, and state management using Cubit — following clean and scalable practices.

🧠 Project Overview

The app simulates a simplified marketplace experience where users can:

Browse a list of products

Apply filters dynamically

Select a plan or product for checkout

Each page reflects modular state management, database operations, and UI logic separation — ensuring readability and maintainability.

🛠️ Tech Stack
Category	Technology
Frontend Framework	Flutter
State Management	Cubit (Bloc)
Local Storage	SQLite
Architecture	Layered architecture with DatabaseHelper and Cubit logic
Language	Dart
📱 Main Features
🛒 Products Page

Displays all available items from the local SQLite database.

Integrates Cubit to manage loading, adding, and deleting products dynamically.

Uses responsive UI components for better user experience.

🔍 Filter Page

Allows users to apply product filters (by category, price, or other attributes).

Demonstrates controlled state transitions via Cubit.

Includes optimized query handling to fetch only filtered results from the database.

💳 Selected Plan Page

Displays the plan or product selected by the user.

Data persists locally via SQLite to simulate cart-like behavior.

Clean design, easily extendable to add real payment or checkout flow.

⚙️ Setup & Installation

Clone the repository

git clone https://github.com/yourusername/test_repo_ITLegend.git
cd test_repo_ITLegend


Get dependencies

flutter pub get


Run the app

flutter run


💡 Make sure your Flutter SDK is installed and properly configured.
The app supports both Android and iOS emulators.

🧩 Architecture Summary
lib/
 ┣ data/
 ┃ ┣ database/
 ┃ ┃ ┗ database_helper.dart
 ┣ cubit/
 ┃ ┣ product_cubit.dart
 ┃ ┗ product_state.dart
 ┣ pages/
 ┃ ┣ products_page.dart
 ┃ ┣ filter_page.dart
 ┃ ┗ selected_plan_page.dart
 ┗ main.dart


This structure ensures:

Separation of concerns between data, logic, and UI.

Testability and easy debugging.

Scalability for future features such as authentication or remote API sync.

🚧 Known Issues / Improvements

Improve error handling for database operations.

Add unit tests for Cubit logic.

Integrate image caching and pagination for better performance.

Future upgrade: integrate REST API or Firebase for real marketplace backend.

👤 Author

Ghaith
Flutter Developer & UI/UX Designer
