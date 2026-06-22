// ==UserScript==
// @name         AWS Docs – Force Light Theme
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically selects the Light text theme on AWS documentation pages
// @match        https://docs.aws.amazon.com/*
// @grant        none
// @updateURL    file:///Users/mbarney/.config/tampermonkey/aws-docs-light-mode.user.js
// @downloadURL  file:///Users/mbarney/.config/tampermonkey/aws-docs-light-mode.user.js
// ==/UserScript==

(() => {
  function isLightMode() {
    return document.body.classList.contains("awsui-polaris-light-mode");
  }

  function forceLightTheme() {
    if (isLightMode()) return; // Already light — nothing to do

    // Find the Preferences link in the header
    const prefsLink = Array.from(document.querySelectorAll("a")).find(
      (a) => a.textContent.trim() === "Preferences",
    );
    if (!prefsLink) return;

    prefsLink.click(); // Open the preferences panel

    // Wait for the radio buttons to be rendered into the DOM
    const observer = new MutationObserver(() => {
      const lightRadios = document.querySelectorAll(
        'input[type="radio"][value="light"]',
      );
      if (lightRadios.length === 0) return;

      observer.disconnect();

      // Click the first "light" radio (Text theme)
      if (!lightRadios[0].checked) {
        lightRadios[0].click();
      }

      // Close the panel
      document.dispatchEvent(
        new KeyboardEvent("keydown", { key: "Escape", bubbles: true }),
      );
    });

    observer.observe(document.body, { childList: true, subtree: true });
  }

  // Delay slightly to allow React hydration to finish
  window.addEventListener("load", () => setTimeout(forceLightTheme, 500));
})();
