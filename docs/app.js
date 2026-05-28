const installButton = document.querySelector("[data-install]");
const navToggle = document.querySelector("[data-nav-toggle]");
const navLinks = document.querySelector("[data-nav-links]");
const siteHeader = document.querySelector(".site-header");
const year = document.querySelector("[data-year]");
const featureTabs = document.querySelectorAll("[data-preview-image]");
const featureImage = document.querySelector("[data-feature-image]");
const featurePhone = document.querySelector(".feature-phone");

let deferredInstallPrompt;
let featureSwapTimer;

if (year) {
  year.textContent = new Date().getFullYear();
}

if (false && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js");
  });
}

window.addEventListener("beforeinstallprompt", (event) => {
  event.preventDefault();
  deferredInstallPrompt = event;
  installButton?.removeAttribute("hidden");
});

installButton?.addEventListener("click", async () => {
  if (!deferredInstallPrompt) {
    return;
  }

  deferredInstallPrompt.prompt();
  await deferredInstallPrompt.userChoice;
  deferredInstallPrompt = null;
  installButton.setAttribute("hidden", "true");
});

navToggle?.addEventListener("click", () => {
  const isOpen = navLinks?.classList.toggle("is-open");
  navToggle.setAttribute("aria-expanded", String(Boolean(isOpen)));
});

document.querySelectorAll('a[href^="#"]').forEach((link) => {
  link.addEventListener("click", () => {
    navLinks?.classList.remove("is-open");
    navToggle?.setAttribute("aria-expanded", "false");
  });
});

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.18 }
);

document.querySelectorAll(".reveal").forEach((element) => {
  revealObserver.observe(element);
});

const updateHeaderState = () => {
  siteHeader?.classList.toggle("is-scrolled", window.scrollY > 12);
};

window.addEventListener("scroll", updateHeaderState, { passive: true });
updateHeaderState();

featureTabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    if (!featureImage || !featurePhone) {
      return;
    }

    featureTabs.forEach((item) => {
      item.classList.remove("is-active");
      item.setAttribute("aria-selected", "false");
    });

    tab.classList.add("is-active");
    tab.setAttribute("aria-selected", "true");

    const nextImage = tab.dataset.previewImage;
    const nextAlt = tab.dataset.previewAlt || "";

    window.clearTimeout(featureSwapTimer);
    featurePhone.classList.add("is-switching");

    featureSwapTimer = window.setTimeout(() => {
      if (nextImage) {
        featureImage.src = nextImage;
      }
      featureImage.alt = nextAlt;
      featurePhone.classList.remove("is-switching");
    }, 160);
  });
});
