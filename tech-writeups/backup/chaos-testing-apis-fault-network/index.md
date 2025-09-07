---
layout: default
title: chaos-testing-apis-fault-network
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Chaos Testing APIs with Fault Injection and Network Partitioning

###  What is Chaos Testing?

**Chaos testing** is a discipline within **resilience engineering** that involves deliberately introducing failures into a system to verify its ability to withstand turbulent conditions in production. When applied to **APIs**, chaos testing focuses on how the services behave under various failures such as timeouts, dropped connections, latency spikes, and backend outages.

---

###  Goals

* Ensure **graceful degradation** under failure
* Validate **retry mechanisms** and **fallback logic**
* Test behavior during **dependency outages** or **partial network partitions**
* Detect **single points of failure**

---

##  Techniques for Chaos Testing APIs

### 1. **Fault Injection**

Fault injection introduces artificial errors in a controlled environment to simulate real-world failures.

**Types of Faults:**

| Fault Type       | Example                                  |
| ---------------- | ---------------------------------------- |
| Latency          | Add delay to API response (e.g., +500ms) |
| Error response   | Force 500/503 errors from dependent APIs |
| Resource limits  | Simulate CPU/memory exhaustion           |
| DNS failures     | Fail hostname resolution for API targets |
| Connection drops | Kill TCP connections randomly            |

**Tools**:

* [**Gremlin**](https://www.gremlin.com/)
* [**LitmusChaos**](https://litmuschaos.io/)
* [**Toxiproxy**](https://github.com/Shopify/toxiproxy)
* [**Chaos Mesh**](https://chaos-mesh.org/)
* \[**Istio Fault Injection** (Service Mesh)]

---

### 2. **Network Partitioning**

Simulate real-world failures in **distributed microservices** by blocking or delaying traffic between API services.

**Scenarios to simulate:**

* One service is unreachable (API returns timeout)
* Part of the network is **partitioned** (split-brain)
* Random packet loss or corruption

**Kubernetes Example using Chaos Mesh**:

```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: partition-api
spec:
  action: partition
  mode: one
  selector:
    namespaces:
      - api-namespace
    labelSelectors:
      app: api-service
  direction: to
  target:
    selector:
      namespaces:
        - auth-namespace
      labelSelectors:
        app: auth-service
    mode: all
  duration: "60s"
```

---

### ️ Injecting Chaos in a CI/CD Pipeline

Chaos tests can be automated post-deployment:

```yaml
stages:
  - deploy
  - chaos
  - validate

chaos:
  script:
    - chaosctl inject fault --target=auth-service --latency=500ms
    - chaosctl inject partition --from=api-service --to=db-service
  only:
    - staging
```

You can validate via health checks, alert logs, and synthetic monitoring during the chaos test window.

---

###  Example: Using Toxiproxy with Python

```python
from toxiproxy import Toxic, ToxicDirection, Toxiproxy

proxy = Toxiproxy.from_url("http://localhost:8474")
proxy.create(name="api_downstream", listen="localhost:8666", upstream="api.service:8080")

# Inject 2s latency
proxy.toxics.add(
    Toxic(name="latency", type="latency", stream=ToxicDirection.DOWNSTREAM, attributes={"latency": 2000})
)

# Test API call behavior here (with retry/backoff)
```

---

###  Best Practices

* Always monitor **metrics and logs** during chaos experiments
* Define clear **SLOs/SLAs** and **recovery thresholds**
* Use **feature flags** to disable chaos in critical paths
* Run chaos tests in **non-production** first
* Always run **post-chaos assertions** to validate recovery

---

###  Observability Tools to Pair

* **Prometheus + Grafana** (metrics + alerting)
* **Jaeger** (tracing)
* **ELK Stack** (logging)
* **Datadog / New Relic** (integrated APM)

---

##  Summary

Chaos testing APIs helps simulate unexpected behavior and infrastructure failures in order to build **resilient systems**. With fault injection and network partitioning techniques, you can proactively identify failure points and harden your APIs before real outages occur.
