---
stepsCompleted: ["step-01-init", "step-02-context", "step-03-starter", "step-04-decisions"]
inputDocuments: ["/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/prd.md"]
workflowType: 'architecture'
project_name: 'Volunteer Signup Platform'
user_name: 'Anton'
date: '2026-03-28T13:43:03.705Z'
architectureComplete: true
readyForImplementation: true
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**

The PRD specifies 15+ core features organized into two main domains:

**Volunteer Experience (Public, No Auth):**
- Real-time event and timeslot discovery
- Simple 3-click signup (name, phone, email, team)
- Real-time availability display with capacity tracking
- Self-service cancellation with 2-day guard rail
- Public board with name-based filtering
- Email + SMS confirmations with calendar invites
- Clear blocking of late cancellations with admin contact message

**Admin Experience (Authenticated):**
- Username + password login with bcrypt hashing
- Event creation with flexible timeslot management
- Custom role definition (1-5 roles per slot, custom names)
- Capacity management per role
- Manual volunteer add/assign/remove
- Real-time roster viewing with full contact info
- Admin invite capability (Super-Admin role)
- Role-based access control (Super-Admin vs Regular Admin)

**Non-Functional Requirements (Critical to Architecture):**

1. **Multi-Tenancy**: Separate CosmosDB per organization (complete isolation)
2. **Event Sourcing**: Immutable event log as source of truth (no data loss)
3. **Real-Time Updates**: WebSocket or polling for live board/roster updates
4. **Concurrency Handling**: Queue-based validation for simultaneous signup attempts
5. **Performance**: ~50/min peak load, typically 10/hour (light load)
6. **Security**: DDoS protection, IP-based rate limiting, bcrypt hashing, encryption at rest
7. **Accessibility**: WCAG 2.1 Level AA (semantic HTML, keyboard nav, screen readers)
8. **Reliability**: 2-day cancellation window enforced, graceful degradation acceptable
9. **Communications**: Email + SMS confirmations + RFC 5545 calendar invites (MVP)

### Technical Constraints & Dependencies

**Architecture Decisions Already Locked In:**
- **.NET 8 backend** with two services: Volunteer Service (public) and Admin Service (auth required)
- **Event-sourced architecture** with immutable event log
- **Azure CosmosDB** for persistence (separate database per organization)
- **Azure Container Apps** deployment
- **Terraform IaC** (not Bicep)
- **Azure DDoS Protection + rate limiting** for public API
- **Queue-based concurrency handling** for signup collisions

**Communications Strategy:**
- Choice between Azure Communication Services or SendGrid (cost evaluation deferred to implementation)
- RFC 5545 calendar invite generation
- Email + SMS both in MVP scope

**Data Model Complexity:**
- Organization entity (with branding/logo)
- Event entity (date/time metadata)
- Timeslot entity (linked to event, with capacity rules)
- Role entity (custom names, per-slot capacity)
- Volunteer signup entity (with name, phone, email, team, timestamp)
- Admin user entity (username, hashed password, role assignment)
- Event log (immutable audit trail)

### Scale & Complexity Assessment

**Project Complexity:** Medium-High (Well-defined but architecturally sophisticated)

- **Primary Domain:** Full-stack web application (frontend + backend)
- **Estimated Architectural Components:** 2 services, 2 API layers, 3 main data models, event log, queue service, real-time signaling, communications service, auth middleware, rate limiting

**Cross-Cutting Concerns:**
- **Multi-tenancy** affects every data access path
- **Event sourcing** changes how writes are structured
- **Real-time updates** affects both frontend and backend
- **Concurrency safety** requires queue-based validation
- **Data privacy** requires encryption and access control throughout

---

## Architecture Decision Records

### Decision 1: Multi-Tenancy Strategy - Separate DB Per Org vs Shared Database with Partitioning

**DECISION: Separate CosmosDB per organization**

**Rationale:**
- **Security:** Complete isolation eliminates cross-tenant data leakage risk. A misconfigured query cannot expose one org's data to another.
- **Compliance:** GDPR and data privacy are trivial to implement with separate databases. Each org's data is isolated by design, not by application logic.
- **Reliability:** If one org's database has issues, others are unaffected. Independent scaling and backup per organization.
- **Operational Trade-off:** Managing 100+ databases requires more operational overhead than a shared database, but cost and automation tools mitigate this. Founded-backed MVP can absorb this complexity.

