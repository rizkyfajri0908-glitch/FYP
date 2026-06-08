# CHAPTER 4: FINDINGS AND RESULTS

## 4.1 Introduction

This chapter presents the findings and results obtained from the development and evaluation of the EcoBite application and its promotional website. The purpose of this chapter is to show the outcome of the project based on the objectives stated in Chapter 1. The findings are arranged according to the main stages of the project, which include identifying the user problem, designing the proposed solution, developing the mobile application and website, and evaluating the system through user feedback.

EcoBite was developed as a smart kitchen assistant application that aims to help users manage kitchen ingredients, monitor expiry dates, receive recipe suggestions, plan groceries, and reduce food waste. The mobile application was built using Dart and Flutter so that it can support mobile development for Android and iOS. The system also uses Firebase services for login and database support, while a promotional website was developed to introduce the app and provide access to download the Android APK file.

The results in this chapter are based on the completed prototype, the implemented system features, and the feedback collected through the EcoBite App User Feedback survey. A total of 63 responses were collected from users. The survey results are used to evaluate whether EcoBite is understandable, useful, and suitable for daily food management.

## 4.2 Findings of Objective 1: Identification of User Needs and Food Waste Problems

The first objective of this project was to explore and identify effective methods of reducing household food waste through ingredient tracking, recipe suggestions, and reminder-based support. Based on the project background and user survey results, household food waste is mainly related to poor grocery planning, forgetting expiry dates, and not knowing what meals to prepare using available ingredients.

The survey findings show that the target users are mostly young adults and home users who cook at different levels of frequency. Out of 63 respondents, 28 respondents were between 18 and 24 years old, representing 44.4% of the sample. Another 22 respondents, or 34.9%, were between 25 and 34 years old. This shows that the feedback mainly represents students, young adults, and early working adults, which is suitable for the intended user group of EcoBite.

In terms of cooking habits, 20 respondents, or 31.7%, stated that they cook once a week, while 17 respondents, or 27.0%, cook a few times a week. Another 16 respondents, or 25.4%, rarely cook. This indicates that many users may not cook every day, but they still need support in managing food items and deciding what to cook when needed.

The survey also shows that food expiry awareness is a relevant issue. A total of 33 respondents, or 52.4%, stated that they sometimes forget food items until they expire. Another 5 respondents, or 7.9%, stated that this happens often. This finding supports the need for an expiry tracking and reminder system in EcoBite. Even though some respondents rarely forget food items, the overall result shows that expiry awareness is still a common problem among users.

Grocery planning also appeared as an important issue. Only 19 respondents, or 30.2%, stated that they always plan groceries before shopping. Meanwhile, 22 respondents, or 34.9%, only plan sometimes, and 21 respondents either rarely or never plan groceries. This supports the need for the predictive grocery planning feature because users may overbuy or forget important items when shopping without a clear plan.

Based on these findings, the main user needs identified are:

- A simple way to record and monitor kitchen items.
- Clear expiry indicators to show which food should be used first.
- Recipe suggestions based on available ingredients.
- Grocery planning support to reduce unnecessary buying.
- A food-focused assistant that can answer simple cooking, storage, and waste reduction questions.

**Suggested screenshot/table placement:**

- Insert **Table 4.1: Respondent Demographic Summary** after the paragraph about age group.
- Insert **Figure 4.1: Survey Chart for Food Expiry Awareness** after the paragraph discussing respondents forgetting food items.
- Insert **Figure 4.2: Survey Chart for Grocery Planning Habits** after the paragraph discussing grocery planning.

## 4.3 Findings of Objective 2: Design of the EcoBite Mobile Application and Website

The second objective was to design a mobile application and web platform that include food-waste reduction features such as a chatbot, expiry tracking system, and predictive grocery planning. The design of EcoBite was created based on the user needs identified in Objective 1. The application design focuses on making the main functions easy to access through a clear bottom navigation structure.

The mobile application uses a green, light green, and white colour theme to match the sustainability and food waste reduction concept. Dark green is used for important headings and main action buttons, while light green is used for highlights, selected tabs, and positive visual indicators. The design aims to be clean and calm so that users can manage food items without feeling overwhelmed.

The main screens designed for EcoBite include:

