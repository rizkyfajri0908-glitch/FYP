# Abstract

Food waste is a common household issue that is often caused by poor meal planning, overbuying, forgotten ingredients, and limited awareness of expiry dates. Many existing recipe or grocery applications only solve one part of the problem, such as displaying recipes or creating shopping lists, but they do not fully connect kitchen inventory, expiry tracking, recipe suggestions, and grocery planning in one user-friendly system. Therefore, this project developed EcoBite, a smart kitchen assistant mobile application with a supporting promotional website to help users manage food items more effectively and reduce unnecessary food waste.

EcoBite was developed using Dart and the Flutter framework, with Firebase Authentication and Firestore used to support user login and database storage. The mobile application includes kitchen inventory tracking, expiry date indicators, recipe suggestions based on available ingredients, predictive grocery planning, barcode scanning, notification settings, user preferences, dark mode, and a food-focused AI assistant. The recipe suggestion feature compares recipes with ingredients available in the user’s inventory, while the grocery plan helps users identify missing ingredients and avoid buying duplicate items. A promotional website was also created using HTML, CSS, and JavaScript to introduce the application, display its main features, answer frequently asked questions, and provide a download link for the Android APK.

The completed prototype was evaluated through a user feedback survey involving 63 respondents. The results showed that most users found EcoBite understandable and useful. The app received an average score of 3.98 out of 5 for being easy to understand, while 74.2% of valid respondents agreed that they would be more likely to use ingredients before they expire after using EcoBite. The most useful features identified by users were the predictive grocery plan, expiry reminders, recipe suggestions, and AI assistant. In addition, 60.3% of respondents believed that EcoBite could help reduce food waste. Overall, the findings indicate that EcoBite successfully meets the project objectives and has potential as a practical tool for improving household food management and encouraging more sustainable consumption habits.

Keywords: EcoBite, food waste reduction, smart kitchen assistant, Flutter, Firebase, recipe recommendation, grocery planning

# Report Revision Notes

## Important Changes To Make

### 1. Change The Document Title

Your document still starts with:

> Final Year Project Proposal

Since the app and website have now been developed and evaluated, change it to:

> Final Year Project Report

or

> Final Year Project

### 2. Update The Project Title If Needed

Current title:

> AI Smart Kitchen Assistant with Web Platform for Reducing Food Waste

This is acceptable, but a more accurate final title would be:

> EcoBite: A Smart Kitchen Assistant Mobile Application with Promotional Website for Reducing Household Food Waste

This sounds closer to what you actually built.

### 3. Soften Claims About Advanced AI And Machine Learning

Some sections say the system uses machine learning models, hybrid KNN-SVD, purchase-history learning, cloud-edge architecture, and advanced NLP. The final app uses rule-based/structured recommendation logic, inventory matching, Firebase storage, and a focused AI assistant knowledge base. So avoid making it sound like a fully trained machine learning model was deployed.

Replace strong phrases like:

> The system incorporates machine learning models to analyze user behavior, predict ingredient usage, and generate recipe or grocery suggestions.

with:

> The system applies rule-based recommendation logic and structured data matching to generate recipe and grocery suggestions based on ingredient availability, expiry urgency, user preferences, and missing items.

### 4. Update Predictive Grocery Planning Description

Some early sections say the grocery planner learns from purchase history and usage patterns. In the final version, it mainly uses missing recipe ingredients, staples, inventory, and preferences.

Replace:

> Users will receive suggestions based on purchase history, usage patterns, and frequently cooked meals.

with:

> Users receive grocery suggestions based on missing recipe ingredients, common staples, current inventory items, and profile preferences.

### 5. Update Website Description

Your website is no longer a functional web app or PWA-style app. It is a promotional website.

Use:

> The website serves as a promotional platform that introduces EcoBite, displays its features and screenshots, answers frequently asked questions, and provides a download link for the Android APK.

Avoid calling it a full “web platform” that performs app functions.

### 6. Clarify Android And iOS Scope

Flutter supports Android and iOS development, but your APK download is Android only and iOS was not fully tested.

Add or keep this limitation:

> Although Flutter supports cross-platform development, the implemented and tested build for this project focuses on Android. iOS deployment is considered future work because it requires Apple development tools, certificates, and TestFlight or App Store distribution.

### 7. Update Barcode Scanner Scope

Earlier report text says barcode scanning is optional or future. It is now implemented.

Change:

> optional barcode scanning if implemented in later stages

to:

> barcode scanning was implemented to help users add items more conveniently, although product recognition still depends on available barcode data.

### 8. Update Security And Authentication

The app now uses Firebase Authentication. Mention this clearly in Chapter 3 or system implementation:

> Firebase Authentication was used to support user login and account creation, while Firestore was used to store user-related kitchen data and preferences.

### 9. Remove Or Reword Overly Ambitious Requirements

Some methodology sections mention:

- Dialogflow chatbot
- Firebase Cloud Messaging specifically
- Hive offline-first storage
- app store submission pages
- production-grade ML
- TensorFlow Lite
- hybrid KNN-SVD recommendation engine
- SUS target scores
- analytics tracking
- 20-user validation study
- 5+ Android/iOS device compatibility

If these were not actually implemented, move them to Future Work or remove them from final implementation sections. They are okay in literature review as discussed technologies, but not as completed deliverables.

### 10. Update Chapter 3 Methodology To Match Final Build

Your Chapter 3 should describe what was actually done:

- Flutter and Dart mobile app development
- Firebase Authentication
- Firestore database
- local recipe catalogue
- rule-based recipe matching
- grocery suggestions based on missing ingredients and staples
- barcode lookup/scanning
- notification setup
- promotional website using HTML, CSS, JavaScript
- GitHub Pages hosting
- GitHub Releases APK download
- user feedback survey with 63 respondents

### 11. Add Survey Result Consistency

Chapter 4 and 5 already mention 63 responses. Make sure Chapter 3 research methodology also states:

> The evaluation survey collected 63 responses from users to assess usability, usefulness, feature relevance, food waste reduction potential, and overall satisfaction.

### 12. Check Grammar And Capitalisation

Fix repeated small issues such as:

- “expiration” and “expiry” mixed too often: use “expiry” consistently if your app uses expiry.
- “web platform” vs “promotional website”: use “promotional website” for final system.
- “AI-powered” can stay, but avoid implying full machine learning training unless explained as future enhancement.
- “family food waste” should be “household food waste”.
- “components” should be “ingredients” when referring to food items.

## Recommended Final Wording For The System Scope

The final system consists of two main components: the EcoBite mobile application and the EcoBite promotional website. The mobile application is the main interactive system used by users to manage kitchen inventory, track expiry dates, receive recipe suggestions, plan groceries, scan barcodes, manage preferences, and interact with a food-focused AI assistant. Firebase Authentication supports user login and account creation, while Firestore stores user-related data such as inventory items and preferences.

The promotional website supports the mobile application by introducing EcoBite to potential users. It explains the app’s main features, displays screenshots of the application, provides frequently asked questions, and includes a download button linked to the Android APK through GitHub Releases. The website does not perform inventory tracking or recipe recommendation itself, as these functions are handled by the mobile application.
