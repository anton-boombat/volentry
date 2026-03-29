---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-02-advanced-elicitation", "step-02b-vision", "step-02c-executive-summary", "step-03-success", "step-04-journeys", "step-05-domain", "step-06-innovation", "step-07-project-type", "step-08-scoping"]
inputDocuments: []
workflowType: 'prd'
projectName: 'Volunteer Signup Platform'
date: '2026-03-28'
user_name: 'Anton'
classification:
  projectType: 'SaaS Web Application (Multi-tenant)'
  domain: 'Community/Sports Volunteer Management'
  complexity: 'Medium'
  projectContext: 'Greenfield'
stakeholderInsights:
  admins: 'Low-touch, minimal overhead required'
  volunteers: 'Frictionless signup + self-service cancellation with guardrails'
  clubLeadership: 'Digital paper sheet replacement, simple and effective'
---

# Product Requirements Document - Volunteer Signup Platform

**Author:** Anton
**Date:** 2026-03-28

## Classification

| Aspect | Value |
|--------|-------|
| **Project Type** | SaaS Web Application (Multi-tenant) |
| **Domain** | Community/Sports Volunteer Management |
| **Complexity** | Medium |
| **Context** | Greenfield |
| **Roadmap** | MVP → v1.1 (notifications) → v2 (reminders + volunteer dashboard) → v3 (analytics/history) |

## Refined Requirements from Stakeholder Analysis

### Volunteer Experience (Public, No Login)
- See all slots with volunteer names (First Name + Last Initial, e.g., "John S.")
- Email/phone hidden on public board
- Click slot → fill form (name, phone, email, optional team) → confirmation
- Self-service cancellation with confirmation
- Cancellation blocked if < 2 days until event (message: "Contact admin")
- Public board allows filtering by name to find own signups

### Admin Experience (OAuth Login)
- Create/manage events and timeslots
- Define and edit role names (MVP requirement)
- Set roles per slot (e.g., 2 Canteen, 1 BBQ)
- View full roster with volunteer contact info
- Manually add volunteers
- Manually reassign/remove volunteers
- No approval workflows needed

### Out of MVP Scope (Future Phases)
- Email/SMS notifications (v1.1)
- Notification on reassignment (v2)
- Volunteer dashboard/login (v2)
- Parent consent tracking (v3)
- Background check integration (v3)
- Analytics/reporting (v3)

## Executive Summary

**Volunteer Signup Platform** is a multi-tenant SaaS web application designed to democratize volunteer recruitment for community organizations through radical simplicity. The platform addresses a critical gap: volunteers want to help, but lack visibility into what's needed, and organizations struggle to broadcast opportunities beyond their usual circle of committed volunteers.

By removing friction—no login, no forms, just "click slot → fill minimal info → done"—the platform transforms volunteer recruitment from pull (hard to find) to push (easy to discover). Organizations access their platform via dedicated URLs (e.g., `myvolunteerapp.com/clubname`); volunteers see what's needed and commit instantly. Each organization operates in complete isolation with no cross-org visibility, eliminating coordination complexity. The primary use case is sports clubs managing timeslot-based volunteer duties (canteen, BBQ, fields), but the model extends to parkrun, school canteens, community events, and any volunteer-dependent organization.

**Target Users:**
- **Volunteers:** People who want to help but need visibility into opportunities and minimal friction to commit
- **Club Admins/Leaders:** Club volunteers managing volunteer coordination with minimal overhead

**Funding & Sustainability:** Founder-funded MVP and initial club onboarding. Long-term sustainability model (freemium, sponsorships, etc.) to be determined based on early traction.

**Success Metrics (Year 1):** 5+ active organizations using the platform; clear demand signals for expansion

### What Makes This Special

**Radical Simplicity Over Feature Richness:** The product intentionally rejects "volunteer management software" complexity. No dashboards, no approvals, no training. Volunteers don't need accounts or passwords. The entire signup flow is 3 clicks. This simplicity is not a limitation—it's the core competitive advantage.