- Home dashboard
- Kitchen inventory
- Recipe suggestions
- AI assistant
- Predictive grocery plan
- Profile and preferences

The home dashboard provides a quick overview of items that need attention. It displays expiring food items and waste-saving tips to encourage users to act before food spoils. This design supports the project goal of reminding users at the right time.

The kitchen inventory screen allows users to search, filter, add, edit, delete, and scan items. The expiry status is shown through visual indicators. Items close to expiry are highlighted so that users can identify urgent food items quickly. The use of colour-coded tabs helps users prioritise items that should be cooked first.

The recipe suggestion screen was designed to connect directly with the inventory list. Recipes are ranked based on the number of available ingredients. If the user has more ingredients required for a recipe, that recipe appears higher in the list. This makes the feature more useful because it does not only display random recipes, but instead recommends meals based on actual food items in the kitchen.

The predictive grocery plan screen was designed to help users shop with a clearer purpose. It suggests missing ingredients for recipes and important staples that users may need to buy. This feature supports the reduction of overbuying because users can check what is missing instead of purchasing duplicate items.

The AI assistant was designed as a food-related support feature. It allows users to ask questions related to food waste, cooking ideas, storage advice, recipe suggestions, and grocery planning. The assistant was kept focused on the project domain instead of behaving like a general-purpose chatbot.

The profile and preferences screen was designed to allow users to personalize the app. Users can set dietary preferences, cooking style, reminder settings, and display mode. These settings influence recipe and grocery suggestions, making the app more relevant to each user.

The promotional website was also designed to support the mobile application. Unlike the mobile app, the website is not intended to perform inventory or recipe functions. Its purpose is to promote EcoBite, explain its features, show app screenshots, answer common questions, and provide a download button for the Android APK file.

**Suggested screenshot placement:**

- Insert **Figure 4.3: EcoBite Home Dashboard Screen** after the paragraph about the home dashboard.
- Insert **Figure 4.4: Kitchen Inventory Screen with Expiry Indicators** after the paragraph about the inventory screen.
- Insert **Figure 4.5: Recipe Suggestions Screen** after the paragraph about recipe ranking.
- Insert **Figure 4.6: Predictive Grocery Plan Screen** after the paragraph about grocery planning.
- Insert **Figure 4.7: AI Assistant Screen** after the paragraph about the assistant.
- Insert **Figure 4.8: Profile and Preferences Screen** after the paragraph about personalization.
- Insert **Figure 4.9: EcoBite Promotional Website Homepage** after the paragraph about the website.
- Insert **Figure 4.10: Website Features Section with App Preview** after Figure 4.9 if you want to show the website interaction design.

## 4.4 Findings of Objective 3: Development and Implementation of EcoBite

The third objective was to develop and implement the mobile app and website by integrating the planned features into a working prototype. The final product consists of the EcoBite Flutter mobile application and a promotional website hosted through GitHub Pages.

### 4.4.1 Mobile Application Development

EcoBite was developed using Dart programming language with the Flutter framework. Flutter was chosen because it supports cross-platform mobile development, allowing the same codebase to be used for Android and iOS development. During implementation, the Android version was tested directly on a physical Android device.

The mobile app includes a structured navigation system with six main areas: Home, Items, Recipes, AI, Shop, and Profile. This navigation makes it easier for users to move between the main functions without needing to search through many menus.

The authentication feature was implemented using Firebase Authentication. When users open the app, they are asked to log in or create an account. This allows the system to store user-related kitchen data separately and supports a more personalized experience.

Firestore was used as the database for storing user inventory items and preference-related information. This allows kitchen items, expiry dates, quantities, and user settings to be saved and retrieved when needed. The database connection supports the app’s goal of maintaining a persistent kitchen inventory.

### 4.4.2 Kitchen Inventory and Expiry Tracking

The kitchen inventory feature allows users to add ingredients or food items with details such as item name, quantity, category, and expiry date. Users can edit or delete items after they are added. The system also includes filters for viewing all items, urgent items, and expired items.

Expiry tracking was implemented using date comparison logic. Items expiring within one day are shown with a stronger warning colour, while items expiring within two to three days are shown with a light yellow background. Expired items are marked with a clear expired indicator. This result supports the project objective of increasing user awareness of food items that should be used first.

