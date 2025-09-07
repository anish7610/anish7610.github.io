---
layout: default 
title: Auth
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# OAuth 2.0 vs OpenID Connect: Authentication vs Authorization

## Introduction

Modern web applications often rely on third-party services to manage **user identity** and **access control**. Two widely adopted protocols for these tasks are **OAuth 2.0** and **OpenID Connect (OIDC)**. While they are related, they serve fundamentally different purposes.

This write-up explores the **technical differences** between OAuth 2.0 and OpenID Connect, focusing on how they handle **authorization** and **authentication**, respectively.

---

## What is OAuth 2.0?

**OAuth 2.0** is an **authorization framework**. It allows a user to grant limited access to their resources stored on one service to another service, without exposing their credentials.

### Primary Use Case

* **Delegated access to APIs** without sharing credentials.
* Commonly used by applications to access **user data** from services like Google, GitHub, or Facebook.

### Key Components

* **Resource Owner**: The user who owns the data.
* **Client**: The application requesting access to the user’s data.
* **Authorization Server**: Issues access tokens after user consent.
* **Resource Server**: Hosts the protected resources (APIs).

### Grant Types

* **Authorization Code** (most secure)
* **Client Credentials**
* **Implicit** (deprecated for SPAs)
* **Refresh Token**
* **Password Grant** (discouraged)

### What OAuth 2.0 Does

* Issues **access tokens** to allow access to APIs.
* Defines scopes (e.g., `read:user`, `write:repo`) to **limit access**.

### What OAuth 2.0 Does *Not* Do

* Does **not define how to authenticate the user**.
* Does **not return user identity** information by default.

---

## What is OpenID Connect?

**OpenID Connect (OIDC)** is an **authentication layer** built on top of OAuth 2.0.

### Primary Use Case

* **Single Sign-On (SSO)** and user identity verification.
* Enables apps to **know who the user is**, i.e., **authentication**.

### What it Adds to OAuth 2.0

* Introduces an **ID Token**, a JWT (JSON Web Token) that contains user identity information.
* Defines a standard `/userinfo` endpoint to fetch profile data.
* Adds scopes like:

  * `openid` (required to use OIDC)
  * `profile`, `email`, etc.

### ID Token Example (decoded):

```json
{
  "sub": "248289761001",
  "name": "Jane Doe",
  "email": "janedoe@example.com",
  "iss": "https://accounts.google.com",
  "aud": "client-id",
  "exp": 1625070900
}
```

### OIDC Flow

* Reuses OAuth 2.0 Authorization Code flow.
* Additionally returns an **ID Token** alongside the Access Token.

---

## Authentication vs Authorization: Key Differences

| Feature                | OAuth 2.0                          | OpenID Connect                      |
| ---------------------- | ---------------------------------- | ----------------------------------- |
| Purpose                | **Authorization** (access control) | **Authentication** (identity proof) |
| Token Returned         | Access Token                       | Access Token + **ID Token**         |
| Who Uses It            | APIs                               | Web/Mobile apps needing login       |
| User Info Provided     | No                                 | Yes (`ID Token`, `/userinfo`)       |
| Is User Authenticated? | Not guaranteed                     | Yes                                 |

>  **Authorization** = What can the app do?
>  **Authentication** = Who is the user?

---

## Analogy

Imagine logging into a third-party photo editing app using Google:

* **OAuth 2.0** lets the app access your Google Drive photos **after you grant permission**.
* **OpenID Connect** lets the app **log you in using your Google account**, knowing your name and email.

---

## Security Considerations

* Always validate the **audience (`aud`)**, **issuer (`iss`)**, and **expiration (`exp`)** fields in the ID Token.
* Avoid using **OAuth alone for login** — doing so may lead to **confused deputy problems** or impersonation attacks.

---

## Conclusion

While OAuth 2.0 and OpenID Connect often coexist, they serve **different security goals**:

* Use **OAuth 2.0** for **secure delegated access** to APIs.
* Use **OpenID Connect** when you need to **identify and authenticate users**.

When designing modern web and mobile apps, understanding and correctly implementing both is essential to ensure secure authentication and authorization mechanisms.
