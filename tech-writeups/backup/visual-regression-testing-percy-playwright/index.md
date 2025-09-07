---
layout: default
title: visual-regression-testing-percy-playwright
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Visual Regression Testing with Percy or Playwright

Visual regression testing ensures that the **UI doesn’t break unexpectedly** by comparing current screenshots with known-good "baselines". It catches layout shifts, missing elements, font issues, and styling regressions that traditional assertions miss.

Two of the most popular tools in this domain are **Percy** (by BrowserStack) and **Playwright** (with built-in screenshot comparison support). Let’s explore how they work and when to use each.

---

###  What Is Visual Regression Testing?

Visual regression testing takes screenshots of web pages or components and compares them pixel-by-pixel (or via smarter algorithms) against a previously approved baseline.

Typical use cases:

* Detecting unintended UI changes after code updates
* Validating responsive layouts across devices
* Testing theming or dark/light mode styles
* Ensuring CSS refactors don’t break design

---

## 🟢 Option 1: Visual Testing with **Percy**

###  Pros:

* Works with multiple test frameworks (Selenium, Cypress, Playwright)
* Handles parallelization and responsive testing
* Offers web dashboard for reviewing diffs
* Integrates well with CI/CD (GitHub Actions, GitLab, Jenkins)

###  Example: Percy with Playwright

**Install Percy CLI and SDK:**

```bash
npm install --save-dev @percy/cli @percy/playwright
```

**Run Percy with Playwright:**

```javascript
// tests/visual.spec.js
const { test } = require('@playwright/test');
const percySnapshot = require('@percy/playwright');

test('homepage visual test', async ({ page }) => {
  await page.goto('http://localhost:3000');
  await percySnapshot(page, 'Homepage Snapshot');
});
```

**Run test with Percy:**

```bash
npx percy exec -- npx playwright test
```

Percy will upload screenshots to your Percy dashboard, where you can **review and approve** or **reject** changes.

---

## 🟣 Option 2: Visual Testing with **Playwright Built-in Tools**

Playwright has native support for visual diffs using `expect(page).toHaveScreenshot()`.

###  Pros:

* Fully open-source
* No external dependencies
* Fast and local
* Can be integrated into CI easily

### ️ Limitations:

* No visual UI for snapshot approval (unless you build your own)
* Lacks Percy’s multi-browser/device parallelism and history

###  Example: Playwright Native Screenshot Comparison

```javascript
// tests/visual.spec.js
const { test, expect } = require('@playwright/test');

test('homepage visual regression', async ({ page }) => {
  await page.goto('http://localhost:3000');
  await expect(page).toHaveScreenshot('homepage.png');
});
```

When you first run the test, it creates a baseline. Future runs compare the current UI to the baseline, and fail the test if a visual diff is found.

You can also use:

```js
await expect(locator).toHaveScreenshot('button.png');
```

To test specific components.

---

##  CI/CD Integration

Both Percy and Playwright can run in CI:

* **Percy** uses `PERCY_TOKEN` to securely upload screenshots to their dashboard.
* **Playwright** works with any CI tool (e.g., GitHub Actions), and stores screenshots in `test-results` by default.

---

###  Best Practices

* Use **stable selectors and consistent data** to avoid false positives.
* **Mask dynamic content** like timestamps or ads using CSS or cropping.
* For Percy, **review and approve diffs** as part of the pull request process.
* Keep **snapshots per resolution** if you test responsiveness (Percy handles this well).

---

###  Summary

| Tool                | Best For                                    | Notes                                       |
| ------------------- | ------------------------------------------- | ------------------------------------------- |
| Percy               | Teams needing review UI, responsive testing | Powerful, polished, requires a cloud token  |
| Playwright (native) | Lightweight local workflows                 | Fast, minimal setup, best for smaller teams |

Visual regression testing is essential for frontend stability and user confidence. Whether you choose Percy for rich dashboards or Playwright for speed and simplicity, integrating these into your test suite pays off in catching UI bugs before they reach users.
