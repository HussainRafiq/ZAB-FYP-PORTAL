# ZAB-FYP-PORTAL

The ZAB FYP PORTAL is an innovative project that aims to enhance the experience of final 
year students and their supervisors during the completion of their projects. By creating a native 
application for both Android and iOS, the project seeks to improve coordination and 
communication through the use of technology. The app will provide a platform for students to 
directly contact their supervisors, facilitating the sharing of ideas and progress updates.


ZAB-FYP-PORTAL - Setup and Installation Guide

This guide will help you set up and start the "ZAB-FYP-PORTAL" project, which consists of a Node.js backend, Flutter frontend, and SQL database.

Prerequisites:

Before you begin, make sure you have the following tools and technologies installed:
- Node.js and npm (Node Package Manager)
- Flutter SDK
- MySQL or any compatible SQL database

Backend Setup (Node.js):

1. Clone the repository:
   git clone https://github.com/HussainRafiq/ZAB-FYP-PORTAL.git

2. Navigate to the "ZAB FYP NODE JS BACKEND" folder:
   cd "ZAB FYP NODE JS BACKEND"

3. Install the required dependencies:
   npm install

4. Create a .env file in the root directory and provide the necessary environment variables (e.g., database credentials, API keys).

5. Start the Node.js server:
   npm start

The backend API should now be running at http://localhost:5555.

Frontend Setup (Flutter):

1. Navigate to the "ZAB_FYP_PORTAL FLUTTER FRONTEND" folder:
   cd "ZAB_FYP_PORTAL FLUTTER FRONTEND"

2. Install Flutter dependencies:
   flutter pub get

3. Connect your Flutter app to the backend API:
   Open lib/utils/globals.dart and update the API base URL to match your backend's URL.

4. Run the Flutter app:
   flutter run

The Flutter app should launch on your connected device or emulator.

Database Setup (SQL):

1. Set up your MySQL database with the necessary tables.
   You can import the SQL file provided in the project repository (if available) or use database migration scripts from the backend to create tables.

Contributing:

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature/bug fix.
3. Make your changes and test them thoroughly.
4. Submit a pull request with a detailed description of your changes.

Troubleshooting:

If you encounter any issues during the setup process, please refer to the project's issue tracker on GitHub or contact the maintainers for assistance.



Happy coding!
