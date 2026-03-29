# Volentry — Volunteer Signup Platform

A modern, friction-free volunteer management system for sports clubs and community organizations. Volunteers sign up in 3 clicks (no login required), and admins get real-time visibility into coverage and volunteer commitments.

**Domain:** [volentry.com](https://volentry.com)

---

## 🎯 Problem Statement

Sports clubs and community organizations struggle with volunteer signup:
- **Existing tools are clunky** (SignupGenius is dated, hard to navigate)
- **Volunteers face friction** (login required, multi-step forms)
- **Admins lack visibility** (no real-time roster updates, can't see shortfalls instantly)
- **No enforcement** (volunteers cancel last-minute with no guardrails)

**Volentry solves this:** Radically simple signup (3 clicks, no login) + real-time admin visibility + 2-day cancellation rule to protect event coverage.

---

## 🚀 Quick Start

### Prerequisites
- .NET 8 SDK
- Node.js 18+ (for frontend tooling)
- Azure account (for CosmosDB, SignalR, Communication Services)
- Docker (optional, for local dev)

### Local Development

```bash
# Clone repo
git clone https://github.com/omegasq/sign-up.git
cd sign-up

# Setup backend
cd src/VolunteerService
dotnet restore
dotnet build
dotnet run

# In another terminal, setup admin service
cd src/AdminService
dotnet restore
dotnet build
dotnet run

# Frontend (if applicable)
cd frontend
npm install
npm run dev
```

### Environment Setup

Copy `.env.example` to `.env.local` and fill in:
```bash
# Azure
AZURE_COSMOSDB_CONNECTION_STRING=
AZURE_SERVICEBUS_CONNECTION_STRING=
AZURE_SIGNALR_CONNECTION_STRING=
AZURE_COMMUNICATION_SERVICES_CONNECTION_STRING=

# Email
EMAIL_FROM_ADDRESS=noreply@volentry.com
ADMIN_EMAIL=support@volentry.com
ADMIN_PHONE=

# Auth
JWT_SECRET=your-secure-random-key
JWT_EXPIRY_HOURS=24
```

---

## 📁 Project Structure

```
sign-up/
├── README.md (this file)
├── .gitignore
├── LICENSE
│
├── _bmad-output/
│   └── planning-artifacts/
│       ├── prd.md                          # Product requirements (master)
│       ├── architecture.md                 # Technical architecture (master)
│       ├── ux-design-specification.md      # UX specs + wireframes (master)
│       └── epics.md                        # 36 user stories (implementation spec)
│
├── src/
│   ├── VolunteerService/
│   │   ├── VolunteerService.csproj
│   │   ├── Program.cs
│   │   ├── Controllers/
│   │   ├── Services/
│   │   └── ...
│   │
│   └── AdminService/
│       ├── AdminService.csproj
│       ├── Program.cs
│       ├── Controllers/
│       ├── Services/
│       └── ...
│
├── infrastructure/
│   ├── main.tf                             # Terraform root module
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── cosmosdb/
│       ├── service-bus/
│       ├── signalr/
│       └── ...
│
├── tests/
│   ├── VolunteerService.Tests/
│   ├── AdminService.Tests/
│   └── ...
│
├── docs/
│   ├── API.md                              # API documentation
│   ├── ARCHITECTURE.md                     # Architecture overview
│   └── DEPLOYMENT.md                       # Deployment guide
│
├── design-artifacts/                       # Figma exports, mockups, etc.
├── .github/
│   └── workflows/                          # GitHub Actions CI/CD
└── .gitignore
```

---

## 📋 Features (MVP)

### For Volunteers
- ✅ **3-click signup** (no login, no email verification)
- ✅ **Hierarchical volunteer board** (view days, then roles)
- ✅ **Real-time slot counts** (see as others sign up)
- ✅ **Calendar integration** (.ics file with email confirmation)
- ✅ **Self-service cancellation** (with 2-day guardrail)
- ✅ **Club search** (find your team on volentry.com)

### For Admins
- ✅ **Secure login** (username + password, bcrypt)
- ✅ **Event management** (create events, define timeslots, set custom roles)
- ✅ **Live roster** (see who signed up in real-time)
- ✅ **Coverage visibility** (spot shortages instantly, urgency indicators)
- ✅ **Admin team management** (invite admins, role hierarchy, deactivation)
- ✅ **Manual volunteer management** (add, reassign, remove)

### Technical
- ✅ **Event sourcing** (immutable audit trail)
- ✅ **Multi-tenancy** (separate CosmosDB per organization)
- ✅ **Concurrency safety** (Service Bus queue for signups)
- ✅ **Real-time updates** (Azure SignalR Service)
- ✅ **No passwords in logs** (bcrypt hashing)
- ✅ **Privacy-first** (only first name + last initial visible publicly)

---

## 🏗️ Architecture

**See `/planning-artifacts/architecture.md` for complete technical spec.**

### Services
- **VolunteerService:** Public APIs (no auth required)
  - Club search, volunteer board, signup, cancellation
  
- **AdminService:** Authenticated APIs (JWT required)
  - Event creation, admin management, manual volunteer ops

### Data Storage
- **CosmosDB:** Separate database per organization (event log + materialized views)
- **Azure Service Bus:** Queue for signup validation (concurrency safe)
- **Azure SignalR Service:** Real-time updates (volunteer board, admin roster)

### Infrastructure
- **Terraform:** IaC for all Azure resources
- **GitHub Actions:** CI/CD pipeline (test, build, deploy)
- **Docker:** Local development & containerized deployment

---

## 🎯 Implementation Plan

**36 user stories across 8 epics, fully detailed in `epics.md`:**

| Phase | Epics | Timeline |
|-------|-------|----------|
| **1** | Epic 0 (Foundation scaffolding) | Weeks 1-2 |
| **2** | Epic 0b (Design system) | Weeks 3-4 |
| **3** | Epics 1, 5, 6 (Core volunteer + admin) | Weeks 5-8 |
| **4** | Epics 3, 4 (Real-time + email) | Weeks 9-10 |
| **5** | Epics 2, 7 (Cancellation + volunteer mgmt) | Week 11 |
| **6** | Testing, security audit, ship MVP | Week 12 |

**See `_bmad-output/planning-artifacts/epics.md` for all story details.**

---

## 🔐 Security

### Authentication
- Admin login: username + password (bcrypt 12 rounds)
- JWT tokens (24-hour expiry, httpOnly cookies)
- Token-based admin invites (24-hour, one-time use)

### Data Privacy
- Volunteers: phone-based lookup, no accounts (MVP)
- Names: only first + last initial visible publicly
- Event log: immutable audit trail (tamper-proof)
- Encryption: at-rest (CosmosDB) + in-transit (HTTPS/TLS)

### DDoS Protection
- Azure DDoS Protection Standard (public endpoints)
- Rate limiting: 10 req/min per IP (signup API)
- Input validation: FluentValidation on all APIs
- CSRF tokens: standard ASP.NET Core

---

## 📊 Key Metrics (MVP)

| Metric | Target | Notes |
|--------|--------|-------|
| Volunteer board load | <2 seconds | Typical internet |
| Signup form response | <100ms | After click |
| Email delivery | <10 seconds | After signup |
| Real-time updates | <100ms | Via WebSocket |
| Concurrent signups | 50/min | Peak load |
| Typical load | 10/hour | Sustainable |

---

## 📚 Documentation

- **[API Documentation](docs/API.md)** — All endpoints, request/response formats
- **[Architecture Overview](docs/ARCHITECTURE.md)** — Technical decisions & trade-offs
- **[Deployment Guide](docs/DEPLOYMENT.md)** — How to deploy to Azure
- **[Epic Specifications](/_bmad-output/planning-artifacts/epics.md)** — All 36 stories with acceptance criteria

---

## 🛠️ Development Workflow

### Before You Code
1. Read `/planning-artifacts/epics.md` for the story you're implementing
2. Review acceptance criteria (AC) — these are your definition of done
3. Check dependencies (what stories must complete first)

### While Coding
1. Write tests first (TDD approach)
2. Implement to AC, not beyond
3. One story = one PR (clear review scope)

### Pull Requests
- Link to story from epics.md
- Reference acceptance criteria in PR description
- Require code review before merge
- All tests must pass (100% coverage for story changes)

---

## 🚀 Deployment

### Development
```bash
docker-compose up -d
```

### Staging / Production
```bash
cd infrastructure
terraform init
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

**See `docs/DEPLOYMENT.md` for full deployment walkthrough.**

---

## 💡 Key Design Decisions

1. **Event Sourcing:** Immutable event log (not traditional CRUD)
   - Enables: audit trail, 2-day rule enforcement, time-travel queries
   
2. **Multi-Tenancy:** Separate CosmosDB database per organization
   - Simpler security boundary, independent scaling
   
3. **No Volunteer Login (MVP):** Phone-based lookup only
   - Lower friction, faster signup (3 clicks)
   - Future: add volunteer accounts in Release 2
   
4. **Real-Time Updates:** Azure SignalR Service
   - Builds trust, reduces need for page refresh
   - Delta updates only (bandwidth efficient)
   
5. **Concurrency Safety:** Azure Service Bus queue
   - Multiple volunteers clicking same slot? Safe.
   - First N succeed (where N = capacity), rest get "slot full"

---

## 📧 Support

For questions or issues:
- **Email:** [support@volentry.com](mailto:support@volentry.com)
- **GitHub Issues:** Open an issue in this repo
- **Slack:** (internal team communication)

---

## 📄 License

[Add appropriate license here — e.g., MIT, Apache 2.0]

---

## 🎉 Acknowledgments

Built with:
- ASP.NET Core 8
- Azure (CosmosDB, Service Bus, SignalR, Communication Services)
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)

---

## 🗺️ Roadmap

### MVP (Release 1, Q2 2025)
- ✅ Volunteer signup & discovery
- ✅ Admin event management
- ✅ Real-time roster updates
- ✅ Email confirmations + calendar invites
- ✅ Admin role hierarchy

### Release 2 (Q3 2025)
- Volunteer accounts + email-based login
- Smart redirect on volentry.com
- Advanced analytics (signup trends, no-shows)
- SMS reminders (before event)

### Release 3+ (Future)
- Mobile app (iOS/Android)
- Integration with calendar providers
- Expense tracking (reimbursements)
- Team performance analytics

---

**Questions? Open an issue or email support@volentry.com** 🚀
