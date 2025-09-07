---
layout: default
title: ci-integration 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# CI Integration for Test Result Reporting (e.g., TestRail)

Continuous Integration (CI) is a fundamental part of modern software development, enabling automated build, test, and deployment pipelines. A critical component of this pipeline is **test result reporting**—tracking and analyzing test outcomes in a centralized system like **TestRail**. Integrating your CI/CD pipeline with TestRail allows teams to maintain visibility into test coverage, detect regressions early, and ensure accountability across automated and manual QA processes.

---

##  Benefits of CI-TestRail Integration

* **Automated Result Publishing**: Avoid manual updates by pushing results directly from your CI jobs.
* **Centralized Reporting**: View manual and automated test runs together in one dashboard.
* **Traceability**: Link test results to user stories, test cases, builds, and defects (e.g., Jira).
* **Live Feedback**: Monitor test run status in real-time with each CI/CD trigger.

---

##  Architecture Overview

```
CI/CD Tool (GitHub Actions / GitLab CI / Jenkins / CircleCI)
        |
        |---> Run automated tests (e.g., Pytest, JUnit, TestNG)
        |
        |---> Parse results (XML/JSON/HTML)
        |
        |---> Push results to TestRail using TestRail API
```

---

##  Prerequisites

* TestRail account with API access enabled
* Project and test cases already created in TestRail
* API credentials: `username` (or API key) and `password`
* A CI pipeline configured to run your test suite
* Tests annotated or tagged with TestRail Case IDs (e.g., `C1234`)

---

## ️ Integration Steps

### 1. **Tag Test Cases with TestRail IDs**

Use a consistent naming pattern like `C1234` in your test case names, docstrings, or comments.

```python
# test_login.py
def test_valid_login():
    """C1010 Verify user can login with valid credentials"""
    ...
```

---

### 2. **Export Test Results**

Most test frameworks support result output formats:

* `Pytest` → `pytest --junitxml=result.xml`
* `JUnit/TestNG` → `results.xml`
* `Cypress` → `--reporter junit`

---

### 3. **Parse the Results in CI Pipeline**

Use a test parser to extract case IDs and status.

Sample Python snippet to parse Pytest output:

```python
import xml.etree.ElementTree as ET

def parse_pytest_results(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    results = []
    for testcase in root.iter("testcase"):
        case_id = extract_case_id(testcase.attrib["name"])  # Cxxxx
        status = "passed"
        if testcase.find("failure") is not None:
            status = "failed"
        results.append((case_id, status))
    return results
```

---

### 4. **Push Results to TestRail**

Use the [TestRail API](https://www.gurock.com/testrail/docs/api/reference/results/) to:

* Create a test run
* Add results to test cases

Example using `testrail-api` Python client or raw HTTP:

```python
import requests

testrail_url = "https://yourcompany.testrail.io"
username = "your@email.com"
password = "your_api_key"
project_id = 5
suite_id = 2

# Create a test run
resp = requests.post(
    f"{testrail_url}/index.php?/api/v2/add_run/{project_id}",
    auth=(username, password),
    json={
        "suite_id": suite_id,
        "name": "CI Run - Build #123",
        "include_all": False,
        "case_ids": [1010, 1012, 1020]
    }
)
run_id = resp.json()["id"]

# Add results to the test run
for case_id, status in parsed_results:
    status_id = 1 if status == "passed" else 5  # 1 = Passed, 5 = Failed
    requests.post(
        f"{testrail_url}/index.php?/api/v2/add_result_for_case/{run_id}/{case_id}",
        auth=(username, password),
        json={"status_id": status_id}
    )
```

---

## ️ CI Pipeline Example – GitHub Actions

```yaml
name: Test and Report

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Dependencies
        run: pip install -r requirements.txt

      - name: Run Pytest
        run: pytest --junitxml=result.xml

      - name: Push to TestRail
        run: python scripts/report_to_testrail.py
        env:
          TESTRAIL_USER: ${{ secrets.TESTRAIL_USER }}
          TESTRAIL_PASS: ${{ secrets.TESTRAIL_PASS }}
```

---

##  Best Practices

* **Mark all automated test cases with Case IDs**.
* **Fail fast**: Stop the pipeline if critical tests fail.
* **Add logging** in the integration script for debug and audit.
* **Trigger test run creation dynamically**, using the build number or timestamp.
* **Use environment variables** for TestRail credentials and URLs.
* **Optionally push results to Jira** if integrated with TestRail.

---

##  Sample TestRail Status IDs

| Status   | ID |
| -------- | -- |
| Passed   | 1  |
| Blocked  | 2  |
| Untested | 3  |
| Retest   | 4  |
| Failed   | 5  |

---

##  Advanced Features

* **Custom Fields**: Add automation run metadata like environment, branch, etc.
* **Update existing test runs** instead of creating new ones
* **Integrate with TestRail Milestones**
* **Parallel test execution tracking**

---

##  Summary

CI-TestRail integration ensures real-time, traceable, and accurate test reporting across automated test pipelines. By pushing test results directly to TestRail, teams gain visibility and control over release readiness and can make informed decisions with confidence.
