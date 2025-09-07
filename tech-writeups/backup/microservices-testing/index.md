---
layout: default
title: microservices-testing 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


#  Testing in Microservices with Contract Testing

##  Introduction

Microservices architecture splits an application into small, loosely coupled services that communicate over APIs. While this enables scalability and flexibility, **testing** becomes more complex due to independent deployments, service versioning, and inter-service communication.

**Contract Testing** provides a solution to this complexity by ensuring that **inter-service interactions** are consistent and reliable without relying on full integration or end-to-end tests.

---

##  What is Contract Testing?

**Contract Testing** is a testing strategy that verifies that services (typically API consumers and providers) agree on the **format and content of requests and responses**—their "contract."

It avoids the overhead of spinning up real services or environments by simulating interactions.

###  Roles in Contract Testing:

* **Consumer**: Service making the API call.
* **Provider**: Service receiving the API call.
* **Contract**: JSON or YAML document describing the expected request-response interaction.

---

## ️ Why Contract Testing in Microservices?

| Challenge in Microservices  | How Contract Testing Helps                       |
| --------------------------- | ------------------------------------------------ |
| Tight Coupling              | Encourages clear API boundaries                  |
| Independent Deployments     | Enables compatibility checks before releases     |
| Slow/Flaky End-to-End Tests | Provides fast, reliable feedback loops           |
| Difficult Integration Setup | Works without full environments or real services |

---

##  How Contract Testing Works

### 1. **Consumer Creates a Contract**

The consumer defines the expected interactions with a provider (e.g., GET `/users/1` returns a user object). This is usually done in test code.

### 2. **Contract is Shared with Provider**

This contract is published to a **contract broker** (e.g., [Pact Broker](https://docs.pact.io/pact_broker)).

### 3. **Provider Verifies the Contract**

The provider uses the contract to verify it can fulfill the requests defined by the consumer.

---

##  Example with Pact (Python + Flask)

### Consumer Test

```python
from pact import Consumer, Provider
import requests

pact = Consumer('user-service').has_pact_with(Provider('auth-service'))
pact.start_service()

def test_get_user():
    expected = {'id': 1, 'name': 'Anish'}
    pact.given('User with ID 1 exists').upon_receiving('a request for user 1')\
        .with_request('get', '/users/1')\
        .will_respond_with(200, body=expected)

    with pact:
        response = requests.get('http://localhost:1234/users/1')
        assert response.json() == expected
```

This test generates a contract file describing this interaction.

### Provider Verification

The `auth-service` runs verification tests using this contract to ensure it can return the expected response.

---

##  Contract Broker

A **contract broker** stores and shares contracts between services. It supports:

* Versioning
* Tags (e.g., `prod`, `dev`)
* CI/CD integration (e.g., verifying contract before deployment)

Popular option: [Pact Broker](https://pact.io/pact_broker)

---

##  Workflow in CI/CD

1. Consumer commits a contract → pushes to broker.
2. Provider fetches and verifies contract.
3. CI ensures contracts are valid before deployments.

---

##  Benefits of Contract Testing

*  **Faster Feedback**: Avoids costly E2E tests.
*  **Reliable Deployments**: Fewer integration failures.
*  **Supports CI/CD**: Shift-left testing of API compatibility.
*  **Clear Ownership**: Each team owns their API boundaries.

---

## ️ Limitations

| Limitation                         | Workaround or Consideration                  |
| ---------------------------------- | -------------------------------------------- |
| Doesn’t test actual networks       | Combine with integration tests               |
| Can be brittle with schema changes | Use versioning, backward compatibility       |
| Limited visibility into logic      | Use in combination with unit & service tests |

---

##  Where Does It Fit in Test Strategy?

| Test Type          | Scope                   | Purpose                       |
| ------------------ | ----------------------- | ----------------------------- |
| Unit Tests         | Internal logic          | Fast, local validation        |
| Integration Tests  | Internal + Dependencies | Validates service integration |
| **Contract Tests** | API boundaries          | Validates request/response    |
| E2E Tests          | Full system             | Validates business flows      |

Use **contract tests as a bridge** between unit and integration tests.

---

##  Tools for Contract Testing

| Tool                      | Language Support     | Notes                               |
| ------------------------- | -------------------- | ----------------------------------- |
| **Pact**                  | JS, Python, Java, Go | Widely used, Pact Broker support    |
| **Spring Cloud Contract** | Java                 | Great for Spring Boot microservices |
| **Hoverfly**              | HTTP simulation      | Good for mocking over HTTP          |
| **Dredd**                 | OpenAPI validator    | Validates API against OpenAPI docs  |

---

##  Summary

Contract Testing is essential for microservices to ensure communication is reliable, versioned, and testable. It reduces test complexity while increasing confidence in API interactions.

###  Use Contract Testing When:

* Services are developed independently
* You want fast CI pipelines
* You're struggling with flaky integration tests

###  Avoid Relying Only on Contract Tests When:

* You need to verify end-to-end business flows
* You need to test real-world data or side effects
