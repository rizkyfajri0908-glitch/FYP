const CACHE_NAME = "ecobite-marketing-v28";
const STATIC_ASSETS = [
  "/",
  "/index.html",
  "/login.html",
  "/index.html?v=28",
  "/styles.css?v=28",
  "/app.js?v=28",
  "/manifest.webmanifest",
  "/assets/ecobite_logo.png",
  "/assets/screenshots/homepage.jpg",
  "/assets/screenshots/kitchen_inventory.jpg",
  "/assets/screenshots/recipe_suggestions.jpg",
  "/assets/screenshots/ai_assistant.jpg",
  "/assets/screenshots/barcode_scanner.jpg",
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

  if (event.request.mode === "navigate") {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          return response;
        })
        .catch(() => caches.match(event.request).then((cached) => cached || caches.match("/index.html")))
    );
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (event.request.url.includes("/styles.css") || event.request.url.includes("/app.js")) {
        return fetch(event.request)
          .then((response) => {
            const copy = response.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
            return response;
          })
          .catch(() => cachedResponse || caches.match("/index.html"));
      }

      return cachedResponse || fetch(event.request).catch(() => caches.match("/index.html"));
    })
  );
});
