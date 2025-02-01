---
layout: default
title: mocks 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# **Mocking, Stubbing, and Dependency Isolation in Tests**

## **Introduction**

In software testing—especially unit testing—**isolating the component under test** is critical for ensuring reliable, fast, and deterministic results. This isolation is often achieved using **mocking**, **stubbing**, and other **test double** techniques to control and observe the behavior of dependencies.

Understanding these strategies is crucial for building robust and maintainable test suites, particularly in **test-driven development (TDD)** and **continuous integration pipelines**.

---

## **1. The Need for Dependency Isolation**

When a unit of code interacts with external systems—like databases, web services, or filesystems—it introduces **unpredictability**, **slowness**, and **flakiness** in tests.

**Dependency isolation** helps solve this by replacing real collaborators with controlled test doubles. The key benefits:

* Faster test execution.
* Greater determinism (no network or I/O failures).
* Ability to simulate edge cases.
* Improved fault localization.

---

## **2. Terminology: Mocks vs Stubs vs Fakes vs Spies**

| Term      | Definition                                                                        |
| --------- | --------------------------------------------------------------------------------- |
| **Stub**  | A controllable object that returns predefined responses. Used for indirect input. |
| **Mock**  | A spy + stub with built-in assertions for behavior verification.                  |
| **Spy**   | Records information about calls made, like arguments and number of invocations.   |
| **Fake**  | A working implementation with simplified behavior (e.g., in-memory DB).           |
| **Dummy** | A placeholder object passed to meet parameter requirements, never used.           |

---

## **3. Stubbing: Returning Controlled Outputs**

### **Purpose**: Control how dependencies behave without asserting how they are used.

```python
from unittest.mock import MagicMock

# Example: Service that uses a stubbed payment gateway
def charge_customer(gateway, customer_id, amount):
    if gateway.charge(customer_id, amount):
        return "Charged"
    return "Failed"

# Test
def test_charge_success():
    fake_gateway = MagicMock()
    fake_gateway.charge.return_value = True
    assert charge_customer(fake_gateway, "cust123", 100) == "Charged"
```

**Key Point**: We’re not checking *how* `charge()` was called, only controlling its return value.

---

## **4. Mocking: Verifying Interactions**

### **Purpose**: Validate **how** a dependency is used, including call count and parameters.

```python
from unittest.mock import Mock

def notify_user(mailer, user_id):
    mailer.send_email(user_id, "Welcome!")

def test_notify_user_sends_email():
    mailer_mock = Mock()
    notify_user(mailer_mock, "user42")
    mailer_mock.send_email.assert_called_once_with("user42", "Welcome!")
```

**Key Point**: Mocks assert on interactions; useful for behavior verification.

---

## **5. Dependency Injection and Isolation**

Good design encourages injecting dependencies (via constructors, parameters, or service locators) rather than hard-coding them. This enables:

* Easy replacement with mocks/stubs during testing.
* Loose coupling and improved modularity.

**Bad**:

```python
def save_data(data):
    db = Database()
    db.save(data)  # hard to mock `Database`
```

**Better**:

```python
def save_data(db, data):
    db.save(data)  # easier to test by injecting `db`
```

---

## **6. Using Fakes for In-Memory Alternatives**

Sometimes you want more behavior than a stub, but without using real systems. A **fake** helps.

```python
class FakeDatabase:
    def __init__(self):
        self.storage = {}

    def save(self, key, value):
        self.storage[key] = value

    def get(self, key):
        return self.storage.get(key)

def test_save_and_get():
    db = FakeDatabase()
    db.save("user", {"name": "Anish"})
    assert db.get("user") == {"name": "Anish"}
```

---

## **7. Spies: Tracking Calls Without Controlling Behavior**

A **spy** wraps a real object and observes interactions.

```python
from unittest.mock import MagicMock

class Logger:
    def log(self, message):
        print(message)

def do_something(logger):
    logger.log("Done")

def test_logger_called():
    logger = Logger()
    logger.log = MagicMock()
    do_something(logger)
    logger.log.assert_called_with("Done")
```

---

## **8. Real-World Examples:**

| Context           | Technique | Example                                                  |
| ----------------- | --------- | -------------------------------------------------------- |
| HTTP API          | Stub      | Return mock API response instead of calling real server  |
| Email Sender      | Mock      | Assert `send_email` was called with correct subject/body |
| Payment Processor | Fake      | Simulate card acceptance or decline scenarios            |
| Database          | Spy       | Ensure `update()` is called exactly once                 |

---

## **9. Mocking in Popular Testing Frameworks**

| Language   | Framework | Mocking Library                |
| ---------- | --------- | ------------------------------ |
| Python     | pytest    | `unittest.mock`, `pytest-mock` |
| Java       | JUnit     | Mockito                        |
| JavaScript | Jest      | Built-in mocking               |
| Ruby       | RSpec     | Mocha, FlexMock                |
| Go         | Testing   | gomock, testify/mock           |

---

## **10. Caution: Over-Mocking Anti-Pattern**

Too much mocking can lead to:

* Fragile tests that break on implementation changes.
* Loss of trust in test results.
* Over-specification of internal behavior.

> **Guideline**: Mock **collaborators**, not **the system under test**.

---

## **Conclusion**

Mocking, stubbing, and fakes are indispensable tools for building **fast, focused, and reliable tests**. When used wisely, they lead to better-designed systems and smoother CI/CD pipelines. Understanding when and how to isolate dependencies is a core skill for effective software development.
