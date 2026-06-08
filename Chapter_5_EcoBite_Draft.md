# CHAPTER 5: SUMMARY AND CONCLUSION

## 5.1 Summary

This chapter summarises the overall outcome of the EcoBite project, discusses the conclusion based on the project objectives, and presents recommendations for future enhancement. The purpose of this project was to develop a smart kitchen assistant application that helps users manage food items, monitor expiry dates, receive recipe suggestions, plan groceries, and reduce household food waste. In addition to the mobile application, a promotional website was also developed to introduce the app, explain its features, and provide a download link for the Android APK.

The project was motivated by the issue of household food waste, which commonly happens when users forget what ingredients they have, fail to monitor expiry dates, overbuy groceries, or do not know what to cook with available items. Based on this problem, EcoBite was designed as a user-friendly mobile solution that combines kitchen inventory tracking, expiry awareness, recipe recommendation, predictive grocery planning, barcode scanning, food preferences, and an AI food assistant in one application.

The first objective of this project was to explore and identify effective methods of reducing household food waste through ingredient tracking, recipe suggestions, and AI-based reminders. This objective was achieved through background research, project planning, and user feedback. The survey results showed that food expiry and grocery planning are relevant problems among users. For example, 52.4% of respondents stated that they sometimes forget about food items until they expire, while only 30.2% always plan groceries before shopping. This supports the need for an application that reminds users about expiring food and helps them shop more carefully.

The second objective was to design a mobile application and web platform that incorporate food-waste reduction features. This objective was achieved through the design of the EcoBite mobile app and promotional website. The mobile app was designed with a simple green-themed interface to match the sustainability concept. The app includes main screens such as Home, Items, Recipes, AI, Shop, and Profile. The website was designed as a promotional platform, not as a separate web app, and focuses on explaining the app features, showing app screenshots, answering common questions, and providing an APK download button.

The third objective was to develop and implement the mobile application and website with the planned functions. This objective was achieved by developing the mobile app using Dart and Flutter, integrating Firebase Authentication and Firestore database support, and creating the promotional website using HTML, CSS, and JavaScript. The application was tested on an Android device and improved through several stages of development. Features such as barcode scanning, notification setup, recipe ranking based on inventory items, grocery planning, AI assistant responses, dark mode, and profile preferences were added to make the app more complete and suitable for real use.

The project was also evaluated through a user feedback survey with 63 responses. The survey results were generally positive. The app received an average score of 3.98 out of 5 for being easy to understand, and 74.2% of valid respondents selected 4 or 5 for this statement. The expiry indicator feature received an average score of 3.94 out of 5, while the overall satisfaction score was 3.81 out of 5. In terms of feature usefulness, the predictive grocery plan was selected 41 times, expiry reminders 34 times, recipe suggestions 32 times, and the AI assistant 26 times. These results show that the main features of EcoBite were relevant to user needs.

The survey also showed that users believed EcoBite could support food waste reduction. A total of 60.3% of respondents answered “Yes” when asked whether EcoBite can help reduce food waste, while 27.0% answered “Maybe.” Furthermore, 74.2% of valid respondents agreed that after using EcoBite, they would be more likely to use ingredients before they expire. This indicates that EcoBite has potential to encourage better food management habits.

**Suggested table placement:**

- Insert **Table 5.1: Summary of Objective Achievement** after the paragraph explaining the three objectives. This table can include three columns: Objective, Implementation Result, and Evidence from Findings.

## 5.2 Conclusion

In conclusion, the EcoBite project successfully achieved its main aim of developing a smart kitchen assistant application to support household food waste reduction. The final prototype provides users with tools to monitor kitchen inventory, track expiry dates, receive recipe suggestions, plan groceries, scan barcodes, ask food-related questions, and customize their preferences. These features are connected to the core problem identified in the project, which is the lack of awareness and planning that often leads to food waste at home.

