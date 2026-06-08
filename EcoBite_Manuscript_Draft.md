# EcoBite: A Smart Kitchen Assistant Mobile Application with Promotional Website for Reducing Household Food Waste

Muhammad Rizky Fajri  
Bachelor of Information and Communication Technology  
Asia Pacific University of Technology & Innovation  

## Abstract

Household food waste remains a major sustainability issue because many users forget existing food items, overlook expiry dates, overbuy groceries, or struggle to decide what to cook with available ingredients. Although recipe and grocery applications are widely available, many of them function separately and do not fully connect inventory tracking, expiry monitoring, recipe suggestions, and grocery planning in one practical system. This project developed EcoBite, a smart kitchen assistant mobile application with a supporting promotional website to help users manage food items more effectively and reduce unnecessary food waste. The mobile application was developed using Dart and Flutter, while Firebase Authentication and Firestore were used to support user login and data storage. EcoBite includes kitchen inventory tracking, expiry indicators, recipe suggestions based on available ingredients, predictive grocery planning, barcode scanning, notification settings, user preferences, dark mode, and a food-focused AI assistant. The promotional website was developed using HTML, CSS, and JavaScript to explain the app features, display screenshots, provide frequently asked questions, and link users to the Android APK download. The prototype was evaluated through a user feedback survey involving 63 respondents. Results showed that the app received an average score of 3.98 out of 5 for ease of understanding, while 74.2% of valid respondents agreed that they would be more likely to use ingredients before they expire after using EcoBite. The most useful features identified were predictive grocery planning, expiry reminders, recipe suggestions, and the AI assistant. Overall, the findings indicate that EcoBite has potential as a practical mobile solution for improving household food management and supporting more sustainable consumption habits.

**Keywords:** EcoBite, food waste reduction, smart kitchen assistant, Flutter, Firebase

## 1. Introduction

Food waste is a serious global issue that affects the environment, economy, and household spending. A large amount of edible food is wasted at the household level because people often buy more than they need, forget what they already have, or fail to use ingredients before they expire. The United Nations Environment Programme (2024) reported that households are responsible for a major share of global food waste. Food waste also contributes to greenhouse gas emissions because wasted food represents wasted water, land, energy, labour, and transport resources used during production and distribution (Food and Agriculture Organization, 2022).

In everyday life, many users do not have a consistent method for tracking kitchen items. Some users rely on memory, paper lists, or basic note applications, but these methods do not provide automatic reminders or recipe suggestions. Recipe applications may help users find meals, but they often recommend recipes without checking what ingredients the user already owns. Grocery list applications may help users shop, but they do not always prevent duplicate purchases. As a result, users may still overbuy food, leave ingredients unused, and throw away items that could have been cooked earlier.

Mobile technology provides an opportunity to support better food management habits. A mobile application can help users record kitchen items, check expiry dates, receive reminders, and plan meals based on what is already available. By combining inventory tracking, recipe suggestions, grocery planning, and food-related assistance, a smart kitchen assistant can help users make better decisions before food becomes waste.

This project developed EcoBite, a smart kitchen assistant mobile application supported by a promotional website. The mobile app is designed to help users manage kitchen inventory, monitor expiry dates, receive recipe suggestions, plan groceries, scan product barcodes, and ask food-related questions through an AI assistant. The promotional website introduces the app, explains its main features, displays screenshots, answers common questions, and provides access to the Android APK download.

The paper is arranged as follows. Section 2 explains the problem statement. Section 3 reviews related work and technologies. Section 4 explains the methodology used in the project. Section 5 describes the development of the EcoBite mobile application and website. Section 6 presents the results and analysis from user evaluation. Section 7 concludes the paper and Section 8 presents future enhancements.

## 2. Problem Statement

Household food waste often happens because users do not have a clear view of their available ingredients and expiry dates. Even when food is still edible, it may be forgotten at the back of the fridge or cabinet until it is no longer suitable to consume. This problem is especially common among students, busy adults, and households that do not plan meals or groceries consistently.

Existing applications only partially solve this issue. Recipe apps normally focus on showing meals, while grocery apps focus on listing items to buy. Inventory apps may allow users to record items, but they may not provide recipe suggestions or grocery planning based on the recorded ingredients. This separation makes it difficult for users to manage the full food cycle from buying ingredients to cooking and using them before expiry.

Therefore, there is a need for a user-friendly mobile application that can connect kitchen inventory, expiry awareness, recipe recommendation, grocery planning, and food-related assistance in one system. The main problem addressed by this project is how to help users reduce food waste by making their available ingredients more visible and actionable.

## 3. Literature Review

Food waste reduction has become an important research area because it is connected to sustainability, responsible consumption, and environmental protection. Previous research has shown that digital tools and persuasive technology can influence user behaviour by reminding users, increasing awareness, and encouraging better planning (Nkwo et al., 2021). Smartphone applications are suitable for this purpose because they are accessible, personal, and can support daily decision-making.