The barcode scanner feature was added to make item entry more convenient. Instead of typing all details manually, users can scan a product barcode and use available product information to add the item into the inventory. This improves usability because manual data entry can be time-consuming.

### 4.4.3 Recipe Suggestion Development

The recipe suggestion feature was developed to recommend meals based on items available in the kitchen inventory. The system compares recipe ingredients with the user’s inventory and ranks recipes based on ingredient availability. Recipes with more matching ingredients are given higher priority.

The feature also considers dietary preferences. For example, if users select a preference such as halal, recipes that are not suitable should be filtered out. This makes the recommendation more personalized and prevents unsuitable recipe suggestions from appearing.

Recipe cards also show which ingredients are available and which ingredients are missing. Users can add missing ingredients into the grocery plan. This creates a connection between the recipe suggestion feature and the grocery planning feature.

### 4.4.4 Predictive Grocery Plan Development

The predictive grocery plan feature was developed to help users identify what they need to buy. The grocery plan uses missing recipe ingredients, basic staples, and user preferences to generate suggestions. This feature helps users avoid buying duplicate items because the suggestions are connected to their current inventory.

The grocery screen includes a checklist system so users can mark planned items while shopping. Users can also add custom grocery items and transfer bought items into the inventory. This supports the project goal of improving grocery planning and reducing unnecessary purchases.

### 4.4.5 AI Assistant Development

The AI assistant feature was developed to provide food-related support inside the app. The assistant uses a structured knowledge base to respond to questions related to food waste, recipes, storage, grocery planning, and kitchen inventory. The assistant was designed to stay focused on the EcoBite domain rather than answering unrelated questions.

To improve the user experience, a thinking animation and gradual response display were added. This makes the assistant feel more natural and avoids responses appearing too suddenly. Although the assistant is not a full large-scale AI model like ChatGPT, it functions as a focused helper for food management and waste reduction.

### 4.4.6 Notification and Preference Development

Notification support was added so that users can receive reminders before food expires. Reminder settings can be adjusted in the profile page. The profile page also includes account settings, dietary preferences, cooking preferences, household size, and dark mode. These preferences improve personalization and allow the app to better match user needs.

### 4.4.7 Promotional Website Development

The promotional website was developed using HTML, CSS, and JavaScript. The purpose of the website is to introduce EcoBite, explain its features, show app screenshots, answer frequently asked questions, and provide a download button for the Android APK.

The website follows the same visual identity as the mobile app, using white, light green, and dark green colours. It includes smooth animations, feature preview buttons, an app screenshot display, a FAQ section, and download buttons linked to the GitHub Release APK file. The website is hosted using GitHub Pages, making it accessible through a public web link.

**Suggested screenshot placement:**

- Insert **Figure 4.11: Firebase Login Screen** in Section 4.4.1.
- Insert **Figure 4.12: Barcode Scanner Screen** in Section 4.4.2.
- Insert **Figure 4.13: Grocery Checklist and Finish Shopping Screen** in Section 4.4.4.
- Insert **Figure 4.14: Dark Mode Interface Example** in Section 4.4.6.
- Insert **Figure 4.15: Promotional Website Download Section** in Section 4.4.7.

## 4.5 User Evaluation Survey Results

After the development of the EcoBite prototype, a user feedback survey was conducted to evaluate the application from the user’s perspective. The survey collected 63 responses. The questions focused on user background, usability, feature usefulness, food waste reduction, and overall satisfaction.

### 4.5.1 Respondent Background

Most respondents were within the young adult age range. A total of 28 respondents, or 44.4%, were aged 18 to 24. Another 22 respondents, or 34.9%, were aged 25 to 34. This indicates that the survey feedback mainly came from users who are likely to be students, young working adults, or individuals who may benefit from simple meal planning and kitchen management tools.

Cooking frequency varied among respondents. The largest group, 20 respondents or 31.7%, cooked once a week. Another 17 respondents, or 27.0%, cooked a few times a week. This shows that EcoBite is relevant not only for frequent cooks but also for users who cook occasionally and may need help deciding what to prepare.

### 4.5.2 Usability Findings