**Designed for Volunteer Orgs, Not Corporations:** Traditional volunteer management tools assume organizations have budget and staff for complex workflows. This platform is built for the opposite: lean, bootstrap-friendly organizations with part-time coordinators. Free or freemium model is essential to market fit.

**Complete Org Isolation:** Multi-tenant architecture isolates each organization completely. Organizations don't see each other, reducing coordination complexity and competition concerns. Each org has its own branded space.

**Core Insight:** Visibility + friction reduction unlocks a massive untapped pool of volunteers who already want to help but didn't know how. Most people don't sign up because they don't know opportunities exist or the signup process is annoying, not because they're unwilling.

### Project Classification

| Aspect | Value |
|--------|-------|
| **Project Type** | SaaS Web Application (Multi-tenant) |
| **Domain** | Community/Sports Volunteer Management |
| **Complexity** | Medium (multi-tenant architecture, event sourcing, well-scoped features) |
| **Project Context** | Greenfield (new product) |
| **Roadmap** | MVP (core signup) → v1.1 (notifications) → v2 (reminders + volunteer dashboard) → v3 (analytics/history) |

## Success Criteria

### User Success: Clarity

**Success Moment:** Volunteers land on the platform and instantly understand:
- What volunteer roles are needed
- When they're needed (timeslot dates/times)
- How many spots are available
- What commitment they're making

**Measurable Outcome:** Volunteers complete signup in <2 minutes with no support needed. The interface is so clear that first-time users don't need instructions.

### Business Success: Volunteer Engagement

**Success Metric:** Volunteers who sign up actually show up to their committed slots.

**Measurable Outcomes:**
- Target: 80%+ show-up rate (volunteers appearing for slots they signed up for) in Year 1
- Secondary: Club leaders report "we have better coverage now than with paper sheets"
- Expansion signal: Clubs actively invite other clubs to use the platform (organic referral)

**Rationale:** A platform where volunteers commit but don't show up is worse than paper. Engagement means reliability.

### Technical Success: Signup & Reliability

**Essential Requirements:**
- Volunteers can sign up reliably (form submission never fails)
- No data loss (event log is immutable source of truth)
- Multi-tenant isolation (complete data separation between organizations)
- Cancellation logic works correctly (2-day window enforced)

## Product Scope

### MVP - Minimum Viable Product

**What's Essential for Proving the Concept:**

**Volunteer Experience:**
- View timeslots and volunteer names (first name + last initial)
- Sign up in <3 clicks (form: name, phone, email, optional team)
- Receive email confirmation
- Self-service cancellation with 2-day guardrail
- Filter public board by name to find own signups

**Admin Experience:**
- Create events and timeslots via dashboard
- Define and edit role names (flexible: 1-5 roles per slot)
- Set role capacity (e.g., 2 Canteen, 1 BBQ)
- View full roster with contact info
- Manually add/reassign/remove volunteers
- OAuth login (non-negotiable for admin security)

**Architecture:**
- Multi-tenant with complete org isolation
- Event-sourced writes for audit trail and no data loss
- CosmosDB for persistence
- Azure Container Apps deployment
- Terraform IaC

**Not Included in MVP:**
- Email/SMS confirmations (v1.1)
- Reminder notifications (v1.1)
- Volunteer login/personal dashboard (v2)
- No-show tracking (v2)
- Analytics/reporting (v3)
- Parent consent tracking (v3)

### Growth Features (Post-MVP)

- **v1.1:** Email and SMS confirmations, reminder notifications to volunteers before their slot
- **v2:** Volunteer dashboard/login, view personal signups, no-show tracking
- **v3:** Analytics, reporting, organization management tools

### Vision (Long-term)

- 100+ organizations using the platform
- Organization management dashboards for large volunteer groups
- Community network effects (volunteers see opportunities across organizations)
- Integration ecosystem (calendar systems, communication platforms)

