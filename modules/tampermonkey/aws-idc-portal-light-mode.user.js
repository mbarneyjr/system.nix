// ==UserScript==
// @name         AWS Access Portal - Force Light Mode
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically sets the AWS Access Portal to Light Mode
// @author       You
// @match        https://*.awsapps.com/start/*
// @run-at       document-idle
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

  async function applyLightMode() {
    const lightRadio = await waitForElement('input[value="light"]');

    if (lightRadio.checked) {
      return true;
    }

    lightRadio.click();

    const saveBtn = await waitForElement(
      '[data-testid="preferences-save-button"]',
    );
    saveBtn.click();

    return false;
  }

  async function setLightMode() {
    if (window.location.hash === "#/preferences") {
      try {
        await applyLightMode();
        sessionStorage.setItem(STORAGE_KEY, "1");
      } catch (e) {
        console.warn("[LightMode] Error on preferences page:", e);
      }
      return;
    }

    // Otherwise, navigate to preferences, set light mode, then come back
    const returnHash = window.location.hash || "#/";
    window.location.hash = "#/preferences";

    try {
      const alreadyLight = await applyLightMode();
      sessionStorage.setItem(STORAGE_KEY, "1");
      if (alreadyLight) {
        window.location.hash = returnHash;
      } else {
        setTimeout(() => {
          window.location.hash = returnHash;
        }, 500);
      }
    } catch (e) {
      console.warn("[LightMode] Failed to set light mode:", e);
      window.location.hash = returnHash;
    }
  }

  function run() {
    setTimeout(setLightMode, 800);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
