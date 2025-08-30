---
layout: default
title: prometheus-and-grafana 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Monitoring with Prometheus and Grafana

Monitoring is a fundamental aspect of modern DevOps and SRE practices. Prometheus and Grafana are among the most widely used tools for collecting, analyzing, and visualizing system and application metrics. Together, they form a powerful, open-source monitoring stack.

---

##  What is Prometheus?

**Prometheus** is a time-series database and monitoring system originally developed at SoundCloud. It collects metrics from configured targets at given intervals, evaluates rule expressions, and triggers alerts when certain conditions are observed.

###  Key Features:

* Pull-based metrics collection via HTTP endpoints (`/metrics`)
* Powerful **PromQL** (Prometheus Query Language)
* Multi-dimensional data model with key-value pairs (labels)
* Built-in alert manager
* Scalable and easy to configure

---

##  What is Grafana?

**Grafana** is a multi-platform, open-source analytics and interactive visualization web application. It allows users to query, visualize, alert on, and explore metrics from various data sources, including Prometheus.

###  Key Features:

* Interactive dashboards
* Rich plugin ecosystem
* Alerting and notifications
* Role-based access control
* Data source agnostic (supports Prometheus, Loki, InfluxDB, MySQL, etc.)

---

##  Architecture Overview

```
 [ Target Services ]
         |
     Expose /metrics
         ↓
 [ Prometheus Server ] ← Pulls metrics
         |
 [ Time-Series DB ]
         ↓
 [ Grafana Dashboard ] ← Queries Prometheus
         |
    Visualization & Alerts
```

---

##  Setting Up Prometheus and Grafana

### 1. Export Metrics

Target applications need to expose metrics at an HTTP endpoint (`/metrics`). For example, in Python using `prometheus_client`:

```python
from prometheus_client import start_http_server, Summary

REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

@REQUEST_TIME.time()
def process_request():
    # Simulated workload
    pass

if __name__ == '__main__':
    start_http_server(8000)
    while True:
        process_request()
```

---

### 2. Prometheus Configuration

A minimal `prometheus.yml` config:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'example-app'
    static_configs:
      - targets: ['localhost:8000']
```

Run Prometheus with:

```bash
./prometheus --config.file=prometheus.yml
```

---

### 3. Grafana Setup

* Install Grafana
* Access at `http://localhost:3000` (default creds: admin/admin)
* Add Prometheus as a data source
* Import a dashboard or create a custom one
* Set alerts based on PromQL queries

---

##  Example Metrics to Monitor

* **System**: CPU, Memory, Disk, Network (via Node Exporter)
* **Applications**: Request latency, error rate, throughput
* **Databases**: Connection pool usage, query performance
* **Containers**: Pod health, restart counts (via kube-prometheus-stack)

---

## ️ Alerting with Prometheus

Configure alert rules in `prometheus.yml`:

```yaml
groups:
  - name: instance-down
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
```

Use **Alertmanager** to route alerts via:

* Email
* Slack
* PagerDuty
* Webhooks

---

##  Best Practices

* **Use labels wisely**: Too many labels → high cardinality
* **Alert on symptoms, not causes**: e.g., “Latency > 300ms”
* **Dashboard hygiene**: Avoid cluttered panels, use variables
* **Thanos or Cortex**: For long-term storage and federation

---

##  Use Cases

* Kubernetes monitoring (`kube-prometheus-stack`)
* Microservices performance visualization
* SLA/SLO compliance tracking
* Anomaly detection via Grafana + machine learning plugins

---

##  Tools and Exporters

| Tool              | Purpose                           |
| ----------------- | --------------------------------- |
| Node Exporter     | OS-level metrics                  |
| Blackbox Exporter | Probes for endpoints (HTTP, ICMP) |
| cAdvisor          | Container metrics                 |
| Alertmanager      | Alert routing and deduplication   |
| Grafana Loki      | Logs aggregation                  |

---

##  Conclusion

Prometheus and Grafana provide a robust, flexible, and scalable monitoring stack that’s widely adopted in cloud-native environments. Prometheus handles metric collection and alerting, while Grafana turns those metrics into rich dashboards and insights.