## User Journeys

### Journey 1: Volunteer - Happy Path (Discovering & Signing Up)

**User:** Sarah, a local parent who loves sports but hasn't volunteered yet

**Opening Scene:** Sarah sees a Facebook post from the junior football club: "We need volunteers for this Saturday! Link below." She clicks curious but skeptical. The site loads in seconds showing *exactly* what's needed: "10am-12pm: Canteen (2 spots), BBQ (1 spot). Only 1 spot left for Canteen!"

**Rising Action:** Sarah thinks "I can do canteen duty for 2 hours." She clicks the slot. A simple form appears: name, phone, email, team name (optional). She fills it in 90 seconds. Hits confirm.

**Climax:** She gets an instant email: "You're signed up! See you Saturday 10am." Calendar invite is attached. She marks it on her calendar.

**Resolution:** Saturday morning, Sarah knows exactly where to be and what to do. She shows up. The club has the coverage they needed. Sarah feels *included* and valuable.

**Requirements Revealed:**
- Real-time slot visibility with availability counts
- Dead-simple form (name, phone, email, optional team)
- Instant email confirmation + calendar invite
- No account needed

### Journey 2: Volunteer - Edge Case (Realizes They Can't Make It)

**User:** Marcus, who signed up 3 days ago but just realized a family commitment came up

**Opening Scene:** Marcus lands on the platform and filters by his name. Finds "Saturday 10am-12pm Canteen" showing as his signup.

**Rising Action:** Marcus clicks "Cancel." A confirmation dialog appears: "Are you sure? Please confirm to remove your name."

**Climax:** Marcus confirms and cancels. The slot updates to show "1/2 Canteen available" again.

**Resolution:** Marcus feels relief that he can back out without awkwardness. Club admin now knows to find another volunteer.

**Requirements Revealed:**
- Public board with name filtering (so volunteers can find their own signups)
- Self-service cancellation with confirmation
- Instant updates to availability

### Journey 3: Volunteer - Blocked Path (Too Late to Cancel)

**User:** James, who signed up a week ago for Saturday but forgot to cancel until Friday night

**Opening Scene:** James visits the platform Friday at 10pm and tries to cancel his Saturday 10am shift. A message appears: "You can't cancel within 2 days of the event. Please contact the club admin."

**Rising Action:** James emails the club admin. Admin manually removes him Friday night.

**Resolution:** James isn't locked in against his will. Club has time to find a replacement.

**Requirements Revealed:**
- 2-day cancellation window enforced
- Clear error message directing to contact admin
- Admin ability to manually remove volunteers

### Journey 4: Club Admin - Creating an Event & Managing Slots

**User:** John, club coordinator, setting up volunteer slots for next month's events

**Opening Scene:** John logs in with his club admin username and password. Dashboard loads showing a calendar view. He clicks "Create Event" for "BBQ Saturday March 30."

