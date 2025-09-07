---
layout: default
title: api-contract-testing 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# **API Contract Testing with Postman/Newman or Pact**

API contract testing ensures that the communication between different components of a system (e.g., client and server) follows a defined structure or "contract." This becomes crucial in distributed systems and microservice architectures where breaking a contract can cause downstream failures.

---

##  **What is API Contract Testing?**

Unlike traditional API tests that check **functionality**, contract testing verifies the **structure, semantics, and validity** of the API request and response payloads. It ensures that the provider (API server) and consumer (client) agree on:

* Endpoints
* Methods (GET, POST, etc.)
* Request parameters and headers
* Response schema (status codes, body structure)

---

##  **Why API Contract Testing?**

* Prevents breaking changes in APIs
* Improves collaboration between frontend and backend teams
* Fast and lightweight compared to full end-to-end tests
* Helps enable CI/CD by validating integration points

---

## ️ **Tooling Options**

### **1. Postman + Newman**

**Postman** is a GUI tool for developing and testing APIs. **Newman** is the CLI runner that allows these collections to be run in CI/CD.

####  Pros:

* Easy to set up and use
* Supports schema validation with JSON schema
* Large ecosystem and GUI-based testing

####  Example: JSON Schema Validation in Postman

```javascript
pm.test("Contract test: response matches schema", function () {
  var schema = {
    "type": "object",
    "properties": {
      "id": {"type": "number"},
      "name": {"type": "string"},
      "email": {"type": "string"}
    },
    "required": ["id", "name", "email"]
  };
  pm.response.to.have.jsonSchema(schema);
});
```

####  Integration with Newman

```bash
newman run collection.json -e environment.json
```

Can be run in CI pipelines to fail builds on schema mismatches.

---

### **2. Pact (Consumer-Driven Contract Testing)**

**Pact** is a powerful framework based on **consumer-driven contracts**. It allows consumers to define their expectations, which providers must then fulfill.

####  Pros:

* Strong versioning and contract negotiation
* Supports multiple languages (JS, Java, Python, Go)
* CI/CD friendly with Pact Broker for sharing contracts

####  Workflow:

1. **Consumer** writes a test that generates a pact file (JSON).
2. Pact file is shared with **provider**.
3. **Provider** runs tests to ensure it satisfies the consumer’s expectations.

####  Example (Node.js):

```javascript
const { Pact } = require('@pact-foundation/pact');
const provider = new Pact({
  port: 1234,
  consumer: 'FrontendApp',
  provider: 'UserService',
});

describe('Contract Test', () => {
  before(() => provider.setup());

  it('should return a user', async () => {
    await provider.addInteraction({
      uponReceiving: 'a request for user data',
      withRequest: {
        method: 'GET',
        path: '/user/1',
      },
      willRespondWith: {
        status: 200,
        body: { id: 1, name: 'Alice' },
      },
    });

    // call your API client here
  });

  after(() => provider.finalize());
});
```

---

## 🆚 **Postman vs Pact**

| Feature              | Postman/Newman | Pact                             |
| -------------------- | -------------- | -------------------------------- |
| Approach             | Test-based     | Contract-based (Consumer-driven) |
| Tooling              | GUI + CLI      | CLI + Language SDKs              |
| Schema Validation    | JSON Schema    | Pact DSL                         |
| Use in Microservices | Good           | Excellent                        |
| Contract Versioning  | No             | Yes (via Pact Broker)            |
| Learning Curve       | Low            | Medium                           |

---

##  **CI/CD Integration Example**

* Run **Newman** collections post-deployment in your Jenkins or GitHub Actions workflow.
* Use **Pact** to verify contract compatibility during pull requests before merging to main.

---

##  **Best Practices**

* Keep your contracts in version control
* Run contract tests early in the pipeline
* Use shared schemas to avoid duplication
* Treat contracts as code: review, approve, evolve

---

##  **Conclusion**

API contract testing is a critical part of ensuring stable and reliable communication between services. Whether you're using Postman for quick validation or Pact for full-blown consumer-driven contracts, integrating these practices helps catch issues early and streamline development in modern, service-oriented architectures.
