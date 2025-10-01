# Pusher Dart Core

Pure dart Pusher core. Contains entities implementation, network interaction and controller logic

Supports GMS and HMS push services

## General

- Dart SDK >=3.4.0

## Project structure

| Structure element      | Description                                                                          |
|------------------------|--------------------------------------------------------------------------------------|
| Network block          | Low-level network interaction, located at **[./lib/src/network](./lib/src/network)** |
| Logic controllers      | Located at **[./lib/src/controller](./lib/src/controller)**                          |
| API entities and types | Located at **[./lib/src/model](./lib/src/model)**                                    |
| Dart extensions        | Located at **[./lib/src/extension](./lib/src/extension)**                            |