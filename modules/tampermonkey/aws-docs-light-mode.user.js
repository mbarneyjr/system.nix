// ==UserScript==
// @name         AWS Docs – Force Light Theme
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Automatically selects the Light text theme on AWS documentation pages
// @match        https://docs.aws.amazon.com/*
// @run-at       document-idle
// @grant        none
// @updateURL    file:///Users/mbarney/.config/tampermonkey/aws-docs-light-mode.user.js
// @downloadURL  file:///Users/mbarney/.config/tampermonkey/aws-docs-light-mode.user.js
// ==/UserScript==

(() => {
  function isLightMode() {
    return document.body.classList.contains("awsui-polaris-light-mode");
  }

  function forceLightTheme() {
    if (isLightMode()) return;

    const prefsLink = Array.from(document.querySelectorAll("a")).find(
      (a) => a.textContent.trim() === "Preferences",
    );
    if (!prefsLink) return;

    prefsLink.click();

    const observer = new MutationObserver(() => {
      const lightRadios = document.querySelectorAll(
        'input[type="radio"][value="light"]',
      );
      if (lightRadios.length === 0) return;

      observer.disconnect();

      if (!lightRadios[0].checked) {
        lightRadios[0].click();
      }

      document.dispatchEvent(
        new KeyboardEvent("keydown", { key: "Escape", bubbles: true }),
      );
    });

    observer.observe(document.body, { childList: true, subtree: true });

    observer.takeRecords();
    const already = document.querySelectorAll(
      'input[type="radio"][value="light"]',
    );
    if (already.length > 0) {
      observer.disconnect();
      if (!already[0].checked) already[0].click();
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