**Alternatives Considered:**
- Shared database with row-level security: simpler operations but requires application-level enforcement of partition isolation (higher risk)
- Separate database per org: chosen ✅

---

### Decision 2: Event Sourcing - Is It Essential or Over-Engineering?

**DECISION: Event Sourcing with immutable event log as source of truth**

**Rationale:**
- **Concurrency Safety:** Event log provides natural serialization point for conflicting signups. First signup to enter the queue wins; rest get "slot full."
- **Audit Trail:** Every signup, cancellation, reassignment is an immutable fact. Tampering with audit data is impossible (no soft deletes needed).
- **2-Day Cancellation Logic:** Enforcement is trivial with event sourcing. The immutable log guarantees the rule cannot be violated by accident.
- **No Data Loss:** Per PRD requirement for "zero data loss guarantee."
- **Operational Trade-off:** CosmosDB write amplification (event log + materialized view) is acceptable given Azure's cheap write pricing and low peak load (50/min).

**Alternatives Considered:**
- Simple relational DB with audit tables: higher risk of accidental modifications, more complex concurrency logic
- Event sourcing: chosen ✅

---

### Decision 3: Real-Time Updates - WebSocket vs Polling

**DECISION: WebSocket with Azure App Service native support**

**Rationale:**
- **User Experience:** Volunteers see availability updates instantly as other volunteers sign up. No 5-second polling delay.
- **Load Profile:** 50/min peak is low. Polling at 5-second intervals would create hundreds of thousands of unnecessary requests daily. WebSocket reduces load.
- **Connection Management:** Azure App Service has built-in WebSocket support. No additional complexity.
- **Volunteer Behavior:** Volunteers typically watch the board for 30 seconds before signing up or leaving. Persistent connection overhead for 30 seconds is justified.
- **Operational Trade-off:** WebSocket connection management is simpler than distributed polling logic.

**Alternatives Considered:**
- Server-sent events (SSE): unidirectional; doesn't help with admin-to-client updates
- Polling every 5 seconds: simpler but inefficient, poor UX
- WebSocket: chosen ✅

---

### Decision 4: Queue-Based Concurrency Handling - Is This Necessary?

**DECISION: Azure Service Bus queue for concurrent signup validation**

**Rationale:**
- **Race Condition Safety:** CosmosDB does not support pessimistic locking. Without a queue, simultaneous signups to the same slot can race.
- **Ordering Guarantee:** Queue ensures first signup to enter wins. Second signup gets "slot full" message. No ambiguity.
- **Idempotence:** If the same signup request is retried (due to network failure), the queue handles it gracefully. No duplicate signups.
- **Simplicity:** Queue-based approach is simpler than application-level deduplication or optimistic concurrency with complex retry logic.
- **Operational Trade-off:** Azure Service Bus is a managed service. No operational overhead beyond what's already needed for the application.

**Alternatives Considered:**
- CosmosDB optimistic concurrency with retry: error-prone, client complexity
- Application-level locking: won't work in distributed system
- Queue-based serialization: chosen ✅

---

### Decision 5: Communications Service - Azure Communication Services vs SendGrid

**DECISION: Deferred to implementation phase**

**Rationale:**
- **Cost Comparison Required:** Both services are viable. Cost depends on projected email/SMS volume at implementation time.
- **Both Secure:** No security difference between options. Both have strong track records.
- **Integration Trade-off:**
  - SendGrid: battle-tested, cheaper (likely), third-party dependency
  - Azure Communication Services: native Azure integration, future flexibility for SMS/Teams integrations

**Decision Point:** Evaluate actual email/SMS volumes during implementation. Choose based on cost per 100 signups.

---

## Summary Table

| Decision | Choice | Trade-Off | Confidence |
|----------|--------|-----------|-----------|
| Multi-Tenancy | Separate DB per org | Operational complexity ↔ Zero cross-tenant risk | High ✅ |
| Event Sourcing | Immutable event log | Write amplification ↔ Concurrency safety + audit trail | High ✅ |
| Real-Time Updates | WebSocket | Connection management ↔ Instant UX + lower load | High ✅ |
| Concurrency Handling | Queue-based (Service Bus) | Service dependency ↔ Ordering guarantee + idempotence | High ✅ |
| Communications | Deferred evaluation | TBD | Medium (deferred) ⏳ |

---