Recipe recommendation systems are commonly used to suggest meals based on user preferences, ingredients, or dietary needs. Recommendation approaches can include content-based filtering, collaborative filtering, and hybrid recommendation models. Content-based recommendation is useful for a project like EcoBite because recipes can be matched against available ingredients and user preferences (Yap et al., 2024). However, many recommendation systems focus mainly on preference and do not prioritise expiry urgency.

Inventory management is another relevant area. Inventory systems help users record items, monitor stock levels, and avoid unnecessary purchases. In a household context, inventory tracking can help users understand what they already have before shopping. When combined with expiry reminders, inventory tracking can also encourage users to use older items first.

Natural language processing and AI assistant concepts are also relevant to food management applications. Food-related assistants can help users ask questions such as what to cook, how to store ingredients, or what items are expiring soon. Studies on meal recommendation and food assistance show that conversational interfaces can make recommendation systems easier to use, especially for users who prefer asking questions instead of manually searching through menus (Xu et al., 2024).

Several existing systems address food management, but many of them focus on only one area. For example, some applications focus on recipes, while others focus on grocery shopping or food expiry reminders. The research gap identified in this project is the need for a more connected system that links inventory tracking, expiry indicators, recipe suggestions, grocery planning, and user preferences in one mobile app.

## 4. Methodology

The project used a combination of user-centred design and iterative development. User-centred design was suitable because the system needed to solve a daily household problem in a way that users could understand easily. The development process involved analysing user needs, designing the interface, building the prototype, testing features, improving the app, and evaluating user feedback.

The mobile application was developed using Dart and Flutter. Flutter was selected because it supports cross-platform mobile development and allows the interface to be built consistently. Firebase Authentication was used for user login and account creation, while Firestore was used to store user-related kitchen data such as inventory items and preferences. The promotional website was developed using HTML, CSS, and JavaScript and hosted through GitHub Pages.

The main application features were developed around the project objectives. The kitchen inventory feature allows users to add, edit, delete, search, and filter food items. The expiry tracking feature uses visual indicators to show items that are expiring soon or already expired. The recipe suggestion feature compares recipes with items in the inventory and ranks recipes based on available ingredients. The grocery planning feature suggests missing recipe ingredients and common staples. The barcode scanner helps users add items more quickly, while the AI assistant provides focused food-related responses.

For evaluation, a user feedback survey was conducted after users viewed or tested the EcoBite prototype. The survey collected 63 responses and measured respondent background, usability, feature usefulness, food waste reduction potential, satisfaction, and recommendation intention. The survey included scale-based questions, multiple-choice questions, and open-ended feedback.

## 5. Development of EcoBite

EcoBite consists of two main parts: the mobile application and the promotional website. The mobile application is the main system used by users to manage food items. The website supports the application by promoting its features and providing an APK download link.

The home dashboard was developed to give users a quick overview of items that need attention. It shows important expiry information and waste-saving tips. This allows users to identify urgent food items without opening every section of the app.

The kitchen inventory screen allows users to record food items with information such as item name, quantity, category, and expiry date. Items expiring within a short period are highlighted using warning colours. Expired items are marked clearly so users can decide whether to remove them from the inventory. Barcode scanning was added to make item entry faster and more convenient.

The recipe suggestion feature was developed to reduce the problem of not knowing what to cook. Recipes are suggested based on ingredients already available in the inventory. The app also shows missing ingredients and allows users to add missing items into the grocery plan. Dietary preferences can influence which recipes are displayed.

The predictive grocery plan was developed to help users shop more carefully. Instead of creating a generic shopping list, the app suggests items based on missing recipe ingredients, staples, inventory data, and user preferences. This helps reduce duplicate purchases and supports smarter grocery planning.

The AI assistant was developed as a focused food-related helper. It provides responses related to food waste reduction, storage advice, recipe ideas, grocery planning, and kitchen inventory. A thinking animation and gradual text display were added to improve the user experience.

The promotional website was designed using the same green, light green, and white theme as the app. It includes a hero section, feature previews, app screenshots, a how-it-works section, FAQ section, and download buttons. The website is intended for promotion and app distribution, not as a functional web version of the mobile app.

## 6. Results and Analysis

The EcoBite prototype was evaluated through a user feedback survey with 63 respondents. Most respondents were young adults. A total of 28 respondents, or 44.4%, were aged 18 to 24, while 22 respondents, or 34.9%, were aged 25 to 34. This shows that the survey mainly represented students and young working adults, which matches the target user group of the application.

The survey showed that food expiry awareness is a relevant issue. A total of 33 respondents, or 52.4%, stated that they sometimes forget food items until they expire. Another 5 respondents, or 7.9%, stated that this happens often. Grocery planning was also an issue because only 30.2% of respondents stated that they always plan groceries before shopping.

