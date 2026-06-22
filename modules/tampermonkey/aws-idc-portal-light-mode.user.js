// ==UserScript==
// @name         AWS Access Portal - Force Light Mode
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically sets the AWS Access Portal to Light Mode
// @author       You
// @match        https://*.awsapps.com/start/*
// @grant        none
// @updateURL    file:///Users/mbarney/.config/tampermonkey/aws-idc-portal-light-mode.user.js
// @downloadURL  file:///Users/mbarney/.config/tampermonkey/aws-idc-portal-light-mode.user.js
// ==/UserScript==

(() => {
  const STORAGE_KEY = "awsportal_lightmode_set";

  // Only run this once per session (not on every page load after it's already set)
  if (sessionStorage.getItem(STORAGE_KEY)) return;

  function waitForElement(selector, timeout = 5000) {
    return new Promise((resolve, reject) => {
      const el = document.querySelector(selector);
      if (el) return resolve(el);

      const observer = new MutationObserver(() => {
        const el = document.querySelector(selector);
        if (el) {
          observer.disconnect();
          resolve(el);
        }
      });
      observer.observe(document.body, { childList: true, subtree: true });
      setTimeout(() => {
        observer.disconnect();
        reject(new Error(`Timed out waiting for: ${selector}`));
      }, timeout);
    });
  }

  async function setLightMode() {
    // If already on the preferences page, handle it directly
    if (window.location.hash === "#/preferences") {
      try {
        const lightRadio = await waitForElement('input[value="light"]');

        // Already set to light mode — nothing to do
        if (lightRadio.checked) {
          sessionStorage.setItem(STORAGE_KEY, "1");
          return;
        }

        // Click the Light Mode radio button
        lightRadio.click();

        // Wait for Save button and click it
        const saveBtn = await waitForElement(
          '[data-testid="preferences-save-button"]',
        );
        saveBtn.click();

        sessionStorage.setItem(STORAGE_KEY, "1");
      } catch (e) {
        console.warn("[LightMode] Error on preferences page:", e);
      }
      return;
    }

    // Otherwise, navigate to preferences, set light mode, then come back
    const returnHash = window.location.hash || "#/";

    // Navigate to preferences
    window.location.hash = "#/preferences";

    // Wait for the page to render the light mode radio
    try {
      const lightRadio = await waitForElement('input[value="light"]', 7000);

      if (lightRadio.checked) {
        // Already light mode — go back
        sessionStorage.setItem(STORAGE_KEY, "1");
        window.location.hash = returnHash;
        return;
      }

      lightRadio.click();

      const saveBtn = await waitForElement(
        '[data-testid="preferences-save-button"]',
        5000,
      );
      saveBtn.click();
      sessionStorage.setItem(STORAGE_KEY, "1");
      // The Save button href="#/" navigates home automatically
    } catch (e) {
      console.warn("[LightMode] Failed to set light mode:", e);
      window.location.hash = returnHash;
    }
  }

  // Run after the page has loaded enough for the app to initialise
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", setLightMode);
  } else {
    // Give the SPA a moment to bootstrap
    setTimeout(setLightMode, 800);
  }
})();