## Starter Template Evaluation

### Primary Technology Domain

**Full-stack Web API with event-sourced backend and two independent services (Volunteer Service + Admin Service).**

Per PRD specification: .NET 8 with C#, backend services with event sourcing architecture, CosmosDB persistence, and Azure Container Apps deployment.

### Starter Options Evaluated

**Option 1: Clean Architecture Template** (`dev-Umer/dotnet8-clean-architecture-template`)
- **Strengths:** 
  - Clean Architecture layers (Core, Application, Infrastructure, WebAPI) align with multi-service architecture
  - CQRS pattern with MediatR (Commands & Queries separation) maps naturally to event sourcing
  - Structured for extensibility without forcing architectural patterns
  - Testing framework included (xUnit + Moq + FluentAssertions) — critical for event log and concurrency testing
  - Recent maintenance (2025) — security patches and .NET updates tracked
  - MIT licensed, no vendor lock-in
- **Gaps:** No event sourcing patterns included (custom implementation required), no CosmosDB configuration
- **Recommendation:** ✅ **SELECTED**

**Option 2: Smart .NET Web API** (`Raz4492/dotnet-webapi-entity-framework-starter-kit`)
- **Strengths:** JWT authentication, Redis caching, Repository pattern with Unit of Work
- **Gaps:** No CQRS, no event sourcing, designed for simpler CRUD architectures
- **Verdict:** Not aligned with event sourcing requirements

**Option 3: Minimal .NET 8 Web API**
- **Verdict:** False economy for solo implementer — 2 hours saved upfront, 10+ hours rebuilding boilerplate

### Selected Starter: Clean Architecture Template with Custom Event Sourcing

**Rationale for Selection:**
- CQRS + MediatR foundation maps directly to event sourcing (Commands create events; Queries materialize views)
- Layered architecture supports both Volunteer Service and Admin Service without modification
- Testing infrastructure included (xUnit + Moq) enables confident implementation of event log and concurrency logic
- For solo implementer, conventions over blank canvas reduces decision overhead
- Active maintenance reduces security risk and .NET version deprecation concerns
- CosmosDB and queue-based concurrency are implementation-level customizations, not architectural rework

**Multi-Agent Validation:**
Party mode discussion with Winston (Architect), Amelia (Developer), Murat (Test Architect), Mary (Analyst), and Barry (Quick Flow Solo Dev) confirmed this choice across:
- Architectural alignment (CQRS → event sourcing mapping)
- Implementation pragmatism (solo developer efficiency)
- Quality assurance (test framework inclusion)
- Business sustainability (active maintenance, knowledge transferability)
- Time-to-launch (conventions reduce scaffolding work)

**Initialization Command:**

```bash
# Clone and setup the Clean Architecture template
git clone https://github.com/dev-Umer/dotnet8-clean-architecture-template.git volunteer-signup
cd volunteer-signup

# Install dependencies (if not done by template)
dotnet restore

# Setup test projects
dotnet test
```

Then customize for:
- CosmosDB persistence (replace SQL Server EF Core configuration)
- Event sourcing patterns (immutable event log)
- Multi-tenant data access (per-organization isolation)
- Queue-based concurrency (Azure Service Bus integration)
- WebSocket real-time updates

### Architectural Decisions Provided by Starter

| Area | Decision | Your Use | Notes |
|------|----------|----------|-------|
| **Language & Runtime** | C# 12, .NET 8 | ✅ Matches requirements | Latest stable version |
| **API Framework** | ASP.NET Core Web API | ✅ Perfect for Volunteer + Admin services | Native WebSocket support |
| **Architecture Pattern** | Clean Architecture (4-layer) | ✅ Supports service separation | Core, Application, Infrastructure, WebAPI |
| **Command/Query Pattern** | CQRS with MediatR | ✅ Aligns with event sourcing | Commands → Events, Queries → Views |
| **Data Access** | Entity Framework Core + Repository Pattern | ⚠️ Needs CosmosDB adaptation | Will customize for document database |
| **Authentication** | Not included | ✅ You'll add custom username/password | Supports bcrypt hashing |
| **Validation** | FluentValidation | ✅ Use for form validation | Volunteer signup form validation |
| **Testing** | xUnit + Moq + FluentAssertions | ✅ Perfect for event log testing | Unit tests, integration tests, mock services |
| **Logging** | Serilog | ✅ Structured logging for audit trail | Event log queries are auditable |
| **Dependency Injection** | Built-in ASP.NET Core DI | ✅ Standard approach | No external DI containers needed |
| **Database** | SQL Server (via EF Core) | ⚠️ Replace with CosmosDB | First customization task |

