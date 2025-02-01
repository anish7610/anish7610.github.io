---
layout: default
title: e2e-testing 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


---

# 🧪 End-to-End (E2E) Testing with Selenium and Playwright

## 📌 Overview

**End-to-End Testing (E2E)** is a software testing methodology that validates the complete flow of an application—from start to finish—to ensure the system behaves as expected. It simulates real user scenarios and interacts with the app via UI, backend services, and databases.

Two popular tools for E2E testing of web applications are **Selenium** and **Playwright**.

---

## 🧰 What is Selenium?

**Selenium** is a mature and widely-used automation framework that allows testers to write tests in multiple languages (Java, Python, C#, etc.) and run them on various browsers.

* **Language Support**: Java, Python, C#, Ruby, JavaScript
* **Browser Support**: Chrome, Firefox, Safari, Edge, IE
* **Execution Layer**: WebDriver Protocol

### ✅ Pros

* Mature ecosystem with wide community support
* BrowserStack, SauceLabs integration
* Supports parallel and distributed testing via Selenium Grid

### ❌ Cons

* Slower execution due to reliance on the WebDriver
* Complex setup for browser drivers
* Flaky tests due to asynchronous browser behavior

---

## 🚀 What is Playwright?

**Playwright** is a modern automation library developed by Microsoft for fast and reliable E2E testing. It supports multi-browser automation and is known for its fast execution, auto-wait features, and headless testing capabilities.

* **Language Support**: JavaScript/TypeScript, Python, Java, C#
* **Browser Support**: Chromium, Firefox, WebKit
* **Execution Layer**: Direct browser control via DevTools Protocol

### ✅ Pros

* Automatic waiting and intelligent retries
* Single API for multiple browsers
* Built-in tracing, screenshots, and video recording
* Faster and more resilient compared to Selenium

### ❌ Cons

* Smaller community compared to Selenium
* Limited support for legacy browsers (e.g., IE)

---

## 🧪 Typical Use Cases

| Use Case                             | Selenium                 | Playwright         |
| ------------------------------------ | ------------------------ | ------------------ |
| Cross-browser testing (including IE) | ✅ Yes                    | ❌ No IE support    |
| Fast feedback with modern browsers   | ⚠️ Slower                | ✅ Fast             |
| CI/CD Integration                    | ✅ Well-supported         | ✅ Seamless         |
| Test flakiness reduction             | ⚠️ Manual waits required | ✅ Auto-waiting     |
| Mobile web testing                   | ✅ With Appium            | ⚠️ Limited support |

---

## 🛠️ Setup

### ▶️ Selenium (Python Example)

```bash
pip install selenium
```

```python
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://example.com")
assert "Example Domain" in driver.title
driver.quit()
```

### ▶️ Playwright (Python Example)

```bash
pip install playwright
playwright install
```

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto("https://example.com")
    assert "Example Domain" in page.title()
    browser.close()
```

---

## 🧱 Real-World Test Scenario Example

### ✅ Scenario: User Login Flow

#### 🔹 Selenium Example (Python)

```python
driver.get("https://myapp.com/login")
driver.find_element(By.ID, "username").send_keys("admin")
driver.find_element(By.ID, "password").send_keys("password")
driver.find_element(By.ID, "submit").click()
assert "Dashboard" in driver.title
```

#### 🔹 Playwright Example (Python)

```python
page.goto("https://myapp.com/login")
page.fill("#username", "admin")
page.fill("#password", "password")
page.click("#submit")
page.wait_for_url("**/dashboard")
assert "Dashboard" in page.title()
```

---

## 🧪 Parallel Testing and CI

### Selenium

* Integrate with **Selenium Grid** or use services like **BrowserStack/SauceLabs**
* TestNG or Pytest-xdist for parallel execution

### Playwright

* Built-in support for parallel execution via `pytest-playwright` or Playwright Test runner

```bash
# Playwright Test Runner
npx playwright test --project=chromium
```

---

## 📊 Comparison Summary

| Feature                | Selenium                | Playwright                    |
| ---------------------- | ----------------------- | ----------------------------- |
| Browser Support        | ✅ Broad (incl. IE)      | ✅ Modern browsers only        |
| Execution Speed        | ⚠️ Slower               | ✅ Faster                      |
| Auto-wait for Elements | ❌ Manual waits          | ✅ Built-in                    |
| Setup Complexity       | ⚠️ Driver configuration | ✅ One-liner setup             |
| Test Stability         | ⚠️ Flaky at times       | ✅ More stable                 |
| Debugging Tools        | ⚠️ Manual logs          | ✅ Tracing, video, screenshots |
| Mobile/Web Hybrid      | ✅ With Appium           | ⚠️ Limited                    |

---

## 🧩 Best Practices

* Use **data-testid** or custom selectors instead of brittle CSS selectors
* Run tests in **headless mode** for CI, but enable video/tracing for debugging
* Use **environment-specific configs** (dev, staging, prod)
* Avoid hard-coded waits (`time.sleep()`); prefer **explicit waits** in Selenium and **auto-waiting** in Playwright
* Structure tests using **Page Object Model (POM)** for reusability

---

## 🧾 Conclusion

Both **Selenium** and **Playwright** are powerful tools for E2E testing. If you're working with legacy browsers or enterprise stacks, Selenium remains a solid choice. However, for modern web applications, **Playwright offers a faster, more reliable**, and **developer-friendly** testing experience.

> ✅ **Recommendation**:
> Choose **Playwright** for modern applications and CI-first pipelines. Choose **Selenium** if you require legacy browser support or have an existing large test suite in Selenium.
