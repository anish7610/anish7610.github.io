---
layout: default
title: contract-testing-with-pact
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Automating Contract Testing with Pact (Consumer/Provider Flow)

---

Contract testing is a crucial strategy in microservices architecture, ensuring that services (providers) and their consumers (clients) adhere to a shared API contract. Pact is a widely adopted open-source tool for consumer-driven contract testing that enables independent verification of microservice interactions.

---

### 1. **Why Contract Testing?**

* Unit tests test internal logic.
* Integration tests validate component interactions but can become brittle or complex.
* **Contract testing** verifies that service-to-service communication matches expectations **without needing the entire system up**.

---

### 2. **Key Concepts in Pact**

* **Consumer**: The service/application that initiates a request.
* **Provider**: The service/application that serves the request.
* **Contract**: A file (usually JSON) describing the expected interactions (request → response).
* **Pact Broker**: A repository for storing and sharing contracts between consumers and providers.

---

### 3. **Consumer-Driven Workflow**

1. **Consumer Test Setup** (e.g., frontend or client service):

   * Write Pact tests simulating how the consumer expects to call the provider.
   * Pact generates a **contract** during test execution.

2. **Publish Contract**:

   * The consumer publishes the generated contract to a Pact Broker.

3. **Provider Verification**:

   * The provider downloads the contract from the broker.
   * It runs verification tests to assert it fulfills the contract.

4. **CI/CD Integration**:

   * Both steps (consumer generation & provider verification) run in separate pipelines.
   * Verification status is pushed back to the Pact Broker.

---

### 4. **Example**

#### a. Consumer Test (Python with `pact-python`):

```python
from pact import Consumer, Provider

pact = Consumer('UserApp').has_pact_with(Provider('UserService'))
pact.start_service()

def test_get_user():
    expected = {'id': 1, 'name': 'Alice'}
    
    (pact
     .given('User Alice exists')
     .upon_receiving('a request for Alice')
     .with_request('get', '/users/1')
     .will_respond_with(200, body=expected))

    with pact:
        result = requests.get('http://localhost:1234/users/1')
        assert result.json() == expected
```

#### b. Provider Verification

Use the Pact CLI to verify the provider against the contract:

```bash
pact-provider-verifier pact.json \
  --provider-base-url=http://localhost:8000
```

Or configure in CI using a test framework (e.g., JUnit for Java, Pytest for Python).

---

### 5. **Advantages**

* Independent verification → safe parallel development.
* Prevents “API drift” where changes silently break clients.
* Allows stubbing during development before actual implementation.

---

### 6. **Best Practices**

* Version your contracts via Pact Broker.
* Integrate contract tests early in your CI/CD.
* Tag environments (`dev`, `prod`, `staging`) when publishing/verifying.
* Use `pactflow.io` (a managed broker) for multi-team collaboration.

---

### 7. **Limitations**

* Best suited for synchronous HTTP/REST APIs.
* Async messaging support (Kafka/RabbitMQ) is available but more complex.
* Requires discipline to maintain up-to-date contracts.

---

### 8. **Tooling Ecosystem**

* **Languages**: Pact supports Java, Python, JS, Ruby, .NET, Go, Swift.
* **CI/CD**: Jenkins, GitLab, GitHub Actions integrate well with Pact Broker.
* **Alternatives**: Spring Cloud Contract, Hoverfly, OpenAPI schema validation (not consumer-driven).

---

### Conclusion

Contract testing with Pact enforces tight API contracts in a decentralized, loosely coupled service architecture. It shifts responsibility to the **consumer**, ensuring contracts are well-defined, shareable, and verifiable — leading to more reliable integrations and faster feedback loops.
