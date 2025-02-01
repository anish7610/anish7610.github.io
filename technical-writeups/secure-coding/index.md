---
layout: default 
title: Secure Coding
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# 🔐 Secure Coding Practices in Web Applications

### Focus Areas: XSS, CSRF, SQL Injection

Web applications are exposed to various security threats due to improper coding practices. Among the most common and severe vulnerabilities are Cross-Site Scripting (XSS), Cross-Site Request Forgery (CSRF), and SQL Injection. This document outlines each threat and highlights secure coding techniques to prevent them.

---

## 1. 🛡️ Cross-Site Scripting (XSS)

### 🔍 What is XSS?

XSS allows attackers to inject malicious scripts into content that is then served to users. The attacker’s code executes in the victim’s browser, potentially stealing cookies, session tokens, or manipulating the DOM.

### 📂 Types of XSS:

* **Stored XSS** – The payload is stored on the server (e.g., in a database).
* **Reflected XSS** – The payload is reflected via the URL or input.
* **DOM-based XSS** – The client-side JavaScript dynamically injects untrusted data.

### ✅ Secure Coding Practices:

* **Input Validation:** Reject input that contains HTML tags or JavaScript when not needed.
* **Output Encoding:** Encode output using context-aware escaping.

  * HTML context: `&`, `<`, `>`, `"`, `'`
  * JavaScript context: escape characters like `\`, `"`, `'`
* **Use Trusted Libraries:**

  * E.g., [`OWASP Java Encoder`](https://owasp.org/www-project-java-encoder/) or Python’s `html.escape`
* **Content Security Policy (CSP):**

  * Enforce CSP headers to limit the sources of scripts.

### ✅ Example in Flask (Python):

```python
from flask import escape

@app.route("/search")
def search():
    query = request.args.get("q", "")
    return f"Results for: {escape(query)}"
```

---

## 2. 🛡️ Cross-Site Request Forgery (CSRF)

### 🔍 What is CSRF?

CSRF exploits the trust that a web application has in the user’s browser. An attacker tricks the user into submitting unwanted actions (like changing their email) on an authenticated session.

### 🧠 Attack Vector:

A malicious website submits a form or makes a GET/POST request to another site where the user is already logged in.

### ✅ Secure Coding Practices:

* **Anti-CSRF Tokens:** Generate a unique token for each session/form and validate it on submission.
* **SameSite Cookies:** Use `SameSite=Lax` or `Strict` to restrict cross-site cookies.
* **Double Submit Cookies:** Set a cookie and include the same value in a form/header for verification.

### ✅ Example in Flask-WTF:

```python
from flask_wtf import FlaskForm
from wtforms import StringField
from wtforms.validators import DataRequired

class ProfileForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired()])
```

```html
<form method="post">
  {{ form.csrf_token }}
  {{ form.email.label }} {{ form.email() }}
</form>
```

---

## 3. 🛡️ SQL Injection

### 🔍 What is SQL Injection?

SQL Injection occurs when user inputs are inserted directly into SQL statements without proper sanitization. This allows attackers to manipulate queries, bypass authentication, or extract sensitive data.

### 🧠 Attack Vector:

```sql
SELECT * FROM users WHERE username = '$input' AND password = '$input';
```

If the user provides `admin' OR '1'='1`, it bypasses authentication.

### ✅ Secure Coding Practices:

* **Parameterized Queries (Prepared Statements):** Never concatenate user inputs into SQL queries.
* **ORMs:** Use Object Relational Mappers (like SQLAlchemy, Django ORM) to abstract SQL logic.
* **Input Validation:** Enforce strong typing and validation on user input.

### ✅ Example in Python with SQLite:

```python
import sqlite3

def get_user(username):
    cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
```

---

## 🔐 General Secure Coding Practices

| Practice                 | Description                                                                       |
| ------------------------ | --------------------------------------------------------------------------------- |
| ✅ Input Validation       | Whitelist approach – only allow expected formats                                  |
| ✅ Output Encoding        | Encode data based on context (HTML, URL, JavaScript)                              |
| ✅ Least Privilege        | DB accounts should have minimal privileges                                        |
| ✅ Secure Headers         | Use headers like `X-Frame-Options`, `X-XSS-Protection`, `Content-Security-Policy` |
| ✅ Session Management     | Use secure, HTTP-only cookies; regenerate session IDs                             |
| ✅ Logging and Monitoring | Log access attempts, unusual activities, and validation failures                  |

---

## 🔧 Tools for Secure Coding

* **Static Analysis:** SonarQube, Bandit (Python)
* **Dynamic Analysis:** OWASP ZAP, Burp Suite
* **Security Testing:** Postman, sqlmap, XSS Hunter
* **Framework Features:**

  * Django: CSRF Middleware, ORM
  * Flask: `flask-wtf`, `escape()`
  * Express (Node.js): `helmet`, `express-validator`

---

## 🧩 Summary Table

| Threat   | Prevention                            |
| -------- | ------------------------------------- |
| **XSS**  | Escape output, CSP, input validation  |
| **CSRF** | CSRF tokens, SameSite cookies         |
| **SQLi** | Prepared statements, input validation |

---

## 📚 References

* [OWASP Top 10](https://owasp.org/www-project-top-ten/)
* [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
* [Mozilla CSP Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
* [Flask Security Docs](https://flask.palletsprojects.com/en/2.3.x/security/)
