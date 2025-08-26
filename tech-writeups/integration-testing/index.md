---
layout: default
title: integration-testing 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


#  Integration Testing with Docker Compose

##  Overview

**Integration testing** verifies that multiple components or services in a system work together as expected. When dealing with containerized applications—especially microservices—each service often runs in isolation using Docker. **Docker Compose** makes it easy to spin up all dependent services for integration testing in a consistent and reproducible environment.

##  Why Use Docker Compose for Integration Testing?

Docker Compose allows defining multi-container applications in a single YAML file. For integration testing, it provides:

* **Dependency orchestration**: Easily define databases, APIs, message queues, etc.
* **Repeatability**: Same environment across CI/CD and local dev.
* **Isolation**: Test environment doesn’t affect production data.
* **Lifecycle management**: Tear down containers after tests complete.

---

## ️ Basic Setup

### 1. `docker-compose.yml` Example

```yaml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: test_db
      POSTGRES_USER: test_user
      POSTGRES_PASSWORD: test_pass

  redis:
    image: redis:7
```

This sets up a web service dependent on PostgreSQL and Redis, useful for backend API tests.

---

##  Integration Test Workflow

### Step-by-step Flow:

1. **Start services** with Docker Compose:

   ```bash
   docker-compose up -d
   ```

2. **Wait for services to be healthy** (PostgreSQL might take a few seconds).

3. **Run test scripts** (e.g., using `pytest`, `unittest`, or a custom test runner).

4. **Clean up**:

   ```bash
   docker-compose down -v
   ```

---

##  Sample Test (Using Pytest)

```python
import psycopg2
import redis

def test_postgres_connection():
    conn = psycopg2.connect(
        host="localhost", port=5432,
        user="test_user", password="test_pass", dbname="test_db"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT 1;")
    result = cursor.fetchone()
    assert result == (1,)
    conn.close()

def test_redis_connection():
    r = redis.Redis(host="localhost", port=6379)
    r.set("key", "value")
    assert r.get("key") == b"value"
```

> If running tests inside the container, use service names (`db`, `redis`) as hostnames.

---

##  Running Tests in CI (e.g., GitHub Actions)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test_db
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_pass
        ports: [5432:5432]

    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.10
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run tests
        run: pytest tests/
```

Alternatively, use `docker-compose` in CI:

```bash
docker-compose up -d
pytest tests/
docker-compose down -v
```

---

##  Best Practices

* Use **health checks** in your `docker-compose.yml` to ensure services are ready.
* Tag tests as `integration` so they can be excluded during unit test runs.
* Clean up volumes (`-v`) to avoid leftover data between runs.
* Use **network aliases** and consistent ports.
* For large test suites, consider **parallel test execution** (e.g., `pytest-xdist`).

---

##  Tear Down and Cleanup

Always shut down containers and clean up resources:

```bash
docker-compose down -v --remove-orphans
```

Use a trap or teardown fixture in test runners to automate this.

---

##  Advanced Topics

* Use **seed data** containers (e.g., init scripts for PostgreSQL).
* Mock external APIs using containers like `wiremock`.
* Integrate **Kafka**, **RabbitMQ**, or other brokers as services.
* Use **Testcontainers** (Java, Python, Go) for programmatically managing containers inside tests.

---

##  Summary

| Feature        | Benefit                                |
| -------------- | -------------------------------------- |
| Docker Compose | Simplifies multi-service orchestration |
| Repeatability  | Same test environment across platforms |
| Isolation      | No pollution of prod data              |
| CI/CD Friendly | Easily integrated into pipelines       |

Docker Compose makes integration testing both **scalable and maintainable**, especially for microservices and modern cloud-native apps.