The usability results were generally positive. For the statement that EcoBite was easy to understand when first opened, the average score was 3.98 out of 5. A total of 74.2% of valid respondents selected a score of 4 or 5. The app layout and navigation received an average score of 3.82 out of 5, with 62.9% of valid respondents selecting 4 or 5. These results suggest that users generally found the app understandable and usable.

In terms of feature usefulness, the most selected useful feature was the predictive grocery plan, chosen 41 times. This was followed by expiry reminders with 34 selections, recipe suggestions with 32 selections, and the AI assistant with 26 selections. This indicates that users valued features that helped them plan meals and groceries more efficiently.

The expiry indicator feature received an average score of 3.94 out of 5, with 66.1% of valid respondents selecting 4 or 5. Recipe suggestions received an average score of 3.76 out of 5, while the grocery plan received an average score of 3.73 out of 5. These findings show that users generally agreed that the main features were useful, although there is still room for improvement.

The food waste reduction results were also encouraging. A total of 60.3% of respondents believed that EcoBite can help reduce food waste, while 27.0% answered “Maybe.” In addition, 74.2% of valid respondents agreed that after using EcoBite, they would be more likely to use ingredients before they expire. This suggests that the app has potential to influence user behaviour toward more responsible food usage.

Open-ended responses showed that users liked predictive grocery planning, waste-saving tips, and the AI assistant. The most common improvement suggestions were clearer expiry date alerts, more recipe variety, faster loading times, more customizable notifications, better barcode scanning, and larger font options. These findings provide useful direction for future improvement.

## 7. Conclusion

This project successfully developed EcoBite, a smart kitchen assistant mobile application with a supporting promotional website. The application addresses household food waste by helping users track food items, monitor expiry dates, receive recipe suggestions, plan groceries, scan barcodes, and ask food-related questions. The promotional website supports the app by explaining its features and providing access to the Android APK download.

The survey results showed that users generally found EcoBite understandable, useful, and relevant to food waste reduction. The strongest features identified were predictive grocery planning, expiry reminders, recipe suggestions, and the AI assistant. These results indicate that the project objectives were achieved and that EcoBite has potential as a practical tool for improving household food management.

Although the prototype is functional, it still has limitations. The current APK is focused on Android, while iOS deployment remains future work. The recipe database is limited, barcode recognition depends on available product data, and the AI assistant is a focused helper rather than a full advanced AI model. Despite these limitations, the project demonstrates how mobile technology can support more sustainable food habits through practical daily features.

## 8. Future Enhancement

Future development can improve EcoBite in several ways. Firstly, the expiry reminder system can be enhanced with stronger notification options, reminder frequency settings, and quiet hours. Secondly, the recipe database can be expanded with more cuisines, dietary options, cooking times, and ingredient substitution suggestions. Thirdly, the barcode scanner can be connected to a larger product database to improve scan accuracy.

The AI assistant can also be improved by connecting it to a stronger AI model or cloud-based language service. This would allow the assistant to provide more detailed and natural responses. Another useful enhancement is a meal planning calendar that allows users to schedule meals for the week based on inventory items. EcoBite can also include food waste progress tracking, such as showing how many items were used before expiry and how much money may have been saved.

Finally, future work should include wider user testing with families, working adults, and frequent home cooks. iOS deployment should also be explored through TestFlight or the App Store so that the application can reach more users.

## Acknowledgement

I would like to express my sincere appreciation to my supervisor, Sir Ahmad Luqman, for the guidance, advice, and feedback provided throughout the development of this Final Year Project. I would also like to thank the respondents who participated in the EcoBite user feedback survey, as their opinions helped evaluate the usefulness and usability of the application. Finally, I am grateful to my family, friends, and lecturers for their support and encouragement during the completion of this project.

## References

Food and Agriculture Organization. (2022). *Food wastage footprint and climate change*. FAO.

Mathisen, R., et al. (2022). The impact of smartphone apps designed to reduce food waste. *Frontiers in Nutrition*. https://pmc.ncbi.nlm.nih.gov/articles/PMC9482070/

Nkwo, M., et al. (2021). Persuasive apps for sustainable waste management. *Frontiers in Artificial Intelligence, 4*, Article 748454. https://doi.org/10.3389/frai.2021.748454

United Nations Environment Programme. (2024). *Food Waste Index Report 2024*. UNEP.

Xu, Z., et al. (2024). Developing a personalized meal recommendation system for chronic disease prevention. *JMIR Formative Research, 8*, e52170. https://doi.org/10.2196/52170

Yap, Z. T., Roy, A., & Lim, K. (2024). Hybrid-based food recommender system utilizing KNN and SVD. *Cogent Engineering, 11*(1), 2436125. https://doi.org/10.1080/23311916.2024.2436125