### Customization Path (Implementation Order)

**Phase 1: Foundation Setup**
1. Clone and validate template structure
2. Understand project layout and dependency patterns
3. Replace SQL Server/EF Core with CosmosDB client library

**Phase 2: Event Sourcing Implementation**
4. Implement immutable event log pattern
5. Create event store and event models
6. Build event replay and projection logic

**Phase 3: Multi-Tenant & Concurrency**
7. Implement per-organization database isolation
8. Integrate Azure Service Bus for queue-based signup validation
9. Add concurrency safety tests

**Phase 4: Real-Time Features**
10. Add WebSocket support for live board updates
11. Implement admin roster real-time refresh

**Phase 5: Communications & Deployment**
12. Integrate email/SMS service (SendGrid or Azure Comm Services)
13. Add calendar invite generation
14. Configure Terraform IaC for Container Apps deployment

---

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):** ✅ All locked in below

**Important Decisions (Shape Architecture):** ✅ All locked in below

**Deferred Decisions (Post-MVP):** 
- API versioning (add when third-party integrations demand it)
- Custom organization branding beyond logo (v2+)
- Cross-organization volunteer network (v3+)

---

### Data Architecture

**Decision: Separate CosmosDB Collections with Event Sourcing**

**Structure per Organization:**

```
/volunteer-signup-{orgid}/ (separate database per org)
├── organizations/          (metadata, branding, admin list, logo)
├── events/                 (Event documents - event definitions, timeslots, capacity)
├── event-log/             (Immutable audit log - all state changes, enforced at insert)
└── volunteers/            (Current signup state - materialized view from event log)
```

**Partition Key Strategy:** `/organizationId` at container level
- Each document naturally scoped to organization
- Complete isolation (no cross-org queries possible)
- Leverages CosmosDB's native multi-tenant capabilities

**Event Log Scalability Analysis:**
- 10-year lifespan × 365 days × 50 peak signups/day = 182,500 events per org
- At ~500 bytes per event ≈ 91 MB per org
- **Result:** Well within practical limits; separate collections eliminate document size concerns indefinitely
- Satisfies both solo implementer needs (manageable complexity) and long-term scalability

**Event Log Immutability:** Enforced at application layer
- Append-only writes to `event-log` collection
- No deletes, no updates — only inserts
- Guarantees audit trail integrity

**Materialized Views Strategy:**
- `volunteers` collection contains current signup state
- Updated via projection logic triggered by event log inserts
- Enables fast reads while maintaining immutable source of truth

**CosmosDB Configuration:**
- Consistency level: Session (strong consistency for admin operations, eventual for reads)
- Throughput: Autoscale 400-4000 RU/s per org (adjustable based on usage)
- TTL: Optional on event-log for GDPR compliance (configurable per org)

---

### Authentication & Security

**Decision: Per-Organization Admin Users with bcrypt + Token-Based Invites**

**Admin User Storage:**
- Separate `AdminUsers` collection per organization
- Isolation: Admin users from Org A cannot access Org B data (enforced at DB level)

**Password Security:**
- Hashing: bcrypt via `BCrypt.Net-Next` NuGet package (industry standard, salted)
- Storage: Never store plaintext passwords
- Validation: Compare bcrypt hash at authentication time

**Admin Roles:**
- **Super-Admin:** Can create and invite additional admins, manage org settings
- **Regular Admin:** Can manage events, timeslots, volunteers (no admin creation)
- **Enforcement:** Role checked in authorization middleware on protected endpoints

**Admin Invite Flow:**
1. Super-Admin initiates invite (provides invitee email)
2. System generates secure temporary token (GUID, 24-hour expiration)
3. Email sent to invitee with invite link containing token
4. Invitee clicks link, sets their own password (bcrypt hashed)
5. Token invalidated after first use (prevents replay attacks)

**Public Signup (No Auth):**
- Volunteer signup requires **no credentials**, no authentication
- Security enforced via:
  - IP-based rate limiting (10 requests/min per IP, Azure WAF)
  - DDoS protection (Azure DDoS Protection Standard)
  - Input validation (FluentValidation on all public endpoints)
  - CSRF token on form submission (standard ASP.NET Core)

