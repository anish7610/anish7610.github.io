---
layout: default
title: feature-engineering 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Feature Engineering Techniques in Fraud Detection

Fraud detection, particularly in domains like banking, e-commerce, and insurance, relies heavily on the quality of features fed into machine learning models. Since fraudulent activities often mimic legitimate ones, carefully crafted features can significantly enhance model performance by uncovering hidden patterns. This writeup explores key **feature engineering techniques** specifically tuned for fraud detection use cases.

---

## 🧠 What is Feature Engineering?

Feature engineering is the process of transforming raw data into informative inputs for machine learning models. In fraud detection, this includes constructing features that capture:

* Behavioral anomalies
* Temporal/spatial inconsistencies
* Historical patterns
* Aggregate metrics
* Entity relationships

---

## 🧩 Types of Features in Fraud Detection

### 1. **Transactional Features**

These are directly extracted from each transaction.

| Feature     | Description                                   |
| ----------- | --------------------------------------------- |
| `amount`    | Monetary value of transaction                 |
| `merchant`  | Merchant or vendor ID                         |
| `category`  | Type of transaction (e.g., electronics, food) |
| `timestamp` | Time of the transaction                       |

**Transformations:**

* Log-transform the `amount` to reduce skew.
* One-hot encode or target-encode `category`.

---

### 2. **Behavioral Features**

Capture user spending behavior over time:

* Average amount per transaction
* Number of transactions in last 24h/7d
* Ratio of online vs in-store transactions
* Time since last transaction
* Velocity features (e.g., transactions per hour)

```python
df['txn_per_hour'] = df.groupby('user_id')['transaction_id'].transform(lambda x: x.count() / 24)
```

---

### 3. **Historical Aggregates**

Use rolling windows to detect deviation from normal behavior:

* Rolling average transaction amount over N days
* Standard deviation or z-score of past spending
* Frequency of visiting same merchant

```python
df['rolling_avg_7d'] = df.groupby('user_id')['amount'].transform(lambda x: x.rolling('7D').mean())
```

---

### 4. **Geospatial Features**

* Distance between current and last known location
* Transactions from different countries within short time
* IP address-based risk scoring

```python
def haversine(lat1, lon1, lat2, lon2):
    # Compute geodesic distance between two points
    ...
```

---

### 5. **Temporal Features**

Fraud tends to follow abnormal timing patterns:

* Hour of day or day of week
* Night-time or weekend transactions
* Time gaps between successive transactions

```python
df['hour'] = pd.to_datetime(df['timestamp']).dt.hour
df['is_night'] = df['hour'].apply(lambda x: x < 6 or x > 22)
```

---

### 6. **Categorical Encoding**

* Target encoding (replace merchant/category with fraud rate)
* Frequency encoding
* Embedding for deep learning models

```python
# Target encoding example
fraud_rate = df.groupby('merchant_id')['is_fraud'].mean()
df['merchant_fraud_rate'] = df['merchant_id'].map(fraud_rate)
```

---

### 7. **Entity Linking Features**

* Shared card number, device ID, or IP address across multiple users
* Transactions from different users using the same device
* Graph-based clustering for fraud rings

---

### 8. **Time Series & Sequence Features**

* LSTM input sequences: past N transactions
* Markov chains: transitions between merchants
* Sessionization of transaction patterns

---

## 🛠 Best Practices

* Normalize or scale numeric features
* Handle class imbalance (SMOTE, undersampling)
* Avoid data leakage (e.g., future info)
* Use cross-validation across time splits
* Monitor concept drift in production

---

## 🧪 Real-World Example

```python
# Creating a velocity feature for transaction count in past hour
df['txn_last_1hr'] = df.groupby('user_id')['timestamp'].rolling('1H').count().reset_index(0,drop=True)
```

Fraudulent accounts may show bursts of transactions in short windows—a strong feature for anomaly detection.

---

## 🔍 Tools and Libraries

* **Pandas** / **Polars** – Data manipulation
* **scikit-learn** – Preprocessing, pipelines
* **XGBoost/LightGBM** – Tree-based models
* **PyOD** – Outlier detection
* **GraphFrames** – Fraud ring detection in Spark

---

## 🎯 Conclusion

Feature engineering is central to fraud detection. Unlike some ML applications, off-the-shelf models perform poorly without customized domain features. A deep understanding of both domain context and user behavior is key to designing high-value features that surface subtle fraud signals.

In production systems, feature pipelines must be efficient, scalable, and real-time, especially when used with streaming platforms like Apache Kafka and Spark Streaming.