The usability results were generally positive. For the statement “The EcoBite app was easy to understand when I first opened it,” the average score was 3.98 out of 5. A total of 46 out of 62 valid respondents, or 74.2%, selected a score of 4 or 5. This suggests that most users found the app understandable during first use.

For the statement “The app layout was clear and easy to navigate,” the average score was 3.82 out of 5. A total of 39 out of 62 valid respondents, or 62.9%, selected a score of 4 or 5. This result shows that the layout was mostly clear, but there is still room to improve navigation and screen spacing.

Overall satisfaction received an average score of 3.81 out of 5. A total of 39 out of 62 valid respondents, or 62.9%, gave a rating of 4 or 5. This indicates that users were generally satisfied with EcoBite, although some improvements could still be made.

**Suggested chart placement:**

- Insert **Figure 4.16: Ease of Understanding Survey Result** after the first paragraph in this subsection.
- Insert **Figure 4.17: Layout and Navigation Survey Result** after the second paragraph.
- Insert **Figure 4.18: Overall Satisfaction Survey Result** after the third paragraph.

### 4.5.3 Feature Usefulness Findings

The survey results show that users found several EcoBite features useful. The most selected useful feature was the Predictive Grocery Plan, chosen 41 times. This was followed by Expiry Reminders with 34 selections, Recipe Suggestions with 32 selections, and the AI Assistant with 26 selections. This shows that users appreciated features that reduce planning effort and help them make practical food decisions.

The kitchen inventory feature received an average score of 3.76 out of 5, with 61.3% of valid respondents selecting 4 or 5. This shows that users generally agreed that the inventory feature helped them keep track of food items.

The expiry indicator feature received an average score of 3.94 out of 5, with 66.1% of valid respondents selecting 4 or 5. This result supports the importance of visual expiry reminders in helping users decide which food should be used first.

Recipe suggestions received an average score of 3.76 out of 5, with 62.9% of valid respondents selecting 4 or 5. This indicates that users found the recommendations relevant, especially when they were based on ingredients already available in the inventory.

The grocery plan received an average score of 3.73 out of 5, with 66.1% of valid respondents selecting 4 or 5. Although the average is slightly lower than some other features, the high number of users selecting the Predictive Grocery Plan as the most useful feature shows that users saw strong value in this function.

For the AI Assistant, 41 respondents, or 65.1%, stated that it provided useful food-related responses. Another 13 respondents, or 20.6%, did not try it. This suggests that the assistant was useful to most users who interacted with it, but more users should be encouraged to try the feature during future testing.

**Suggested chart placement:**

- Insert **Figure 4.19: Most Useful EcoBite Features** after the first paragraph.
- Insert **Figure 4.20: Kitchen Inventory Usefulness Result** after the inventory paragraph.
- Insert **Figure 4.21: Expiry Indicator Usefulness Result** after the expiry paragraph.
- Insert **Figure 4.22: Recipe Suggestion Relevance Result** after the recipe paragraph.
- Insert **Figure 4.23: Grocery Plan Usefulness Result** after the grocery paragraph.
- Insert **Figure 4.24: AI Assistant Usefulness Result** after the AI paragraph.

### 4.5.4 Food Waste Reduction Findings

The survey results show that users generally believed EcoBite could help reduce food waste. A total of 38 respondents, or 60.3%, answered “Yes” when asked whether EcoBite can help reduce food waste. Another 17 respondents, or 27.0%, answered “Maybe.” Only 7 respondents, or 11.1%, answered “No.”

When asked which part of EcoBite helps most with reducing food waste, recipe suggestions were selected 40 times. Grocery planning was selected 24 times, while inventory tracking was selected 12 times. These results show that users view EcoBite’s strongest waste reduction value as helping them use available ingredients and plan purchases more carefully.

For the statement about being more likely to use ingredients before they expire, the average score was 3.98 out of 5, and 46 out of 62 valid respondents, or 74.2%, selected 4 or 5. This is one of the strongest results in the survey and suggests that EcoBite can positively influence user behaviour toward using food before it expires.

**Suggested chart placement:**

- Insert **Figure 4.25: Perception of EcoBite’s Ability to Reduce Food Waste** after the first paragraph.
- Insert **Figure 4.26: Features Helping Food Waste Reduction** after the second paragraph.
- Insert **Figure 4.27: Likelihood of Using Ingredients Before Expiry** after the third paragraph.