---

### API & Communication Patterns

**Decision: Microservices Architecture with Two Independent Services**

**Service Separation:**

**VolunteerService** (Public, No Authentication)
- Routes: `/api/volunteer/*`
- Deployment: Separate ASP.NET Core project
- Security: Rate limiting + DDoS protection + input validation
- Endpoints:
  - `GET /api/volunteer/orgs/{orgName}` — Org metadata (logo, branding)
  - `GET /api/volunteer/orgs/{orgName}/events` — List upcoming events
  - `GET /api/volunteer/orgs/{orgName}/events/{eventId}/slots` — Timeslots with availability
  - `POST /api/volunteer/orgs/{orgName}/slots/{slotId}/signup` — Submit signup
  - `POST /api/volunteer/orgs/{orgName}/slots/{slotId}/cancel` — Cancel signup
  - `GET /api/volunteer/orgs/{orgName}/signups?name={filter}` — Find own signups (public board)

**AdminService** (Authenticated)
- Routes: `/api/admin/*`
- Deployment: Separate ASP.NET Core project
- Security: JWT/token-based authentication (custom middleware)
- Endpoints:
  - `POST /api/admin/events` — Create event
  - `PUT /api/admin/events/{eventId}` — Update event
  - `POST /api/admin/events/{eventId}/slots` — Create timeslots
  - `PUT /api/admin/slots/{slotId}` — Update slot capacity/roles
  - `GET /api/admin/volunteers` — View roster with contact info
  - `POST /api/admin/volunteers` — Manually add volunteer
  - `PUT /api/admin/volunteers/{volunteerId}` — Reassign volunteer
  - `DELETE /api/admin/volunteers/{volunteerId}` — Remove volunteer
  - `POST /api/admin/admins/invite` — Invite additional admin (Super-Admin only)

**Shared Infrastructure:**
- `Core` library: Domain models, event definitions, shared constants
- `Infrastructure` library: CosmosDB client, event log access, shared middleware
- `Shared.Tests` library: Test fixtures, mock repositories

**Error Response Format: RFC 7807 (Problem Details)**

Standard response for errors:
```json
{
  "type": "https://myvolunteerapp.com/errors/slot-full",
  "title": "Slot Capacity Exceeded",
  "status": 409,
  "detail": "The requested slot has reached maximum capacity. Please select another time.",
  "instance": "/api/volunteer/orgs/myclub/slots/s123/signup",
  "timestamp": "2026-03-28T14:15:00Z"
}
```

**Benefits:**
- Structured, standardized format (RFC 7807)
- Client can parse `type` to determine error category
- Clear HTTP status codes (400 = validation, 409 = conflict, 429 = rate limited)
- Includes request context (instance) for logging/debugging

**API Versioning: None (MVP)**
- Not needed for MVP (no third-party integrations yet)
- Will add URL versioning (`/api/v2/...`) when needed post-launch
- Decision: Simple to add later without breaking current clients

**Deployment Topology:**
```
Azure Container Apps Environment
├── VolunteerService Container (public route: /api/volunteer/*)
├── AdminService Container (auth required: /api/admin/*)
├── Shared CosmosDB per org
├── Service Bus (queue for signup concurrency)
├── SignalR Service (real-time updates)
└── Azure WAF (rate limiting, DDoS protection)
```

---

### Real-Time Architecture

**Decision: Azure SignalR Service with Delta Updates and Persistent Connections**

**Real-Time Library: Azure SignalR Service**

- **Primary Choice:** Azure SignalR Service (managed, scales, cost-effective)
  - Evaluation required during implementation: Estimate cost for 50/min peak
  - Fallback to raw WebSocket if cost-prohibitive
  - Decision deferred to implementation: `Cost < $10/month?` → Use SignalR; else → Use WebSocket

**WebSocket Connection Strategy: Persistent Connections**

**Volunteer Board:**
- Browser maintains persistent WebSocket connection to VolunteerService
- Connection lifecycle: opened on board load, closed on page unload
- Typical duration: 30 seconds to 5 minutes per volunteer

**Admin Roster:**
- Admin dashboard maintains persistent WebSocket connection to AdminService
- Connection lifecycle: opened on admin login, closed on logout
- Typical duration: 30 minutes to several hours

**Update Granularity: Delta Updates (Changed Records Only)**

