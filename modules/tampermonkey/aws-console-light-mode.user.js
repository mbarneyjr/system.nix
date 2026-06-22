// ==UserScript==
// @name         AWS Console – Force Light Theme
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically selects the Light visual mode on the AWS Management Console
// @match        https://*.console.aws.amazon.com/*
// @grant        none
// @updateURL    file:///Users/mbarney/.config/tampermonkey/aws-console-light-mode.user.js
// @downloadURL  file:///Users/mbarney/.config/tampermonkey/aws-console-light-mode.user.js
// ==/UserScript==

(() => {
  function isDarkMode() {
    return document.body.classList.contains("awsui-polaris-dark-mode");
  }

  function forceLightTheme() {
    if (!isDarkMode()) return; // Already light (or default light) — nothing to do

    // Click the Settings (cog) button in the top nav
    const settingsBtn = document.querySelector(
      '[data-testid="more-menu__awsc-nav-quick-settings-button"]',
    );
    if (!settingsBtn) return;

    settingsBtn.click();

    // Wait for the radio buttons to be rendered into the DOM
    const observer = new MutationObserver(() => {
      const lightRadio = Array.from(
        document.querySelectorAll('input[type="radio"]'),
      ).find((r) => r.value === "light");
      if (!lightRadio) return;

      observer.disconnect();

      if (!lightRadio.checked) {
        lightRadio.click();
      }

      // Close the panel
      document.dispatchEvent(
        new KeyboardEvent("keydown", { key: "Escape", bubbles: true }),
      );
    });

    observer.observe(document.body, { childList: true, subtree: true });
  }

  // Delay to allow the console app to fully hydrate
  window.addEventListener("load", () => setTimeout(forceLightTheme, 500));
})();