The completed application shows that technology can be used to support simple but meaningful daily decisions. Instead of only reminding users about expiry dates, EcoBite combines several related functions into one system. For example, an item added to the kitchen inventory can influence expiry reminders, recipe suggestions, and grocery planning. This makes the app more practical because the features support one another rather than working separately.

The survey results also support the conclusion that EcoBite is useful and understandable for users. Most respondents found the app easy to understand, and many agreed that the expiry indicators, grocery plan, and recipe suggestions were helpful. The positive response toward predictive grocery planning and waste-saving tips shows that users value features that help them make decisions faster and reduce unnecessary waste.

However, the project also shows that EcoBite is still a prototype and can be improved further. Some users suggested clearer expiry alerts, more recipe variety, faster loading times, better barcode scanning, more customizable notifications, larger font options, and more language support. These suggestions show that while the app’s core idea is strong, future improvements are needed to make the system more reliable, accessible, and complete.

Overall, EcoBite meets the project objectives and demonstrates a practical solution for household food management. The project contributes to the use of mobile technology for sustainability by encouraging users to cook with available ingredients, reduce overbuying, and use food before it expires.

### 5.2.1 Achievement of Project Objectives

The project objectives were achieved through the design, development, and evaluation of the EcoBite system. The first objective was achieved by identifying user needs related to food expiry, grocery planning, and meal decision-making. The second objective was achieved by designing the app and website around these needs. The third objective was achieved by developing the functional mobile app and promotional website.

The implementation of the kitchen inventory and expiry tracking features directly addressed the problem of forgotten food items. The recipe suggestion feature helped users make use of available ingredients. The predictive grocery plan helped users identify what they need to buy instead of purchasing unnecessary items. The AI assistant provided additional food-related guidance, while the barcode scanner improved convenience when adding items.

From the evaluation results, users responded positively to the app’s purpose and features. This shows that the final output is aligned with the project aim and has potential for real-world use if further enhanced.

### 5.2.2 Limitations of the Study

Although the project achieved its objectives, several limitations were identified during development and evaluation. Firstly, the application was mainly tested on Android. Since iOS requires Apple development tools, certificates, and TestFlight or App Store distribution, the iOS version was not fully tested in this project phase. Therefore, the current downloadable APK is only suitable for Android users.

Secondly, the recipe database is limited to the recipes included during development. Although the app contains a variety of recipes and website references, it does not yet have a large-scale dynamic recipe database like commercial recipe platforms. As a result, recipe variety may still be limited for users with very specific ingredients or dietary needs.

Thirdly, the AI assistant is a focused food-related assistant rather than a full advanced AI model. It can answer questions related to food waste, storage, recipes, and grocery planning based on the app’s knowledge base, but it may not handle very complex or unrelated questions.

Fourthly, barcode scanning depends on available product data. If an item barcode is not found in the database or lookup source, the user may still need to enter details manually. This means barcode scanning improves convenience but does not completely remove manual input.

Fifthly, the survey results were based on 63 respondents, which is useful for FYP evaluation but still limited compared to a larger real-world user study. The respondents mainly represented young adults, so future evaluation should include a wider group of users such as families, working parents, and older adults.

Finally, the app update process is not fully automatic. The website can provide an APK download link, but Android users still need to manually confirm installation when updating the app. For iOS, updates would need to be managed through TestFlight or the App Store.

### 5.2.3 Project Contribution

This project contributes by providing a mobile application that combines several food management features in one system. Many existing apps focus only on recipes, grocery lists, or reminders separately. EcoBite attempts to connect these functions through the user’s kitchen inventory so that the app can provide more relevant support.

The project also contributes to sustainable technology by encouraging users to reduce food waste through practical daily actions. Instead of presenting sustainability only as information, EcoBite turns it into app functions such as expiry indicators, waste-saving tips, recipe suggestions, and grocery planning. This makes the sustainability goal more actionable for users.

