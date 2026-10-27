# PSIRT Helper

A small educational project built to learn how a Product Security
Incident Response Team (PSIRT) works in practice.

I modeled the core parts of the workflow: tracking vulnerabilities, affected products and versions,
severity (CVSS), and the case lifecycle from report to published advisory.

This is a learning project, which goal is to show how these concepts translate into a data model,
an API, and a simple dashboard.

## Architecture

The project consists of three parts:

| # | Component | Technology | Role |
|---|-----------|------------|------|
| 1 | Database | PostgreSQL | Stores vulnerabilities, products, versions and statuses |
| 2 | Backend | Java | REST API with business logic and data access |
| 3 | Frontend | Vue.js | Visualization and UI for working with cases |

### 1. Database (PostgreSQL)

The database runs in a Docker container. On the first start it is
automatically initialized with **fictional sample data** (made-up products and vulnerabilities), so the dashboard has something to show right away.

All data is stored in a Docker volume, so it survives container restarts.
It is only wiped when you explicitly remove the volume.

### 2. Backend (Java)

REST API that exposes the data to the frontend and contains the
business logic.

### 3. Frontend (Vue.js)

Dashboard and case views: open cases, severity distribution, case details.

## Usage

### Prerequisites

- Docker with Docker Compose

No local Java, Node.js or PostgreSQL installation is needed.

### Start

```bash
docker compose up -d
```

### Stop

```bash
docker compose down
```

Containers are removed, but the database volume (and your data) is kept.

### Reset the database

To remove containers and the volume with all data:

```bash
docker compose down -v
```

The next `docker compose up` will create a fresh database and load
the sample data again.