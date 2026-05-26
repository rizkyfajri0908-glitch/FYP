const CACHE_NAME = "ecobite-marketing-v5";
const STATIC_ASSETS = [
  "/",
  "/index.html",
  "/login.html",
  "/styles.css",
  "/app.js",
  "/manifest.webmanifest",
  "/assets/ecobite_logo.png",
  "/assets/screenshots/homepage.jpg",
  "/assets/screenshots/kitchen_inventory.jpg",
  "/assets/screenshots/recipe_suggestions.jpg",
  "/assets/screenshots/ai_assistant.jpg",
  "/assets/screenshots/grocery_plan.jpg"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key)))
      )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      return (
        cachedResponse ||
        fetch(event.request).catch(() => caches.match("/index.html"))
      );
    })
  );
});