**Rising Action:** John sets the date and creates 3 timeslots (8am, 10am, 12pm). For each slot, he defines roles:
- Canteen: 2 needed
- BBQ: 1 needed
- (Future: he could add Grounds Marshall, but that's v3)

He saves the event. The public signup link is generated: `myvolunteerapp.com/myclub/march30`

**Climax:** John shares the link on Facebook and WhatsApp. Within hours, volunteers are signing up. John sees real-time updates: "Canteen: 2/2 FULL, BBQ: 0/1 available."

**Resolution:** John has visibility into coverage without managing a spreadsheet. He can see exactly who signed up and their contact info.

**Requirements Revealed:**
- Admin authentication (username + password, securely stored)
- Event creation with date/time
- Define roles and capacity per timeslot
- Public signup URL generation
- Real-time roster view with contact info

### Journey 5: Club Admin - Manual Volunteer Management

**User:** John again, but now he needs to adjust coverage

**Opening Scene:** John realizes his mate Dave is available and wants to help. John logs in and adds Dave manually: name, phone, email. Assigns him to "10am-12pm Canteen."

**Rising Action:** John also needs to reassign Sarah from Canteen to BBQ because she asked to switch. John clicks "Reassign" and selects her new role.

**Climax:** Dave is now on the roster. Sarah's slot is changed. Coverage is adjusted.

**Resolution:** John has full control. No approval workflows, no friction.

**Requirements Revealed:**
- Admin ability to manually add volunteers
- Admin ability to reassign volunteers between roles/slots
- Admin ability to remove volunteers
- No approval workflows needed

### Journey Requirements Summary

These 5 journeys reveal the core feature set:

**Volunteer Features:**
- Timeslot viewing with real-time availability
- Simple form signup (name, phone, email, team)
- Email + calendar confirmation
- Public board with name filtering
- Self-service cancellation (with 2-day guard)
- Clear error messaging

**Admin Features:**
- Simple username + password authentication (securely hashed)
- Event creation with date/time
- Flexible role definition (1-5 roles per slot, custom names)
- Capacity management
- Real-time roster viewing with contact info
- Manual add/assign/remove volunteers
- Public signup URL generation per event

## Domain-Specific Requirements

### Data Privacy & Compliance

**Requirements:**
- All volunteer data (name, phone, email, team) stored securely with encryption at rest
- Passwords hashed with bcrypt (no plaintext storage)
- Volunteers can request data deletion from their signup
- Clear privacy policy documenting what data is collected, how it's used, and retention periods
- Compliance with applicable data protection standards (GDPR if EU volunteers, local privacy laws)
- Admin contact info and volunteer contact info never shared publicly (only first name + last initial visible on public board)

**MVP Approach:**
- Build data deletion capability (user-initiated request to admin)
- Document retention policy (recommend: delete signups 12 months after event)
- Privacy policy provided at signup

### Accessibility

**Requirements:**
- Platform should be usable by volunteers with disabilities (keyboard navigation, screen reader support, color contrast)
- Follow WCAG 2.1 Level AA standards where feasible without blocking MVP launch
- Test with assistive technologies post-MVP and iterate

**MVP Approach:**
- Semantic HTML structure
- Proper form labels and ARIA attributes
- Sufficient color contrast on public board
- Keyboard-navigable signup flow
- Don't let perfectionism block launch

### Reliability & Operations

**Requirements:**
- Immutable event log ensures no data loss (core technical requirement)
- Multi-tenant isolation prevents one organization's outage from affecting others
- Graceful degradation if services are temporarily unavailable

**MVP Approach:**
- Event-sourced architecture (already planned)
- No backup/recovery procedures required for MVP
- If platform goes down, signups can be manually managed by admins (paper sheet fallback)

## SaaS Web Application Specific Requirements

### Multi-Tenancy Architecture

**Organization Isolation:**
- Separate Azure Cosmos DB database per organization (complete data isolation)
- Organizations cannot access each other's data under any circumstance
- Each org has a unique URL: `myvolunteerapp.com/{orgname}`

**Branding & Customization (MVP):**
- Organization logo upload and display in signup flow and admin dashboard
- Post-MVP: Custom domain support, color themes, email templates

### Authentication & Authorization

**Admin Account Management:**
- First admin created when organization is onboarded (founder/club coordinator)
- First admin (Super-Admin) can invite additional admins via email
- Two admin roles:
  - **Super-Admin:** Can create/invite other admins, manage org settings
  - **Regular Admin:** Can manage events, timeslots, volunteers (cannot create admins)
- Simple username + password authentication (bcrypt hashed)
- No multi-factor authentication required for MVP

**Public Signup (No Auth):**
- Volunteer signup requires no account, no authentication
- **DDoS Protection:** Azure DDoS Protection Standard (or equivalent) protects public signup endpoints
- IP-based rate limiting on public API: 10 requests per minute per IP
- Prevents malicious signup spam and resource exhaustion

### Internal APIs

**Volunteer Service (Public):**
- GET `/api/org/{orgname}/events` — List upcoming events
- GET `/api/org/{orgname}/events/{eventid}/slots` — List timeslots with availability
- POST `/api/org/{orgname}/slots/{slotid}/signup` — Submit volunteer signup
- POST `/api/org/{orgname}/slots/{slotid}/cancel` — Cancel volunteer signup

**Admin Service (Authenticated):**
- CRUD operations for events, timeslots, roles, volunteers
- Real-time read access to all volunteer signup data
- Admin API calls return same data as Volunteer Service plus contact info

### Data Integrity & Concurrency

**Concurrent Signup Handling:**
- Queue-based validation for simultaneous signup attempts to the same slot
- If multiple volunteers click the same slot simultaneously:
  - First N signups succeed (where N = slot capacity)
  - Additional attempts receive error with updated availability
- Event-sourced writes ensure no data loss or race conditions

### Scalability & Performance

**Load Expectations:**
- Peak: ~50 concurrent signups per minute (generous estimate)
- Typical: ~10 signups per hour
- No aggressive caching or optimization required for MVP

**Real-Time Updates:**
- Public signup board updates in real-time as volunteers sign up/cancel
- Admin dashboard shows real-time roster updates
- Implementation: WebSocket or polling (Azure App Service native support for both)

### Communications & Integrations

**Email Confirmations (v1.1):**
- Evaluate Azure Communication Services (native) vs SendGrid (cost comparison)
- Send confirmation email upon successful signup with volunteer details
- Send calendar invite (.ics file) with event date/time
- Automatic generation of calendar invites (no manual intervention)

**Calendar Integration:**
- Generate RFC 5545 (.ics) format calendar file
- Attach to confirmation email
- Support for Outlook, Google Calendar, Apple Calendar

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Problem-solving MVP that solves the core problem (volunteer discovery + frictionless signup) with complete volunteer experience including confirmations and calendar integration.

**MVP Timeline:** Single development phase combining core features + v1.1 communications.

### MVP Feature Set (Phase 1 - Pre-Launch)

**Core Volunteer Journeys:**
- Volunteer discovers event via shared link
- Volunteer signs up in <3 clicks
- Volunteer receives email + SMS confirmation with calendar invite
- Volunteer can view their signups on public board and self-cancel (with guardrails)

**Core Admin Journeys:**
- Admin creates events/timeslots with flexible roles
- Admin manages volunteers (add/assign/remove)
- Admin views real-time roster with contact info
- Admin invites additional admins

**Must-Have Capabilities:**
- Multi-tenant organization isolation (separate database per org)
- Simple username + password admin authentication
- Event-sourced audit log (no data loss)
- Real-time volunteer board updates
- Email + SMS confirmations (Azure Communication Services or SendGrid)
- Automatic calendar invite generation (.ics files)
- DDoS protection on public API
- Queue-based concurrent signup validation
- 2-day cancellation window enforcement
- WCAG accessibility (Level AA where feasible)
- Data privacy compliance with encryption

### Post-MVP Features

**Phase 2 (Growth):**
- Volunteer dashboard/login (view personal signup history)
- Reminder notifications before event date
- No-show tracking and analytics
- Custom domain support per organization
- Email template customization

**Phase 3 (Expansion):**
- Full analytics and reporting dashboards
- Organization management tools (for large volunteer groups)
- Integration ecosystem (calendar platforms, communication tools)
- Multiple language support

### Risk Mitigation Strategy

**Technical Risk (Event Sourcing + Concurrency):**
- Comprehensive unit tests for signup queue and event log
- Load testing before launch to validate concurrent signup handling

**Market Risk (Club Adoption):**
- Launch with your club first, validate the product
- Iterate based on real usage before onboarding other clubs

**Resource Risk (Solo Development):**
- Keep feature set lean (this scope is manageable for one developer)
- Use Azure-native services to reduce infrastructure overhead
- Deploy to Container Apps (managed service, minimal ops burden)

