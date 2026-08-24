// ==UserScript==
// @name         AWS Console – Force Light Theme
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically selects the Light visual mode on the AWS Management Console
// @match        https://*.console.aws.amazon.com/*
// @run-at       document-idle
// @grant        none
// @updateURL    file:///Users/mbarney/.config/tampermonkey/aws-console-light-mode.user.js
// @downloadURL  file:///Users/mbarney/.config/tampermonkey/aws-console-light-mode.user.js
// ==/UserScript==

(() => {
  function isDarkMode() {
    return document.body.classList.contains("awsui-polaris-dark-mode");
  }

  function findLightRadio() {
    return Array.from(document.querySelectorAll('input[type="radio"]')).find(
      (r) => r.value === "light",
    );
  }

  function pollFor(checkFn, { interval = 150, timeout = 6000 } = {}) {
    return new Promise((resolve, reject) => {
      const start = Date.now();
      const tick = () => {
        const result = checkFn();
        if (result) return resolve(result);
        if (Date.now() - start >= timeout) {
          return reject(new Error("Timed out waiting for condition"));
        }
        setTimeout(tick, interval);
      };
      tick();
    });
  }

  async function forceLightTheme() {
    if (!isDarkMode()) return; // Already light — nothing to do

    const settingsBtn = document.querySelector(
      '[data-testid="more-menu__awsc-nav-quick-settings-button"]',
    );
    if (!settingsBtn) {
      console.warn("[LightTheme] Settings button not found");
      return;
    }

    settingsBtn.click();

    try {
      const lightRadio = await pollFor(findLightRadio);

      if (!lightRadio.checked) {
        lightRadio.click();
      }

      document.dispatchEvent(
        new KeyboardEvent("keydown", { key: "Escape", bubbles: true }),
      );
    } catch (e) {
      console.warn("[LightTheme] Failed to switch theme:", e);
      document.dispatchEvent(
        new KeyboardEvent("keydown", { key: "Escape", bubbles: true }),
      );
    }
  }

  function run() {
    setTimeout(forceLightTheme, 500);
  }

  if (document.readyState === "complete") {
    run();
  } else {
    window.addEventListener("load", run);
  }
})();
