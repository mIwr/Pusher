# Pusher

[![Platform](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS-4E4E4E.svg?colorA=28a745)](#Setup)

Push message sender to mobile platforms

## Content

- [Introduction](#Introduction)

- [Setup](#Setup)

## Introduction

The app provides an interface for sending push messages to mobile devices. Supported message services:

- Google Messaging Services (GMS) through FCM v1 HTTP API (Firebase): Android, iOS
- Huawei Messaging Services (HMS): Android

Pusher supports the next platforms:

+ Android
+ iOS
+ Windows
+ Linux
+ macOS
+ Web (Limited & Experimental)

## Setup

### Firebase

To send push messages through FCM you need:

- Created Firebase project with app(-s) (Android or/and iOS)
- Service account credentials (JSON) for OAuth. Account must have permissions to send push messages
- APNs certificates (iOS apps only), required an account with active Apple Developer Program

Service account credentials example (Can be downloaded from console.cloud.google.com of the current project):

```json
{
  "type": "service_account",
  "project_id": "_firebase_proj_id_",
  "private_key_id": "key_id_hex",
  "private_key": "-----BEGIN PRIVATE KEY-----\n_key_\n-----END PRIVATE KEY-----\n",
  "client_email": "name@_firebase_proj_id_.iam.gserviceaccount.com",
  "client_id": "_firebase_client_id_",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/name%40_firebase_proj_id_.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
```

### Huawei

To send push messages through HMS you need:

- Active Huawei developer account
- Created app in account with enabled PushKit capability
- OAuth credentials (appID/projectID, client ID, client secret)