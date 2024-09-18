
## Overview

This application allows users to scan and generate QR codes with ease. It includes additional features such as camera switching, toggling flash during scanning, and picking images from the media gallery. The app has a modern, user-friendly interface, making it accessible for all types of users.
## Features

## 1. QR Code Scanning
Scan QR codes using your device’s camera.
Toggle between front and back cameras.
Turn the flashlight on or off for better scanning in low-light conditions.
Pick an image from the media gallery to scan a QR code from an image file.
Displays the scanned result in a dialog box, allowing easy navigation to URLs, text, or other QR content.
## 2. QR Code Generation
Create QR codes for various data types:
WhatsApp numbers
Instagram links
Websites
Wi-Fi credentials
Gmail addresses
UPI IDs
Share the generated QR codes easily with others.
## 3. Additional Features
Camera switch: Switch between front and rear cameras during QR scanning.
Flash control: Toggle the flashlight while scanning QR codes.
Image from media: Select images from your media gallery to scan QR codes directly from the image.
Responsive UI: Optimized for a wide range of device sizes and resolutions, ensuring a seamless experience across all platforms.
Custom-designed bottom navigation for intuitive app navigation.
Nice UI: Modern, clean, and responsive design that ensures a smooth user experience.
## Installation

To run this app locally, follow the steps below.

Prerequisites
Flutter SDK (version 3.x or above) Install Flutter

Android Studio or Visual Studio Code for running the app on a physical device or emulator.

Dart version 2.12 or later.
## Steps

Clone the Repository
git clone https://github.com/yourusername/your-repo.git

Navigate to the Project Directory
cd qr-scanner-generator-app

Install Dependencies
Install the necessary Flutter packages by running the following command

flutter pub get

Run the App
Ensure a device is connected or an emulator is running, then run the app with:
flutter run
## Project Structure

my_flutter_app/
├── android/
├── ios/
├── lib/
│   ├── views/
│   │   ├──      # View classes
│   │   └── 
│   ├── widgets/
│   │   ├──
│   ├── services/
│   ├── utils/
│   │   └── constants.dart       # Constants used throughout the app
│   ├── main.dart                # Entry point of the app
├── test/
├── pubspec.yaml
└── Readme.md

## Tech Stack

Frameworks and Languages

Frameworks: Flutter, 
Languages: Dart, 