### 4.5.5 Overall Acceptance and Recommendation

The survey also measured whether users would use EcoBite in daily life. A total of 37 respondents, or 58.7%, answered “Yes,” while 17 respondents, or 27.0%, answered “Maybe.” This means that most respondents were either willing to use the app or open to using it depending on further improvements.

For recommendation, 33 respondents, or 52.4%, said they would recommend EcoBite to others. Another 19 respondents, or 30.2%, answered “Maybe.” This indicates that the app has positive acceptance, but some users may want improvements before strongly recommending it.

The open-ended responses also provide useful insight. The most liked aspects of the app were predictive grocery planning, waste-saving tips, and the AI assistant. Predictive grocery planning was selected 38 times, waste-saving tips 33 times, and the AI assistant 32 times. These responses show that users valued the features that made the app feel practical and helpful for daily kitchen decisions.

The most common improvement suggestions were clearer expiry date alerts and more recipe variety, each mentioned 7 times. Faster loading times were mentioned 6 times, while more customizable notifications were mentioned 5 times. Other suggestions included larger font options, better recipe search, more language support, improved onboarding, better barcode scanning, supermarket integration, and a meal planning calendar.

These responses show that users were generally positive toward EcoBite, but they also identified improvements that could make the application more complete and user-friendly.

**Suggested chart/table placement:**

- Insert **Figure 4.28: Willingness to Use EcoBite in Daily Life** after the first paragraph.
- Insert **Figure 4.29: Recommendation Result** after the second paragraph.
- Insert **Table 4.2: Most Liked Features from Open-Ended Responses** after the third paragraph.
- Insert **Table 4.3: Suggested Improvements from Users** after the fourth paragraph.

## 4.6 Discussion of Findings

Based on the development results and survey findings, the EcoBite prototype successfully addresses the main objectives of the project. Objective 1 was achieved because the survey and background research confirmed that users face issues related to food expiry, grocery planning, and deciding what to cook. The survey showed that many respondents sometimes forget food items until they expire and do not always plan groceries before shopping.

Objective 2 was achieved through the design of a mobile application and promotional website. The application design includes the main features required to support food waste reduction, such as kitchen inventory, expiry tracking, recipe suggestions, predictive grocery planning, AI assistant support, barcode scanning, and personal preferences. The website also supports the project by explaining the app’s purpose and providing a download link for the APK.

Objective 3 was achieved through the development and implementation of the working prototype. The app was built using Flutter and Dart, with Firebase used for authentication and database support. The implemented features were tested and improved throughout development. The survey results show that users generally found the app understandable, useful, and relevant to food waste reduction.

However, the findings also show that EcoBite can still be improved. Some users suggested clearer expiry alerts, more recipe variety, faster loading, better barcode scanning, and more customizable notifications. These suggestions are valuable because they show which parts should be prioritized in future development.

Overall, the findings suggest that EcoBite has potential as a practical food waste reduction tool. The strongest user interest was found in predictive grocery planning, expiry reminders, recipe suggestions, and waste-saving tips. These results support the direction of the project and show that the app’s main functions are aligned with user needs.

## 4.7 Chapter Summary

This chapter presented the findings and results of the EcoBite project. The findings were discussed according to the project objectives, beginning with the identification of user needs and food waste problems, followed by the design and development of the mobile application and promotional website. The chapter also discussed the results of the user evaluation survey.

The survey results showed that most users found EcoBite easy to understand and useful for managing food items. The features with the strongest user interest were predictive grocery planning, expiry reminders, recipe suggestions, and the AI assistant. The results also showed that many respondents believed EcoBite could help reduce food waste and make them more likely to use ingredients before they expire.

At the same time, the survey identified several areas for improvement, including clearer expiry alerts, more recipe variety, faster loading times, better barcode scanning, and more customizable notifications. These findings can be used as guidance for future enhancement of the system.

In conclusion, Chapter 4 shows that the EcoBite prototype met the main project objectives and received generally positive feedback from users. The next chapter will summarise the overall project, discuss the conclusion, identify limitations, and provide recommendations for future work.
