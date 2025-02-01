---
layout: default
title: flaky-test-detection-history-analysis
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## 🧪 Flaky Test Detection with Historical Test Analysis

### Overview

**Flaky tests** are tests that fail non-deterministically — they fail sometimes and pass at other times without any change in the underlying code. These are major productivity killers in CI/CD pipelines and can erode developer trust in test results. A robust flaky test detection strategy involves **historical test analysis**, statistical modeling, and automated quarantine systems.

---

### 🔍 Causes of Flaky Tests

| Category             | Common Issues                                       |
| -------------------- | --------------------------------------------------- |
| **Async/Timing**     | Race conditions, delayed assertions, improper waits |
| **Order-dependence** | Shared state or bad test isolation                  |
| **Environment**      | Resource contention, ports, network dependencies    |
| **External systems** | DBs, APIs, queues that behave unpredictably         |
| **Unclean teardown** | Residual state leaking into next test               |

---

### 🧠 Historical Analysis for Flake Detection

#### 1. **Test Result Logging**

Track the result of each test over time:

* Test name
* Commit hash or build ID
* Pass/Fail status
* Execution time
* Platform/Environment details

Store in a structured format (e.g., Postgres, Elasticsearch, or BigQuery).

#### 2. **Flake Scoring**

Define metrics such as:

* **Flake rate**: `Failures / Total runs`
* **Bounce rate**: Failures followed by pass in next retry
* **Intermittency score**: Normalized standard deviation of results

> 🔁 Example:
>
> ```
> test_login_flow:
>   15 runs → [✓ ✓ ✗ ✓ ✓ ✗ ✓ ✓ ✓ ✓ ✓ ✓ ✗ ✓ ✓]
>   Flake Rate = 3/15 = 20%
> ```

---

### 📊 Visualization

* Heatmaps of flaky test frequency across time or branches
* Time-series dashboards (Grafana, Kibana) for flake trends
* Test correlation graphs (e.g., if test A often fails near test B)

---

### 🛠 Tools for Flake Detection

| Tool                         | Features                                               |
| ---------------------------- | ------------------------------------------------------ |
| **FlakyBot** (Google)        | GitHub Action that detects and quarantines flaky tests |
| **BuildPulse**               | SaaS that collects CI data, ranks flaky tests          |
| **pytest-rerunfailures**     | Useful for retry logic and detection support           |
| **TestAnalytics** (CircleCI) | Test insights with flake analysis                      |
| **Custom ELK Stack**         | Aggregates test logs and applies heuristics            |

---

### 🔁 Retry Logic & Detection

Incorporate retries *only* for detection (not masking flakiness):

```bash
pytest --reruns 2 --only-rerun ".*"
```

If a test passes after 1 or 2 reruns — flag it as potentially flaky.

---

### 🧪 Automated Flaky Test Quarantine

1. Label flake candidates via thresholds (`flake_rate > 10%`)
2. Auto-quarantine in CI (e.g., skip unless manually invoked)
3. Notify developers with links to analysis
4. Periodically reintroduce and retest quarantined tests

> ✅ GitHub Actions Example:

```yaml
if: steps.detect-flake.outputs.flaky == 'true'
run: echo "Quarantining test ${{ matrix.test }}"
```

---

### ✅ Best Practices

* Run tests in isolation and with random seeds
* Record test metadata: CPU load, memory, container ID
* Use `--random-order-bucket=module` (pytest-randomly)
* Separate slow/integration tests into a different job

---

### Conclusion

Historical test analysis is essential for proactively identifying and managing flaky tests. By collecting long-term data, computing flake scores, and integrating detection into CI, teams can prevent unreliable tests from blocking deploys and eroding confidence. The key is **detection, isolation, and continuous cleanup**.