Rather than broadcast entire board state on each change, send only the changed volunteer:

```json
{
  "type": "volunteer-updated",
  "data": {
    "slotId": "slot-123",
    "volunteerId": "vol-456",
    "status": "signed-up",
    "volunteerName": "John S.",
    "timestamp": "2026-03-28T14:15:30Z"
  }
}
```

**Client Logic:** Merge delta into local state
- Volunteer board: Update only the changed slot's availability and volunteer name
- Admin roster: Update only the changed row

**Benefits of Delta Updates:**
- Lower bandwidth (500 bytes vs 10KB for full board state)
- Real-time feel (instant updates visible to connected clients)
- Efficient at scale (even 1000 concurrent clients manageable)

**Client Complexity:** Manageable
- Simple merge logic: `state[slotId].volunteers[index] = newData`
- No heavy state management needed (plain JavaScript or React useState)
- Fallback: If merge fails, full refresh on next poll/reconnect

**Message Flow:**

1. Volunteer submits signup
2. Signup validated and event created
3. Event log entry written
4. Volunteer collection updated
5. **SignalR broadcast:** Delta update to all connected clients with that slot visible
6. **Admin roster:** Delta update to all admin dashboards watching that volunteer

**Availability Recalculation:**
- Slot availability = Role capacity - current signup count
- Sent as part of delta update to volunteer board
- Admin sees real-time roster count immediately

---

### Infrastructure & Deployment

**Decision: Azure Container Apps with Terraform IaC**

**Hosting Strategy: Azure Container Apps (Managed Containers)**

- Rationale: Managed service (less ops overhead for solo implementer), native Docker support, scales automatically
- Alternative considered: App Service (too heavyweight for two small services)
- Alternative considered: Kubernetes (too much ops burden)

**Deployment Structure:**
```
Container Apps Environment
├── volunteer-service (image: volunteer-signup:latest)
├── admin-service (image: volunteer-signup-admin:latest)
└── Supporting Azure Services
    ├── CosmosDB (per org)
    ├── Service Bus (queues)
    ├── SignalR Service
    ├── Application Insights (monitoring)
    └── Key Vault (secrets)
```

**CI/CD Pipeline: GitHub Actions**
- Trigger on push to `main` branch
- Build both containers
- Push to Azure Container Registry
- Deploy to Container Apps
- Terraform applies infrastructure changes

**Environment Configuration:**
- `.env` files per environment (dev, staging, prod)
- Secrets in Azure Key Vault (never in code)
- Connection strings for CosmosDB per org (deployed via Terraform)

**Monitoring & Logging:**
- Application Insights integration (distributed tracing)
- Serilog structured logging (from Clean Architecture template)
- Log Analytics workspace for debugging

**Scaling Strategy:**
- Auto-scale based on CPU/memory (default 1-10 replicas)
- Database autoscale RU/s (400-4000 per org)
- Service Bus autoscale (standard pricing, unlimited messages)

---

## Implementation Sequence & Dependencies

**Phase 1: Foundation (Week 1)**
1. Clone Clean Architecture template
2. Set up two projects (VolunteerService, AdminService)
3. Configure CosmosDB client (replace EF Core)
4. Implement Core domain models and events

**Phase 2: Event Sourcing (Week 2)**
5. Implement immutable event log pattern
6. Create event store and event models
7. Build event projection logic

**Phase 3: Multi-Tenant & Auth (Week 2-3)**
8. Implement per-org CosmosDB isolation
9. Implement admin authentication (bcrypt + token invite)
10. Implement authorization middleware

**Phase 4: Concurrency & Queue (Week 3)**
11. Integrate Azure Service Bus
12. Implement queue-based signup validation
13. Test race condition handling

**Phase 5: Real-Time (Week 4)**
14. Integrate Azure SignalR (or raw WebSocket, cost-dependent)
15. Implement delta update logic
16. Test with concurrent clients

**Phase 6: Communications (Week 4-5)**
17. Integrate email/SMS service (SendGrid or Azure Comm Services)
18. Implement calendar invite generation (.ics files)

**Phase 7: Infrastructure & Deploy (Week 5)**
19. Write Terraform configuration (Container Apps, CosmosDB, Service Bus, SignalR)
20. Set up GitHub Actions CI/CD
21. Deploy to staging
22. Load test (50/min concurrent signups)
23. Deploy to production

---
