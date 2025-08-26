---
layout: default
title: wcag 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Accessibility in Web Apps (WCAG Guidelines)

Web accessibility ensures that websites, applications, and tools are usable by people with disabilities. It encompasses a range of practices that enable users with visual, auditory, motor, and cognitive impairments to perceive, understand, navigate, and interact with the web.

The **Web Content Accessibility Guidelines (WCAG)**, developed by the W3C, provide a global standard for accessibility. These guidelines are structured around four core principles: **Perceivable, Operable, Understandable, and Robust (POUR).**

---

##  The Four WCAG Principles

### 1. **Perceivable**

Information and user interface components must be presented to users in ways they can perceive.

* Provide text alternatives (`alt` attributes) for non-text content (images, icons).
* Use captions and transcripts for audio/video content.
* Ensure sufficient contrast between text and background.
* Do not rely solely on color to convey meaning.

### 2. **Operable**

User interface components must be operable by all users.

* All functionality must be accessible via keyboard.
* Provide enough time to read and interact with content.
* Avoid content that causes seizures (e.g., blinking).
* Help users navigate, find content, and determine where they are.

### 3. **Understandable**

Content and interface must be understandable.

* Use clear, concise, and consistent language.
* Provide input assistance (error messages, labels, hints).
* Ensure predictable navigation and consistent UI behavior.

### 4. **Robust**

Content must be robust enough to be interpreted reliably by assistive technologies.

* Use semantic HTML (e.g., `<header>`, `<nav>`, `<main>`, `<button>`, `<label>`).
* Validate your HTML to avoid malformed markup.
* Ensure compatibility with screen readers and other assistive tools.

---

##  Practical Accessibility Techniques

| Technique                       | Benefit                              |
| ------------------------------- | ------------------------------------ |
| Use `aria-label`/`aria-*`       | Enhances screen reader compatibility |
| Semantic HTML tags              | Better structure for assistive tools |
| Keyboard focus indicators       | Enables keyboard-only navigation     |
| Skip links (`<a href="#main">`) | Helps users bypass repeated content  |
| Responsive and zoomable UI      | Supports low-vision users            |
| Descriptive link text           | Improves clarity for screen readers  |

---

##  WCAG Compliance Levels

| Level   | Description                            |
| ------- | -------------------------------------- |
| **A**   | Minimum level of accessibility         |
| **AA**  | Industry-standard for compliance       |
| **AAA** | Highest level, often difficult to meet |

---

## ️ Tools for Accessibility Testing

* **Lighthouse (Chrome DevTools)** – Provides accessibility audits.
* **axe DevTools** – Browser extension for detecting WCAG issues.
* **NVDA / VoiceOver / JAWS** – Screen readers for manual testing.
* **Wave (WebAIM)** – Visual feedback on accessibility issues.
* **Keyboard-only testing** – Ensure the app is fully navigable via keyboard.

---

##  Real-World Considerations

* Ensure accessible forms: proper labeling, error messages, fieldsets.
* Support screen readers: test dynamic content and live regions (`aria-live`).
* Design mobile-first with accessibility in mind.
* Educate your team: designers, developers, and QA all share responsibility.

---

##  Example: Accessible Button

```html
<!-- Good -->
<button type="submit" aria-label="Submit form">Submit</button>

<!-- Bad -->
<div onclick="submitForm()">Submit</div> <!-- Not accessible -->
```

---

##  References

* [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
* [WebAIM Checklist](https://webaim.org/standards/wcag/checklist)
* [MDN Accessibility Docs](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