From a development perspective, the project demonstrates the use of Flutter, Firebase, Firestore, notification services, barcode scanning, and web promotion in a single FYP system. The promotional website also contributes by making the app easier to explain and distribute to users.

From a user experience perspective, EcoBite shows how a simple visual design, clear navigation, and connected features can make kitchen management easier. The survey results suggest that users responded positively to the app’s core concept and found its main features useful.

## 5.3 Recommendations and Future Enhancements

Based on the findings and limitations, several recommendations are suggested for future development.

Firstly, the expiry reminder system should be improved. Some respondents suggested clearer expiry date alerts. Future versions can include stronger notification options, reminder frequency settings, quiet hours, and priority reminders for items expiring within one day. This would make the reminder system more flexible and useful for different user habits.

Secondly, the recipe database should be expanded. Users suggested more recipe variety and better recipe search. Future work can include a larger recipe database with more cuisines, cooking times, dietary filters, and ingredient substitutions. This would make the recipe suggestion feature more helpful, especially for users with limited ingredients or specific food preferences.

Thirdly, the barcode scanner can be improved by connecting it to a larger product database. This would increase the chance of recognizing scanned products and reduce the need for manual entry. Future versions can also allow users to contribute missing barcode information to improve the database over time.

Fourthly, the AI assistant can be enhanced with more advanced natural language processing. The current assistant is useful as a focused helper, but future versions could connect to a stronger AI model or cloud-based AI service. This would allow the assistant to provide more detailed answers, better recipe guidance, and more natural conversation.

Fifthly, the app can include a meal planning calendar. Some users suggested adding a meal planning feature. A weekly calendar would allow users to plan breakfast, lunch, and dinner using items in their inventory. This would strengthen the connection between recipe suggestions and grocery planning.

Sixthly, the app can include food waste progress tracking. For example, users could see how many items they used before expiry, how many expired, and how much money they may have saved. This would make the impact of using EcoBite more visible and could motivate users to continue using the app.

Seventhly, accessibility should be improved. Some respondents suggested larger font options and better usability. Future versions can include adjustable font sizes, clearer contrast settings, screen reader support, and simplified onboarding screens for first-time users.

Eighthly, the app should be tested with a wider range of users. Future evaluation should include students, families, working adults, and users who cook frequently. A longer testing period would also help measure whether EcoBite actually changes user behaviour over time.

Ninthly, the app update process can be improved. Since the APK download is hosted through GitHub Releases, the app can include a version check feature using Firebase. When a new version is available, the app can notify users and open the download link. This would make updates easier for Android users.

Finally, iOS deployment should be considered in future work. Since Flutter supports cross-platform development, the app can be prepared for iOS testing through TestFlight. This would allow EcoBite to reach a wider group of users beyond Android.

## 5.4 Chapter Summary

This chapter summarised the overall outcome of the EcoBite project and concluded that the project objectives were successfully achieved. The app was developed as a smart kitchen assistant that helps users manage food inventory, monitor expiry dates, receive recipe suggestions, plan groceries, and reduce food waste. A promotional website was also developed to introduce the app and provide an APK download link.

The survey results showed that users generally found EcoBite understandable, useful, and relevant to food waste reduction. The strongest features identified by users were predictive grocery planning, expiry reminders, recipe suggestions, waste-saving tips, and the AI assistant. These findings show that the app has potential to support better kitchen habits and reduce unnecessary food waste.

The chapter also discussed the limitations of the project, including limited iOS testing, limited recipe database size, barcode database dependency, prototype-level AI assistant, and the need for wider user testing. Recommendations were provided for future work, including improved notifications, larger recipe database, enhanced AI assistant, meal planning calendar, food waste progress tracking, better accessibility, and app update notifications.

Overall, EcoBite is a practical and relevant FYP project that applies mobile application development to a real household problem. The project demonstrates how technology can support sustainability by helping users make better food, cooking, and grocery decisions in daily life.
