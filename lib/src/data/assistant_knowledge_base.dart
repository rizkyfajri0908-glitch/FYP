import '../models/assistant_knowledge.dart';

class AssistantKnowledgeBase {
  const AssistantKnowledgeBase._();

  static const entries = [
    AssistantKnowledge(
      id: 'reduce_food_waste',
      question: 'How can I reduce food waste at home?',
      answer:
          'Start with a first-in, first-out habit: keep older food at the front, plan meals around items expiring in 1 to 3 days, and check your inventory before shopping.',
      keywords: ['reduce', 'food waste', 'waste less', 'avoid waste'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'store_vegetables',
      question: 'How should I store vegetables?',
      answer:
          'Keep leafy vegetables dry, wrap them loosely with kitchen paper, and store them in the fridge. Use soft vegetables in soup, fried rice, curry, or stir-fry.',
      keywords: ['vegetable', 'vegetables', 'store', 'storage', 'leafy'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'store_fruits',
      question: 'How should I store fruits?',
      answer:
          'Separate fruits that ripen quickly, like bananas and apples, from delicate produce. Overripe fruit can still be used in smoothies, pancakes, oats, or baking.',
      keywords: ['fruit', 'banana', 'apple', 'overripe', 'store fruit'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'leftover_rice',
      question: 'What can I do with leftover rice?',
      answer:
          'Leftover rice is great for fried rice, rice porridge, rice bowls, or tomato rice soup. Cool it quickly and keep it refrigerated.',
      keywords: ['leftover rice', 'rice', 'fried rice', 'porridge'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'leftover_chicken',
      question: 'What can I do with leftover chicken?',
      answer:
          'Use cooked chicken in sandwiches, wraps, fried rice, soup, pasta salad, or a healthy rice bowl.',
      keywords: ['leftover chicken', 'chicken', 'cooked chicken'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'expiring_milk',
      question: 'What can I make with milk before it expires?',
      answer:
          'Use milk in pancakes, oatmeal, scrambled eggs, creamy pasta, soup, smoothies, or banana oat pancakes.',
      keywords: ['milk', 'expiring milk', 'use milk', 'dairy'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'stale_bread',
      question: 'What can I do with stale bread?',
      answer:
          'Stale bread can become toast, breadcrumbs, croutons, bread pudding, egg sandwiches, or banana milk toast.',
      keywords: ['stale bread', 'bread', 'toast', 'breadcrumbs'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'soft_tomatoes',
      question: 'What can I do with soft tomatoes?',
      answer:
          'Soft tomatoes are best cooked into pasta sauce, tomato egg stir fry, tomato rice soup, curry base, or stew.',
      keywords: ['soft tomato', 'tomatoes', 'tomato', 'sauce'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'wilted_spinach',
      question: 'Can I still use wilted spinach?',
      answer:
          'If it smells normal and is not slimy, wilted spinach can be cooked into omelettes, soup, pasta, rice bowls, or stir-fry.',
      keywords: ['wilted spinach', 'spinach', 'leafy greens'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'freeze_food',
      question: 'What foods can I freeze?',
      answer:
          'You can freeze cooked rice portions, bread, cooked chicken, herbs, ripe bananas, soup, curry, pasta sauce, and many leftovers.',
      keywords: ['freeze', 'freezer', 'frozen', 'can i freeze'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'meal_planning',
      question: 'How should I plan meals to reduce waste?',
      answer:
          'Pick 2 or 3 ingredients expiring soon, choose recipes that use them together, and only buy missing items from your grocery plan.',
      keywords: ['meal plan', 'planning', 'plan meals', 'weekly meals'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'shopping_list',
      question: 'How do I avoid buying too much food?',
      answer:
          'Check your kitchen inventory first, build a shopping list from missing recipe items, and avoid buying duplicates of ingredients you already have.',
      keywords: ['shopping', 'buy too much', 'grocery', 'shopping list'],
      category: 'grocery',
    ),
    AssistantKnowledge(
      id: 'expiry_dates',
      question: 'How should I use expiry dates?',
      answer:
          'Use expiry dates as planning signals. Prioritise items expiring today, then items expiring within 1 to 3 days.',
      keywords: ['expiry', 'expire', 'expiration', 'date'],
      category: 'expiry',
    ),
    AssistantKnowledge(
      id: 'best_before',
      question: 'What is the difference between best before and expiry?',
      answer:
          'Best before is usually about quality, while expiry/use-by is about safety. If unsure, be careful with dairy, meat, seafood, and cooked leftovers.',
      keywords: ['best before', 'use by', 'expiry difference'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'food_safety',
      question: 'How do I know food is unsafe?',
      answer:
          'Do not use food that smells bad, feels slimy, has unusual mold, or has been left at room temperature too long. When in doubt, do not risk it.',
      keywords: ['unsafe', 'safe', 'smell', 'slimy', 'mold', 'mould'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'budget_meals',
      question: 'What are budget-friendly meals?',
      answer:
          'Budget meals include fried rice, egg rice, potato curry, lentil soup, tomato pasta, rice porridge, tuna rice bowls, and vegetable noodle soup.',
      keywords: ['budget', 'cheap', 'affordable', 'low cost'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'quick_meals',
      question: 'What are quick meals I can cook?',
      answer:
          'Quick meals include tomato egg stir fry, garlic egg noodles, spinach omelette, tuna rice bowl, vegetable fried rice, and banana oatmeal.',
      keywords: ['quick', 'fast', '15 minutes', 'easy meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'healthy_meals',
      question: 'What are healthy meals?',
      answer:
          'Healthy options include chicken salad, vegetable rice bowls, lentil tomato soup, spinach egg bowls, quinoa chickpea bowls, and salmon spinach rice.',
      keywords: ['healthy', 'healthier', 'balanced', 'nutrition'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'halal_meals',
      question: 'How do I keep meals halal?',
      answer:
          'Avoid pork, bacon, ham, gelatin, alcohol, wine, and beer. Choose halal-certified meat or vegetarian, seafood, egg, and vegetable-based meals.',
      keywords: ['halal', 'muslim', 'pork', 'gelatin'],
      category: 'diet',
    ),
    AssistantKnowledge(
      id: 'vegetarian_meals',
      question: 'What vegetarian meals can I make?',
      answer:
          'Try vegetable fried rice, tomato pasta, potato carrot curry, spinach omelette, chickpea salad, tofu stir fry, or pumpkin soup.',
      keywords: ['vegetarian', 'veggie', 'no meat'],
      category: 'diet',
    ),
    AssistantKnowledge(
      id: 'dairy_free_meals',
      question: 'What dairy-free meals can I make?',
      answer:
          'Try tomato pasta without cheese, chicken rice soup, vegetable fried rice, tuna rice bowls, lentil soup, or dairy-free curry.',
      keywords: ['dairy free', 'no milk', 'lactose', 'without dairy'],
      category: 'diet',
    ),
    AssistantKnowledge(
      id: 'portion_control',
      question: 'How do I avoid leftover waste?',
      answer:
          'Cook smaller portions, store leftovers in clear containers, label the date, and turn leftovers into lunch within the next day or two.',
      keywords: ['leftovers', 'portion', 'too much food'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'fridge_organisation',
      question: 'How should I organise my fridge?',
      answer:
          'Keep urgent items at eye level, group similar ingredients together, use clear containers, and put older food in front.',
      keywords: ['fridge', 'organise', 'organize', 'refrigerator'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'stock_from_scraps',
      question: 'Can I use vegetable scraps?',
      answer:
          'Yes. Clean carrot peels, onion ends, celery leaves, and herb stems can be frozen and later simmered into vegetable stock.',
      keywords: ['scraps', 'peels', 'stock', 'vegetable stock'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'batch_cooking',
      question: 'Is batch cooking good for reducing waste?',
      answer:
          'Yes, if you freeze or schedule the portions. Batch cook sauces, soups, curry, and rice portions, then label them with dates.',
      keywords: ['batch', 'meal prep', 'prep', 'cook ahead'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'use_expiring_eggs',
      question: 'What can I make with eggs before they expire?',
      answer:
          'Use eggs in omelettes, fried rice, egg sandwiches, scrambled eggs, egg drop soup, pancakes, frittata, or rice bowls.',
      keywords: ['egg', 'eggs', 'expiring eggs', 'use eggs'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'store_herbs',
      question: 'How do I store fresh herbs?',
      answer:
          'Wrap herbs in slightly damp kitchen paper and keep them in a container, or freeze chopped herbs with oil or water in an ice cube tray.',
      keywords: [
        'herbs',
        'fresh herbs',
        'coriander',
        'parsley',
        'freeze herbs'
      ],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'store_bread',
      question: 'How do I keep bread fresh longer?',
      answer:
          'Keep bread sealed at room temperature for short use, or freeze slices so you can toast only what you need later.',
      keywords: ['bread', 'store bread', 'freeze bread', 'keep bread fresh'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'store_potatoes',
      question: 'How should I store potatoes?',
      answer:
          'Store potatoes in a cool, dark, dry place away from onions. If they are still firm, trim small sprouts and cook them soon.',
      keywords: ['potato', 'potatoes', 'sprout', 'store potatoes'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'store_onions',
      question: 'How should I store onions?',
      answer:
          'Store whole onions in a cool, dry, ventilated place. Keep cut onions sealed in the fridge and use them within a few days.',
      keywords: ['onion', 'onions', 'store onions'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'store_meat',
      question: 'How should I store raw meat?',
      answer:
          'Keep raw meat sealed on the lowest fridge shelf, away from ready-to-eat food. Freeze it if you will not cook it soon.',
      keywords: ['raw meat', 'meat', 'chicken', 'beef', 'store meat'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'store_seafood',
      question: 'How should I store seafood?',
      answer:
          'Seafood spoils quickly. Keep it very cold, cook it as soon as possible, and avoid using it if it smells sour or ammonia-like.',
      keywords: ['seafood', 'fish', 'shrimp', 'prawns', 'store fish'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'leftover_pasta',
      question: 'What can I do with leftover pasta?',
      answer:
          'Turn leftover pasta into pasta salad, tomato pasta bake, stir-fried noodles style pasta, soup add-ins, or a quick lunch bowl.',
      keywords: ['leftover pasta', 'pasta leftovers', 'pasta'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'leftover_vegetables',
      question: 'What can I do with leftover vegetables?',
      answer:
          'Use leftover vegetables in fried rice, omelettes, soup, curry, stir-fry, pasta sauce, wraps, or rice bowls.',
      keywords: ['leftover vegetables', 'leftover veg', 'vegetables'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'leftover_fish',
      question: 'What can I do with leftover fish?',
      answer:
          'Use cooked fish in rice bowls, sandwiches, salads, pasta, fried rice, or fish patties. Keep it chilled and use it soon.',
      keywords: ['leftover fish', 'fish leftovers', 'cooked fish'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'rice_safety',
      question: 'Is leftover rice safe?',
      answer:
          'Leftover rice can be safe if cooled quickly, refrigerated, and reheated until hot. Do not leave cooked rice at room temperature for long.',
      keywords: ['rice safe', 'leftover rice safe', 'reheat rice'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'reheat_leftovers',
      question: 'How should I reheat leftovers?',
      answer:
          'Reheat leftovers until steaming hot throughout. Only reheat what you plan to eat, and avoid repeatedly reheating the same portion.',
      keywords: ['reheat', 'leftovers', 'heat up', 'microwave'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'moldy_food',
      question: 'Can I eat moldy food?',
      answer:
          'Avoid moldy soft foods like bread, cooked rice, sauces, fruit, and dairy. Hard foods may sometimes be trimmed, but be cautious.',
      keywords: ['mold', 'mould', 'moldy', 'mouldy'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'smelly_food',
      question: 'What if food smells strange?',
      answer:
          'A sour, rotten, or unusual smell is a warning sign. Do not taste food to check safety; discard it if you are unsure.',
      keywords: ['smell', 'smelly', 'bad smell', 'sour smell'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'freezer_burn',
      question: 'What is freezer burn?',
      answer:
          'Freezer burn happens when food dries out in the freezer. It is usually a quality issue, not always a safety issue, but texture may be worse.',
      keywords: ['freezer burn', 'freezer', 'frozen dry'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'label_freezer_food',
      question: 'How should I label frozen food?',
      answer:
          'Label frozen food with the item name, date frozen, and portion size. This makes it easier to use older frozen food first.',
      keywords: ['label frozen', 'freezer label', 'date frozen'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'pantry_rotation',
      question: 'How do I manage pantry items?',
      answer:
          'Rotate pantry items by putting newer packs behind older ones. Check rice, pasta, flour, canned food, and sauces before shopping.',
      keywords: ['pantry', 'cupboard', 'rotate pantry', 'dry food'],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'use_canned_food',
      question: 'How can I use canned food?',
      answer:
          'Canned tuna, beans, tomatoes, and chickpeas are useful for quick rice bowls, pasta, soups, salads, wraps, and budget meals.',
      keywords: ['canned', 'tin', 'tinned', 'canned food'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'protein_ideas',
      question: 'What protein meals can I make?',
      answer:
          'Protein-focused meals include chicken rice bowls, tuna pasta salad, egg fried rice, tofu stir fry, salmon rice, beef stew, and chickpea salad.',
      keywords: ['protein', 'high protein', 'protein meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'breakfast_ideas',
      question: 'What breakfast can I make?',
      answer:
          'Try banana oat pancakes, milk oatmeal, avocado egg toast, creamy scrambled eggs, Greek yogurt fruit bowl, or banana milk toast.',
      keywords: ['breakfast', 'morning meal', 'oats', 'toast'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'lunch_ideas',
      question: 'What lunch can I make?',
      answer:
          'Good lunch options include wraps, fried rice, rice bowls, pasta salad, egg sandwiches, vegetable noodle soup, or tuna rice bowls.',
      keywords: ['lunch', 'lunch ideas', 'midday'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'dinner_ideas',
      question: 'What dinner can I make?',
      answer:
          'Dinner ideas include chicken curry rice, tomato pasta, vegetable soup, chicken noodle stir fry, potato carrot curry, or tomato chicken rice.',
      keywords: ['dinner', 'dinner ideas', 'tonight'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'one_pot_meals',
      question: 'What one-pot meals can I make?',
      answer:
          'Try chicken congee, tomato chicken rice, lentil tomato soup, potato carrot curry, chicken rice soup, tomato potato stew, or beef potato stew.',
      keywords: ['one pot', 'one-pot', 'easy cleanup'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'no_cook_meals',
      question: 'What no-cook meals can I make?',
      answer:
          'No-cook ideas include chickpea cucumber salad, tuna salad, hummus vegetable wraps, veggie pita pockets, yogurt fruit bowls, and cucumber tomato tuna salad.',
      keywords: ['no cook', 'no-cook', 'without cooking'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_sauces',
      question: 'How can sauces reduce waste?',
      answer:
          'Sauces help combine leftovers. Use tomato sauce, curry sauce, soy garlic sauce, yogurt dressing, or peanut sauce to turn mixed ingredients into a meal.',
      keywords: ['sauce', 'sauces', 'dressing'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'smart_grocery_buying',
      question: 'What groceries should I buy smartly?',
      answer:
          'Buy flexible staples like eggs, rice, pasta, onions, carrots, canned tuna, canned tomatoes, beans, and frozen vegetables because they support many meals.',
      keywords: ['smart groceries', 'what groceries', 'staples'],
      category: 'grocery',
    ),
    AssistantKnowledge(
      id: 'avoid_duplicate_buying',
      question: 'How do I stop buying duplicates?',
      answer:
          'Open your inventory before shopping, check pantry staples, and only buy missing recipe ingredients or items you are truly low on.',
      keywords: ['duplicate', 'buy duplicates', 'already have'],
      category: 'grocery',
    ),
    AssistantKnowledge(
      id: 'shopping_frequency',
      question: 'How often should I buy groceries?',
      answer:
          'Smaller, more frequent grocery trips can reduce waste if you often overbuy. For pantry staples, buy less often and rotate older packs first.',
      keywords: ['how often shop', 'shopping frequency', 'grocery trips'],
      category: 'grocery',
    ),
    AssistantKnowledge(
      id: 'meal_priority',
      question: 'What should I cook first?',
      answer:
          'Cook ingredients that are expired today or within 1 to 3 days first, especially dairy, meat, seafood, leafy greens, and cut fruit.',
      keywords: ['cook first', 'priority', 'what first'],
      category: 'expiry',
    ),
    AssistantKnowledge(
      id: 'expiry_today',
      question: 'What should I do if something expires today?',
      answer:
          'Use it today if it still looks and smells normal, cook it into a meal, or freeze it if the food type freezes well.',
      keywords: ['expires today', 'expiry today', 'today'],
      category: 'expiry',
    ),
    AssistantKnowledge(
      id: 'expired_food',
      question: 'Can I use expired food?',
      answer:
          'Be careful. Do not use expired meat, seafood, dairy, or cooked leftovers if they smell strange or look unsafe. Safety comes before waste reduction.',
      keywords: ['expired', 'past expiry', 'expired food'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'child_friendly_meals',
      question: 'What family-friendly meals reduce waste?',
      answer:
          'Family-friendly waste-saving meals include fried rice, pasta bake, chicken soup, egg sandwiches, rice bowls, wraps, and banana pancakes.',
      keywords: ['family', 'kids', 'child', 'family meals'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'small_household',
      question: 'How can a small household reduce waste?',
      answer:
          'Buy smaller packs, freeze portions, cook flexible meals, and avoid opening too many perishable items at once.',
      keywords: ['small household', 'one person', 'two people'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'large_household',
      question: 'How can a large household reduce waste?',
      answer:
          'Use shared meal planning, label leftovers, assign a leftover day, and cook large flexible dishes like soup, curry, rice bowls, and pasta.',
      keywords: ['large household', 'family waste', 'many people'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'leftover_day',
      question: 'What is a leftover day?',
      answer:
          'A leftover day is one planned meal where you combine safe leftovers into fried rice, soup, wraps, pasta, or rice bowls before buying more food.',
      keywords: ['leftover day', 'use leftovers', 'leftover night'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'smoothie_ideas',
      question: 'What can I put in smoothies?',
      answer:
          'Smoothies are good for ripe bananas, soft fruit, milk, yogurt, oats, peanut butter, or spinach that is still safe but not crisp.',
      keywords: ['smoothie', 'smoothies', 'ripe banana'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'soup_ideas',
      question: 'What ingredients are good for soup?',
      answer:
          'Soup is useful for carrots, potatoes, tomatoes, onions, spinach, chicken, rice, lentils, pumpkin, and vegetable scraps for stock.',
      keywords: ['soup', 'make soup', 'soup ingredients'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'fried_rice_ideas',
      question: 'What can I add to fried rice?',
      answer:
          'Fried rice works with leftover rice, eggs, chicken, carrots, spinach, onions, tomatoes, cabbage, tuna, tofu, or small vegetable portions.',
      keywords: ['fried rice', 'add to rice', 'rice meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'wrap_ideas',
      question: 'What can I put in wraps?',
      answer:
          'Wraps work with cooked chicken, tuna, egg, hummus, lettuce, cucumber, carrots, tomatoes, tofu, or leftover roasted vegetables.',
      keywords: ['wrap', 'wraps', 'tortilla'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'pasta_ideas',
      question: 'What can I add to pasta?',
      answer:
          'Pasta works with tomatoes, spinach, chicken, tuna, mushrooms, garlic, onions, milk-based sauce, or dairy-free tomato sauce.',
      keywords: ['pasta', 'add to pasta', 'pasta meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'food_inventory_benefit',
      question: 'Why should I track my kitchen inventory?',
      answer:
          'Inventory tracking helps you see what you already have, avoid duplicate shopping, prioritise expiring food, and match ingredients to recipes.',
      keywords: ['why inventory', 'track inventory', 'inventory benefit'],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'reduce_plate_waste',
      question: 'How do I reduce plate waste?',
      answer:
          'Serve smaller portions first and let people take seconds. Store extra food before it sits out too long.',
      keywords: ['plate waste', 'served too much', 'portion waste'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'composting',
      question: 'Should I compost food scraps?',
      answer:
          'Composting is useful for unavoidable scraps like peels and cores, but prevention is better: plan meals, store food well, and use edible parts first.',
      keywords: ['compost', 'composting', 'scraps'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'donate_food',
      question: 'Can I donate extra food?',
      answer:
          'Unopened shelf-stable food may be suitable for donation if it is within date and accepted by a local organisation. Do not donate unsafe or opened perishables.',
      keywords: ['donate', 'food donation', 'extra food'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'food_waste_environment',
      question: 'Why is food waste bad for the environment?',
      answer:
          'Food waste wastes money, water, energy, transport, and labour. When food rots in landfill, it can also produce greenhouse gases.',
      keywords: ['environment', 'why food waste bad', 'greenhouse'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'save_money',
      question: 'How does reducing food waste save money?',
      answer:
          'Using what you already have means fewer duplicate purchases, fewer thrown-away ingredients, and better meal planning from existing food.',
      keywords: ['save money', 'money', 'cost', 'budget saving'],
      category: 'waste',
    ),
    AssistantKnowledge(
      id: 'balanced_plate',
      question: 'How do I make a balanced meal?',
      answer:
          'A simple balanced plate has protein, vegetables or fruit, and a carbohydrate like rice, pasta, bread, oats, or potatoes.',
      keywords: ['balanced meal', 'balanced plate', 'nutrition'],
      category: 'nutrition',
    ),
    AssistantKnowledge(
      id: 'high_fibre_food',
      question: 'What foods are high in fibre?',
      answer:
          'High-fibre foods include oats, beans, lentils, chickpeas, vegetables, fruit, wholegrain bread, brown rice, and potatoes with skin.',
      keywords: ['fibre', 'fiber', 'high fibre', 'digestion'],
      category: 'nutrition',
    ),
    AssistantKnowledge(
      id: 'lower_sugar',
      question: 'How can I reduce sugar in meals?',
      answer:
          'Choose whole fruit instead of sweet drinks, use less sweet sauce, avoid adding extra sugar to oats, and balance sweet foods with protein or fibre.',
      keywords: ['sugar', 'less sugar', 'reduce sugar'],
      category: 'nutrition',
    ),
    AssistantKnowledge(
      id: 'lower_salt',
      question: 'How can I reduce salt?',
      answer:
          'Use herbs, garlic, onion, lemon, vinegar, spices, and pepper for flavour. Taste before adding more soy sauce, stock cubes, or salty sauces.',
      keywords: ['salt', 'less salt', 'sodium'],
      category: 'nutrition',
    ),
    AssistantKnowledge(
      id: 'food_allergy_note',
      question: 'Can you help with allergies?',
      answer:
          'I can remind you to check ingredient labels and avoid known allergens, but always follow medical advice and be careful with packaged food labels.',
      keywords: ['allergy', 'allergies', 'allergen'],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'vague_what_to_eat',
      question: 'I do not know what to eat.',
      answer:
          'Start by checking what expires first, then choose one protein, one vegetable, and one carbohydrate. If you have rice, pasta, bread, eggs, chicken, or vegetables, EcoBite can suggest a simple meal from those items.',
      keywords: [
        'dont know what to eat',
        "don't know what to eat",
        'what to eat',
        'hungry',
        'not sure what to eat',
        'meal idea',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'vague_easy_food',
      question: 'What is something easy I can make?',
      answer:
          'For an easy meal, use a base like rice, pasta, bread, or noodles, then add one available protein and any vegetable that needs to be used soon.',
      keywords: [
        'easy food',
        'easy meal',
        'simple food',
        'simple meal',
        'lazy meal',
        'quick idea',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'vague_use_random_food',
      question: 'How do I use random ingredients?',
      answer:
          'Group random ingredients into a simple format: rice bowl, fried rice, pasta, soup, stir-fry, sandwich, wrap, or omelette. Pick the format that matches what you already have.',
      keywords: [
        'random ingredients',
        'random food',
        'whatever i have',
        'use what i have',
        'anything in fridge',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'beginner_cooking',
      question: 'I am a beginner at cooking. What should I do?',
      answer:
          'Start with simple meals that are hard to ruin: fried rice, omelette, pasta, soup, sandwich, or rice bowl. Use EcoBite to choose ingredients that are already available and expiring soon.',
      keywords: [
        'beginner',
        'new to cooking',
        'cannot cook',
        'cant cook',
        "can't cook",
        'easy for beginners',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'student_meals',
      question: 'What meals are good for students?',
      answer:
          'Student-friendly meals include fried rice, egg noodles, tuna rice bowl, pasta with tomato sauce, chicken wraps, vegetable omelette, and cereal or oats for quick breakfasts.',
      keywords: [
        'student meal',
        'student food',
        'dorm food',
        'college food',
        'university meal',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'snack_ideas',
      question: 'What snacks can I make?',
      answer:
          'Quick snacks include toast, cereal with milk, fruit, yoghurt, egg sandwich, biscuits with milk, vegetable sticks, or a small rice bowl using leftovers.',
      keywords: ['snack', 'snacks', 'small food', 'light food'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'breakfast_ideas',
      question: 'What can I eat for breakfast?',
      answer:
          'Breakfast ideas include cereal with milk, toast, egg sandwich, oats, banana pancakes, yoghurt with fruit, or leftover rice with egg.',
      keywords: ['breakfast', 'morning food', 'eat in morning'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'lunch_ideas',
      question: 'What can I eat for lunch?',
      answer:
          'Lunch can be simple: rice bowl, fried rice, pasta, sandwich, wrap, soup, or noodles. Prioritise any item in your inventory that expires soon.',
      keywords: ['lunch', 'midday meal', 'afternoon meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'dinner_ideas',
      question: 'What can I eat for dinner?',
      answer:
          'Dinner ideas include stir-fry with rice, pasta, soup, chicken and vegetables, rice bowl, curry, or baked items using pantry ingredients.',
      keywords: ['dinner', 'night meal', 'evening meal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'almost_expired_ideas',
      question: 'What should I do with food that is almost expired?',
      answer:
          'Cook almost-expired food today if it still smells and looks normal. Good options are soup, fried rice, pasta sauce, stir-fry, curry, or freezing cooked portions.',
      keywords: [
        'almost expired',
        'nearly expired',
        'close to expiry',
        'food going bad',
        'use soon',
      ],
      category: 'expiry',
    ),
    AssistantKnowledge(
      id: 'too_many_vegetables',
      question: 'What can I do with too many vegetables?',
      answer:
          'Use extra vegetables in fried rice, soup, stir-fry, pasta, omelette, curry, wraps, or roasted vegetable bowls. Cook the softest vegetables first.',
      keywords: [
        'too many vegetables',
        'extra vegetables',
        'lots of vegetables',
        'use vegetables',
      ],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'too_much_rice',
      question: 'What can I do with too much rice?',
      answer:
          'Extra rice can become fried rice, rice porridge, rice soup, rice bowl, or packed lunch. Cool cooked rice quickly and refrigerate it.',
      keywords: ['too much rice', 'extra rice', 'lots of rice'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_chicken_breast',
      question: 'What can I make with chicken breast?',
      answer:
          'Chicken breast works well in fried rice, pasta, wraps, sandwiches, soup, stir-fry, chicken rice bowl, or salad. Cook it before expiry and store leftovers properly.',
      keywords: ['chicken breast', 'use chicken breast', 'chicken ideas'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_cabbage',
      question: 'What can I make with cabbage?',
      answer:
          'Cabbage is good in stir-fry, fried rice, soup, noodles, slaw, wraps, or cabbage egg stir-fry. It is useful for budget meals because it stretches portions.',
      keywords: ['cabbage', 'use cabbage', 'cabbage recipe'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_carrot',
      question: 'What can I make with carrots?',
      answer:
          'Carrots can be used in fried rice, soup, stir-fry, pasta sauce, curry, wraps, salad, or as a snack with dip.',
      keywords: ['carrot', 'carrots', 'use carrot'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_flour',
      question: 'What can I make with flour?',
      answer:
          'Flour can be used for pancakes, simple flatbread, batter, thickening soup or sauce, biscuits, or basic baking recipes.',
      keywords: ['flour', 'use flour', 'plain flour'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_elbow_pasta',
      question: 'What can I make with elbow pasta?',
      answer:
          'Elbow pasta works in mac and cheese, tomato pasta, pasta salad, soup, tuna pasta, chicken pasta, or vegetable pasta.',
      keywords: ['elbow pasta', 'macaroni', 'pasta shape'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_chocolate_milk',
      question: 'What can I do with chocolate milk?',
      answer:
          'Chocolate milk can be used in smoothies, oats, pancakes, chia pudding, iced drinks, or as a quick snack drink before it expires.',
      keywords: ['chocolate milk', 'use chocolate milk'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'use_cereal',
      question: 'What can I do with cereal?',
      answer:
          'Cereal can be eaten with milk, used as yoghurt topping, mixed into snack bars, crushed as a coating, or added to simple dessert bowls.',
      keywords: ['cereal', 'use cereal', 'breakfast cereal'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'food_smells_weird',
      question: 'What if my food smells weird?',
      answer:
          'If food smells sour, rotten, unusually strong, or feels slimy, do not risk eating it. EcoBite can help plan earlier use, but safety comes first.',
      keywords: [
        'smells weird',
        'bad smell',
        'smells bad',
        'is it safe',
        'food safety',
      ],
      category: 'safety',
    ),
    AssistantKnowledge(
      id: 'organize_fridge',
      question: 'How should I organize my fridge?',
      answer:
          'Keep older items at the front, group similar foods together, label leftovers with dates, and place soon-to-expire food where you can see it easily.',
      keywords: [
        'organize fridge',
        'fridge organization',
        'arrange fridge',
        'sort fridge',
      ],
      category: 'storage',
    ),
    AssistantKnowledge(
      id: 'no_time_to_cook',
      question: 'What if I do not have time to cook?',
      answer:
          'Choose fast meals such as fried rice, pasta, sandwich, wrap, omelette, cereal, or rice bowl. Use ingredients that are already prepared or expiring soon.',
      keywords: [
        'no time',
        'busy',
        'fast food at home',
        'quick cooking',
        'too busy',
      ],
      category: 'planning',
    ),
    AssistantKnowledge(
      id: 'unknown_barcode',
      question: 'What if a barcode is not found?',
      answer:
          'If a barcode is not found, enter the item name manually, choose a category, set the expiry date, and the app can still track it normally.',
      keywords: ['barcode not found', 'scan not found', 'unknown barcode'],
      category: 'inventory',
    ),
    AssistantKnowledge(
      id: 'qr_code_format',
      question: 'What barcode format works best?',
      answer:
          'Use a Code 128 barcode with a product ID such as CABBAGE001 or CHICKENBREAST001. EcoBite can scan that ID and find the item details from the product database.',
      keywords: ['barcode format', 'code 128', 'scan barcode'],
      category: 'inventory',
    ),
    AssistantKnowledge(
      id: 'recipe_matching',
      question: 'How does recipe matching work?',
      answer:
          'Recipe matching compares your inventory with recipe ingredients. Recipes with more available items appear higher, while recipes with no matching items are faded.',
      keywords: ['recipe matching', 'how recipes work', 'suggest recipes'],
      category: 'recipe',
    ),
    AssistantKnowledge(
      id: 'grocery_plan_explain',
      question: 'How does the grocery plan work?',
      answer:
          'The grocery plan suggests missing ingredients from good recipe matches and useful staples that are not currently in your inventory.',
      keywords: ['grocery plan', 'predictive grocery', 'shopping plan'],
      category: 'grocery',
    ),
  ];
}
