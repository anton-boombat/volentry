---
stepsCompleted: ["step-01-validate-prerequisites", "step-02-design-epics"]
inputDocuments: ["/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/prd.md", "/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/architecture.md", "/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/ux-design-specification.md"]
projectName: "Volunteer Signup Platform"
requirementsExtractedDate: "2026-03-29"
epicApprovedDate: "2026-03-29"
epicApprovedBy: "Anton"
requirementStats:
  functionalRequirements: 40
  nonFunctionalRequirements: 46
  architectureRequirements: 56
  uxDesignRequirements: 123
  total: 265
totalEpicsApproved: 9
---

# Volunteer Signup Platform - Epic Breakdown

## Requirements Inventory

### Functional Requirements

**Volunteer Features:**
- FR1: Volunteers can view all timeslots with role names, volunteer names (first name + last initial), and real-time capacity counts
- FR2: Volunteers can sign up for a timeslot by filling a form with name, phone, email, and optional team (3-click process)
- FR3: Volunteers receive instant email confirmation with calendar invite (.ics file) upon signup
- FR4: Volunteers can self-service cancel their signup with confirmation dialog
- FR5: Volunteers can search/filter public board by name to find their own signups
- FR6: Cancellation is blocked if < 2 days until event with clear error message directing to admin contact
- FR7: Public volunteer board displays real-time updates as volunteers sign up/cancel
- FR8: Volunteers can view all their signups and check which slots they've committed to

**Admin Features:**
- FR9: Admins can create events with date and time
- FR10: Admins can create timeslots within events and define custom role names (1-5 roles per slot)
- FR11: Admins can set capacity per role (e.g., "2 Canteen, 1 BBQ")
- FR12: Admins can view full roster with volunteer contact information (name, phone, email)
- FR13: Admins can manually add volunteers to any slot/role
- FR14: Admins can reassign volunteers between roles and slots
- FR15: Admins can remove volunteers from signups
- FR16: Admins can authenticate via username and password (bcrypt hashed)
- FR17: Super-Admins can invite additional admins via email with token-based invite link
- FR18: Super-Admins can manage organization settings
- FR19: First admin created during organization onboarding is automatically assigned Super-Admin role
- FR20: Admin dashboard displays real-time roster updates as volunteers sign up/cancel
- FR37: Super-Admin can downgrade themselves to Regular Admin role ONLY if at least one other Super-Admin exists
- FR38: Super-Admin can downgrade themselves to Regular Admin role ONLY if at least one other Super-Admin exists
- FR39: Super-Admin can deactivate another admin's account (account becomes inactive, login blocked)
- FR40: Super-Admin cannot deactivate their own account (must downgrade first, then have another super-admin deactivate)

**Data & Privacy:**
- FR21: All volunteer data (name, phone, email, team) is stored with encryption at rest
- FR22: Passwords are hashed using bcrypt (no plaintext storage)
- FR23: Volunteers can request data deletion from their signup
- FR24: Privacy policy documents what data is collected, how it's used, and retention periods
- FR25: Only first name + last initial visible on public board (full contact info hidden from public)
- FR26: Admin contact info is never shared publicly

**Multi-Tenancy:**
- FR27: Each organization has complete isolation with separate database per organization
- FR28: Organizations cannot access each other's data under any circumstance
- FR29: Each organization has a unique URL: myvolunteerapp.com/{orgname}
- FR30: Organization logo can be uploaded and displayed in signup flow and admin dashboard

**Communications:**
- FR31: Email confirmations are sent upon successful signup with volunteer details
- FR32: Calendar invite (.ics file) is attached to confirmation email in RFC 5545 format
- FR33: Calendar invites support Outlook, Google Calendar, and Apple Calendar integration
- FR34: SMS confirmations are sent upon signup (v1.1+)
- FR35: Reminder notifications sent before event date (v2)
- FR36: Notification sent to admin on volunteer reassignment (v2)

### Non-Functional Requirements

**Performance:**
- NFR1: Public signup board loads in under 2 seconds
- NFR2: Signup form appears instantly after clicking a slot (no loading delay)
- NFR3: Email confirmation arrives within 10 seconds of signup
- NFR4: Admin dashboard loads quickly with instant coverage status visibility
- NFR5: System handles ~50 concurrent signups per minute (peak load)
- NFR6: Typical load is ~10 signups per hour
- NFR7: Real-time updates appear instantly without page refresh required
- NFR8: No aggressive caching or optimization required for MVP (light load profile)

**Security & DDoS Protection:**
- NFR9: Azure DDoS Protection Standard protects public signup endpoints
- NFR10: IP-based rate limiting: 10 requests per minute per IP on public API
- NFR11: DDoS protection prevents malicious signup spam and resource exhaustion
- NFR12: Input validation with FluentValidation on all public endpoints
- NFR13: CSRF token on form submission (standard ASP.NET Core)
- NFR14: All API responses follow RFC 7807 (Problem Details) format for errors
- NFR15: SSL/TLS encryption for all data in transit

**Data Integrity & Concurrency:**
- NFR16: Concurrent signups to same slot are handled safely via queue-based validation
- NFR17: First N signups (where N = slot capacity) succeed; additional attempts receive error
- NFR18: Event-sourced immutable event log prevents data loss
- NFR19: No race conditions in simultaneous signup attempts
- NFR20: Event log is append-only (no deletes, no updates)
- NFR21: Audit trail is immutable and tamper-proof
- NFR22: 2-day cancellation window enforcement is guaranteed by event log
- NFR23: Idempotent signup requests handled gracefully (no duplicate signups on retry)

**Reliability & Availability:**
- NFR24: Multi-tenant isolation prevents one organization's outage from affecting others
- NFR25: Graceful degradation acceptable if services temporarily unavailable
- NFR26: No backup/recovery procedures required for MVP (manual fallback acceptable)
- NFR27: Complete organization data isolation by design, not just application logic

**Accessibility:**
- NFR28: Platform complies with WCAG 2.1 Level AA standards where feasible
- NFR29: Semantic HTML structure for screen reader support
- NFR30: Proper form labels and ARIA attributes throughout
- NFR31: Sufficient color contrast on public board (accessible to color-blind users)
- NFR32: Keyboard-navigable signup flow (no mouse required)
- NFR33: Mobile and desktop accessibility tested with assistive technologies
- NFR34: Large tap targets (44px+ minimum) for mobile usability

**Scalability:**
- NFR35: CosmosDB autoscale: 400-4000 RU/s per organization (adjustable)
- NFR36: Azure Container Apps auto-scales based on CPU/memory (default 1-10 replicas)
- NFR37: Service Bus autoscale with standard pricing (unlimited messages)
- NFR38: Event log scalability: 10-year lifespan with ~182,500 events per organization
- NFR39: Event log storage ~91 MB per organization (well within practical limits)
- NFR40: Supports 100+ organizations with independent scaling

**Monitoring & Operations:**
- NFR41: Application Insights integration for distributed tracing
- NFR42: Serilog structured logging throughout application
- NFR43: Log Analytics workspace for debugging and auditing
- NFR44: No significant operational overhead (managed services on Azure)

### Architecture Requirements

**Architecture Pattern:**
- AR1: Event-sourced architecture with immutable event log as source of truth
- AR2: Clean Architecture pattern (4-layer: Core, Application, Infrastructure, WebAPI)
- AR3: CQRS pattern with MediatR (Commands create events; Queries materialize views)
- AR4: Microservices architecture with two independent services: VolunteerService and AdminService
- AR5: Separation of concerns: Volunteer Service (public) and Admin Service (authenticated)

**Database & Data Storage:**
- AR6: Separate Azure CosmosDB database per organization (complete isolation)
- AR7: CosmosDB collections per organization: organizations, events, event-log, volunteers
- AR8: Partition key strategy: /organizationId at container level
- AR9: Event log collection is immutable, append-only (enforced at application layer)
- AR10: Materialized views strategy: volunteers collection updated from event log projections
- AR11: CosmosDB consistency level: Session (strong for admin, eventual for reads)
- AR12: Optional TTL on event-log for GDPR compliance (configurable per org)

**Authentication & Authorization:**
- AR13: Admin authentication via username + password with bcrypt hashing
- AR14: Token-based invite flow for admin onboarding (24-hour expiration, one-time use)
- AR15: Two admin roles: Super-Admin (manage all) and Regular Admin (manage events only)
- AR16: Authorization middleware enforces role-based access control on protected endpoints
- AR17: Public signup requires no authentication or account creation
- AR18: Session consistency for authenticated operations
- AR19: BCrypt.Net-Next NuGet package used for password hashing

**API Architecture:**
- AR20: VolunteerService API routes: /api/volunteer/*
- AR21: AdminService API routes: /api/admin/*
- AR22: Public endpoints on VolunteerService protected by rate limiting and DDoS protection
- AR23: All error responses follow RFC 7807 (Problem Details) standard
- AR24: Both services are separate ASP.NET Core Web API projects
- AR25: Shared infrastructure: Core library, Infrastructure library, Shared.Tests library
- AR26: No API versioning for MVP (add when third-party integrations needed)

**Real-Time Architecture:**
- AR27: Azure SignalR Service or raw WebSocket for real-time updates (cost evaluation deferred)
- AR28: Persistent WebSocket connections for both volunteer board and admin roster
- AR29: Delta updates (changed records only) rather than full board state broadcast
- AR30: WebSocket connection lifecycle: opened on board load, closed on page unload
- AR31: Real-time indicators show presence of other admins and live signup updates
- AR32: Smooth animations on real-time updates without full page refresh

**Concurrency & Queue Handling:**
- AR33: Azure Service Bus queue for concurrent signup validation
- AR34: Queue ensures first signup wins; second signup gets "slot full" message
- AR35: Ordering guarantee: Queue provides serialization point for conflicting signups
- AR36: Idempotent request handling (no duplicate signups on network retry)
- AR37: No pessimistic locking; queue-based approach instead

**Deployment & Infrastructure:**
- AR38: Azure Container Apps for hosting (managed service)
- AR39: Terraform IaC (not Bicep) for infrastructure provisioning
- AR40: GitHub Actions CI/CD pipeline for automated builds and deployment
- AR41: Separate Docker containers for VolunteerService and AdminService
- AR42: Azure Container Registry for Docker image storage
- AR43: Auto-scaling: CPU/memory triggers scale-up/down (1-10 replicas)
- AR44: Application Insights for monitoring and distributed tracing
- AR45: Azure Key Vault for secrets management (never in code)
- AR46: .env files per environment (dev, staging, prod)

**Communications Architecture:**
- AR47: Email confirmations via Azure Communication Services or SendGrid (cost evaluation deferred)
- AR48: RFC 5545 (.ics) calendar file generation for all confirmations
- AR49: SMS confirmations support (v1.1 onwards)
- AR50: Automatic calendar invite generation (no manual intervention)

**Technology Stack (Locked In):**
- AR51: .NET 8 backend with C#
- AR52: ASP.NET Core Web API framework
- AR53: Entity Framework Core repository pattern (customized for CosmosDB)
- AR54: FluentValidation for form and API validation
- AR55: xUnit + Moq + FluentAssertions for testing
- AR56: Serilog for structured logging

### UX Design Requirements

**Volunteer Experience - Core Flow:**
- UX-DR1: Volunteer discovers event via shared link (no login required)
- UX-DR2: Landing board loads in <2 seconds with clear event display
- UX-DR3: Slots displayed in card layout (one role per card) on mobile and desktop
- UX-DR4: Card shows role name, volunteer names (first name + last initial), and availability count
- UX-DR5: Visual slot display shows "[Name] | [Name] | [Open]" format for clarity
- UX-DR6: Availability is color-coded or visually distinct (Full vs. Open slots)
- UX-DR7: Clicking on a slot opens signup form instantly (no loading delay)
- UX-DR8: Signup form is mobile-optimized with 4 fields: Name, Phone, Email, Team (optional)
- UX-DR9: Form fields are large (44px+ tap targets per iOS guidelines)
- UX-DR10: Field labels are always visible (not floating labels)
- UX-DR11: Validation happens on blur (helpful, not punitive)
- UX-DR12: Error messages are constructive ("Name should be 2+ characters", not "Invalid")
- UX-DR13: 2-day cancellation rule checkbox shown prominently with high contrast
- UX-DR14: Signup form fits one viewport on mobile without scrolling
- UX-DR15: "Sign Me Up" button is full-width and large (high tap target)
- UX-DR16: Loading state shows spinner with "Signing you up..." message
- UX-DR17: Success state shows unambiguous confirmation: "You're signed up!"
- UX-DR18: Success screen shows: Name confirmed, role, date/time, calendar + email notifications
- UX-DR19: Failure state shows fair message: "4 others clicked too. Slot taken at 2:34pm"
- UX-DR20: Post-signup options: [ Back to board ] and [ See all my signups ]

**Volunteer Experience - Cancellation & Management:**
- UX-DR21: Volunteers can access "My Signups" link from public board to see all commitments
- UX-DR22: "My Signups" shows date, time, role, and clear Cancel button per signup
- UX-DR23: Cancel button shows confirmation dialog: "Are you sure?"
- UX-DR24: Cancellation >2 days away succeeds with message: "Cancelled. Admin notified."
- UX-DR25: Cancellation <2 days away blocked with message: "You committed through [date]. Contact admin if something changed."
- UX-DR26: Blocked cancellation shows admin contact info (phone, email)
- UX-DR27: Successful cancellation updates roster in real-time (volunteer disappears instantly)
- UX-DR28: Public board allows name-based filtering to find own signups

**Real-Time Features:**
- UX-DR29: Real-time slot count updates as volunteers sign up/cancel (no page refresh needed)
- UX-DR30: Admin roster updates live as volunteers sign up (new names appear instantly)
- UX-DR31: Admin roster updates live as volunteers cancel (names disappear instantly)
- UX-DR32: Live indicators show "(Just now)" next to new signups for ~10 seconds
- UX-DR33: Admin sees presence indicator: "Sarah is viewing this event"
- UX-DR34: Real-time updates use delta strategy (only changed records sent, not full board)
- UX-DR35: Real-time updates feel smooth with animations (not jumpy)

**Email & Calendar Integration:**
- UX-DR36: Confirmation email arrives in <10 seconds
- UX-DR37: Email shows confirmation with volunteer name, role, date/time
- UX-DR38: Calendar invite (.ics file) is attachment to confirmation email
- UX-DR39: Calendar invite works with Outlook, Google Calendar, Apple Calendar (one-click "Add to Calendar")
- UX-DR40: Calendar invite shows event time, title, and volunteer role

**Admin Experience - Dashboard:**
- UX-DR41: Admin login page is simple (username + password only)
- UX-DR42: Admin dashboard loads quickly after authentication
- UX-DR43: Coverage status visible at a glance using color coding: red (short), yellow (at capacity), green (full)
- UX-DR44: Shortfalls shown clearly: "3 slots short (5/8 filled)"
- UX-DR45: Each event shows coverage status with expandable details
- UX-DR46: Quick action buttons sticky at top: [ + Add Volunteer ] [ 📊 Full Report ]
- UX-DR47: Live roster updates as volunteers sign up (no refresh required)
- UX-DR48: Roster organized by role with capacity indicators: "Grill (2/3)"
- UX-DR49: Roster shows volunteer names and phone numbers at a glance
- UX-DR50: Empty slots marked as "[1 spot open]" or "[URGENTLY NEEDED]" for short-staffed roles

**Admin Experience - Event Management:**
- UX-DR51: Admin can create new event with date/time easily
- UX-DR52: Event creation allows defining multiple timeslots
- UX-DR53: Admin can set custom role names (flexible, 1-5 roles per slot)
- UX-DR54: Admin can set capacity per role (number of needed volunteers)
- UX-DR55: Event form is clear with helpful field labels
- UX-DR56: Admin can update event and slot details after creation
- UX-DR57: Admin can view all upcoming events in a calendar or list view

**Admin Experience - Volunteer Management:**
- UX-DR58: Admin can add volunteer manually: click [ + Add Volunteer ]
- UX-DR59: Manual add form requires: Name, Phone, Email; selects Event and Role
- UX-DR60: Added volunteer appears on roster instantly
- UX-DR61: Admin can reassign volunteer to different role: click volunteer → [ Reassign ]
- UX-DR62: Reassign updates roster in real-time
- UX-DR63: Admin can remove volunteer: click volunteer → [ Remove ] (destructive red button)
- UX-DR64: Remove updates roster in real-time
- UX-DR65: Detailed volunteer view shows full contact info and options to edit/remove/reassign

**Admin Experience - Invite & Onboarding:**
- UX-DR66: Super-Admin can invite additional admins: click [ Invite Admin ]
- UX-DR67: Invite form requires email address of invitee
- UX-DR68: Invitee receives email with secure link and token
- UX-DR69: Invitee link expires after 24 hours or first use
- UX-DR70: Invitee can set own password via invite link (no email from admin)
- UX-DR71: Invited admin can immediately access admin dashboard after password setup

**Form Validation & Error Handling:**
- UX-DR72: Form field shows green checkmark (✓) on blur if valid (subtle, non-intrusive)
- UX-DR73: Error messages appear below field in red on blur if invalid
- UX-DR74: Phone validation accepts common formats and validates for reasonable length
- UX-DR75: Email validation checks format is valid
- UX-DR76: Name validation ensures 2+ characters
- UX-DR77: Validation messages are helpful and constructive (not jargon-heavy)
- UX-DR78: Form never loses data on validation failure (user's entries preserved)

**Button & Component Styling:**
- UX-DR79: Primary CTA buttons: full width, large (44px+), blue background, white text
- UX-DR80: Primary CTAs used for: "Sign Me Up", "Add Volunteer", "Create Event"
- UX-DR81: Secondary buttons: outlined style, normal size, used for "Cancel", "Go Back"
- UX-DR82: Destructive buttons: red background, used for removal actions only
- UX-DR83: Loading indicators show spinner with clear message ("Signing you up...")
- UX-DR84: Timeout handling: After 10s, show "Taking longer than expected. Please wait."

**Responsive Design:**
- UX-DR85: Mobile (<768px): Full-width cards stacked vertically, no horizontal scrolling
- UX-DR86: Mobile: Forms are full-screen modal or page transition
- UX-DR87: Mobile: Large tap targets minimum 44px per iOS guidelines
- UX-DR88: Mobile: Portrait orientation only (no landscape optimization needed)
- UX-DR89: Mobile: Email field shows email keyboard (type=email)
- UX-DR90: Mobile: Phone field shows numeric keyboard (type=tel)
- UX-DR91: Tablet (768px-1024px): Two-column card layout for volunteer board
- UX-DR92: Tablet: Admin dashboard side panel + main view layout
- UX-DR93: Desktop (>1024px): Multi-column grid or hybrid card + table layout
- UX-DR94: Desktop: Admin dashboard full sidebar + detailed main view

**Emotional & Psychological Design:**
- UX-DR95: Every screen should answer: "What should I do next?" without ambiguity
- UX-DR96: Confidence through clarity: Role names clear, slot counts obvious
- UX-DR97: Transparency: Show who's signed up; hide nothing from users
- UX-DR98: Accomplishment: Confirmation message unambiguous ("You're signed up!")
- UX-DR99: Belonging: Show other volunteers' names to build social proof ("John S., Sarah M., and 2 others")
- UX-DR100: Calm: Minimal form fields, fast load times, clear loading states
- UX-DR101: Control: Admin sees complete picture instantly; no hunting for data
- UX-DR102: Trust: Real-time updates show actual state (not fake or delayed)
- UX-DR103: Success moments are sacred: Calendar invite must be perfect, email instant
- UX-DR104: One-time user focus: Experience obvious without onboarding needed
- UX-DR105: Error messages are helpful, not punitive (no "Invalid X" messages)
- UX-DR106: Rules shown upfront (2-day window obvious at signup, not surprise)
- UX-DR107: No ads, upsells, or extra clicks at success moments

**Card Layout (Volunteer Signup Board):**
- UX-DR108: Card layout is primary display (not table layout)
- UX-DR109: One role per card for clear cognitive load
- UX-DR110: Card shows: Role name, volunteer names, open slots visual display
- UX-DR111: Card tap target is large (whole card clickable)
- UX-DR112: Real-time updates per card are smooth (no jumpy full-board refresh)
- UX-DR113: Mobile: Each card fits one screen without scrolling

**Performance & Load Time:**
- UX-DR114: Form validation on blur provides instant helpful feedback
- UX-DR115: Spinner appears only during actual wait (not on form blur)
- UX-DR116: Form submission (confirm button) shows loading immediately
- UX-DR117: No unnecessary delays or artificial loading screens
- UX-DR118: Page transitions are smooth (no jarring navigation)

**Organization Branding:**
- UX-DR119: Organization logo displayed on signup flow
- UX-DR120: Organization logo displayed on admin dashboard
- UX-DR121: Organization name shown in page title and header
- UX-DR122: Future: Custom domain support per organization (post-MVP)
- UX-DR123: Future: Color theme customization per organization (post-MVP)

---

## Epic List

### Epic 0: Foundation (Platform Scaffolding)
**Goal:** Build the infrastructure skeleton — databases, event-sourcing, auth middleware, deployment pipeline. Platform is deployable but has no user-facing features.

**User Outcome:** Technical foundation ready to support all subsequent feature epics.

**FRs covered:** None directly (infrastructure prerequisite)
**ARs covered:** AR6-AR12 (CosmosDB setup per org), AR38-AR46 (Container Apps, Terraform, GitHub Actions, monitoring), AR1-AR3 (event-sourcing pattern, clean architecture, CQRS/MediatR)
**NFRs addressed:** NFR35-NFR43 (scalability, monitoring, operational readiness)

**Key Deliverables:**
- CosmosDB provisioned per organization (separate databases)
- Event log collection (immutable, append-only at application layer)
- Azure Container Apps deployment infrastructure
- GitHub Actions CI/CD pipeline for automated builds
- Azure Key Vault for secrets management
- Terraform IaC for repeatable infrastructure
- DDoS Protection + IP-based rate limiting configured
- Structured logging (Serilog) + Application Insights integration
- Two projects created: VolunteerService (public) and AdminService (authenticated)

**Technical Notes:** Event-sourcing foundation is critical here — event log writes, append-only enforcement, and materialized view projection patterns should be proven before feature epics begin.

---

### Epic 0b: Design Foundation (Component Library & Wireframes)
**Goal:** Create detailed wireframes for all user flows and establish reusable component library. Designers and developers have complete visual/technical spec before feature development begins.

**User Outcome:** Design system provides consistent, accessible experience across all epics.

**FRs covered:** None directly (UX prerequisite)
**UX-DRs covered:** UX-DR1-UX-DR120 (all interaction patterns, responsive design, emotional design, component styling)
**NFRs addressed:** NFR28-NFR34 (accessibility: WCAG 2.1 AA, keyboard navigation, color contrast, semantic HTML)

**Key Deliverables:**
- Detailed ASCII/visual wireframes for:
  - **Volunteer Board (Hierarchical):** Hero section (featured day, optional), Upcoming Week section (smart closest week logic), Beyond section (4+ weeks, behind fold)
  - Signup form (states: default, field focus, validation error, loading, success, failure, 2-day block)
  - "My Signups" view with filtering and cancel flow
  - Admin login page
  - Admin dashboard (coverage status, live roster, quick actions)
  - Event creation form (multi-step or single form)
  - Manual volunteer add/reassign/remove flows
  - Email confirmation template
- Design tokens (colors, spacing scales, typography, button styles)
- Reusable component specs:
  - Card (day/time overview, role display, slot counts, visual state)
  - Form (field labels, validation states, error messages)
  - Button (primary, secondary, destructive)
  - Modal/Dialog (confirmation, add volunteer, event details)
  - Loading indicator with message
  - Error state (fair failure message, admin contact info)
  - Badge/pill (role names, availability counts, "(Just now)" indicator, status badges)
  - Toast notification (success, error, info)
  - Hero section (featured event with urgent highlight)
- Accessibility checklist (color contrast, keyboard navigation, ARIA labels)
- Smart logic for "Upcoming Week" section:
  - Auto-detect closest week with events
  - Dynamic labeling (This Week, Next Week, Upcoming)
  - Skip weeks with no events
  - Auto-populate hero with urgent day if exists

**Design System Note:** Component library should be code-ready (CSS classes, spacing values, color hex codes) so developers can implement without guessing.

**Wireframes Approved:** Yes (refined for hierarchical day view, hero section, smart upcoming week logic)

#### Story 0b.1: Design Token System & Style Guide

**As a** designer/developer
**I want** a complete design token system (colors, spacing, typography, shadows) documented in code-ready format
**So that** all UI is consistent and developers can implement without guessing hex codes or sizes.

**Acceptance Criteria:**
- [ ] Design tokens documented in CSS custom properties (--color-primary, --spacing-md, etc.)
- [ ] Colors defined: Primary blue (#0066CC), Success green (#00AA55), Warning orange (#FF9900), Error red (#CC0000), Neutrals (full gray scale)
- [ ] Spacing scale documented: xs (4px), sm (8px), md (16px), lg (24px), xl (32px), 2xl (48px)
- [ ] Typography specs: Heading 1/2/3 (sizes, weights), Body text, Small text
- [ ] Shadow spec: Consistent subtle shadow (0 2px 4px rgba(0,0,0,0.1))
- [ ] Border radius: 8px standard for all rounded corners
- [ ] Button specs documented: Primary (full-width, 44px, blue bg), Secondary (outlined), Destructive (red bg)
- [ ] Tokens available in formats: CSS variables, SCSS variables, JavaScript object
- [ ] Style guide document includes: color palette with usage rules, typography hierarchy, spacing guidelines, button examples
- [ ] Guide is self-documenting; developers need no follow-up questions

**Design Notes:** Tokens should be minimal but complete. Prioritize: colors, spacing, button sizing. Don't over-document.

---

#### Story 0b.2: Volunteer Board Wireframes – Hero & Upcoming Week View

**As a** UX designer/developer
**I want** detailed wireframes for the volunteer board showing hero section, upcoming week, and beyond sections
**So that** the hierarchical day-based view is clear and implementable by engineers.

**Acceptance Criteria:**
- [ ] Wireframes show mobile (<768px) variant:
  - Header (org logo, title)
  - Hero Section (optional featured day with urgent highlight, or auto-populated with closest urgent day)
  - Upcoming Week Section (closest week with events, dynamic label: "This Week", "Next Week", "Upcoming")
  - Day cards showing: date, time range, role names with counts, "[View Details]" button
  - Beyond Section (collapsed, "Show More ↓" link, loads weeks 4+)
  - Footer ([See My Signups])
- [ ] Wireframes show desktop (>1024px) variant:
  - Same layout, 2-column grid for day cards where possible
  - More events visible before needing scroll
- [ ] Hero section logic documented:
  - Optional admin-set featured event
  - OR auto-populate with closest urgent/short-staffed day
- [ ] Upcoming Week smart logic documented:
  - Detects closest week with available events
  - Skips pause weeks (no events)
  - Adaptive labeling based on current week
- [ ] Responsive behavior clear (stacked mobile, grid desktop)
- [ ] Color coding shown:
  - 🟢 Green checkmark: full slots
  - 🟡 Yellow: at/near capacity
  - 🟠 Orange: urgently needs help
- [ ] Role availability counts visible (e.g., "BBQ 2/3", "Canteen 1/1 FULL")

**Design Notes:** This is the primary landing page volunteers see. Make it obvious and intuitive.

---

#### Story 0b.3: Event Details & Signup Form Wireframes

**As a** developer
**I want** wireframes for the event details modal and signup form showing all interaction states
**So that** the form flow is clear (default, field focus, validation success/error, loading, success, failure, 2-day block).

**Acceptance Criteria:**
- [ ] Event Details Modal wireframe shows:
  - Event date, time range
  - All roles with full volunteer names: "John S. | Sarah M. | [Open]"
  - Role selection buttons
- [ ] Signup Form Default state shows:
  - 4 form fields: Name, Phone, Email, Team (optional with "Which team?" label)
  - 2-day rule acknowledgment checkbox ("I understand I can't cancel within 2 days")
  - Large [SIGN ME UP] button (44px minimum)
- [ ] Form Field States documented:
  - **Focus:** Clear focus indicator (blue outline or highlight), label highlighted
  - **Valid:** Green checkmark on valid fields
  - **Error:** Red error message below field, helpful tone ("should be 10+ digits")
- [ ] Loading state: Spinner + "Signing you up..." message, button disabled
- [ ] Success state: Clear confirmation message, role/date/time displayed, calendar/email icons, next actions visible
- [ ] Failure state (Slot Filled): Fair message "4 others clicked too, but you were next in line", timestamp shown, retry option
- [ ] Failure state (2-Day Block): "You committed through [date]. Can't cancel within 2 days. Contact admin if something changed." + contact info
- [ ] Responsive design shown:
  - Mobile: Full-screen modal or page transition, form fits one viewport
  - Desktop: Centered modal, larger form fields
- [ ] Accessibility specs shown:
  - Large form fields (44px+ tap targets)
  - Labels always visible (not floating)
  - Error messages linked to form fields (aria-describedby)

**Design Notes:** Form is the moment of commitment. Make it feel safe, clear, and authoritative.

---

#### Story 0b.4: Admin Dashboard & Event Management Wireframes

**As a** developer
**I want** wireframes for admin dashboard (coverage view, roster) and event creation form
**So that** admin workflows are clear and implementable.

**Acceptance Criteria:**
- [ ] Admin Login Page wireframe shows:
  - Simple layout (logo, "Admin Portal" title)
  - Username field, Password field
  - [LOG IN] button, forgot password link
  - Mobile and desktop variants
- [ ] Admin Dashboard Header shows:
  - Welcome message ("Welcome, Sarah!")
  - Logout button, organization name
- [ ] Coverage Status View shows:
  - Color-coded events (🔴 short-staffed, 🟡 at-cap, 🟢 full)
  - Shortfall counts clearly visible ("3 slots short for BBQ")
  - Sticky action buttons at top ([+ Add Volunteer] [📊 Report])
- [ ] Live Roster organized by:
  - Role grouping (each role has a section)
  - Capacity indicators ("Grill 2/3", "Canteen [1 OPEN]", "[URGENTLY NEEDED]")
  - Volunteer names, phone numbers, email (admin-only view)
  - Quick actions per volunteer (Reassign, Remove)
  - Empty slot indicators with urgency
- [ ] Event Creation Form shows:
  - Multi-step or single form with clear sections
  - Event details: name, date, time range
  - Role definition section (add/remove roles dynamically)
  - Per-role capacity inputs
  - Organization logo display (preview)
  - [CREATE EVENT] button
- [ ] Responsive design shown:
  - Mobile: Stacked layout, modals for forms
  - Desktop: Dashboard with sidebar/main view, grid layout
- [ ] Real-time indicators shown:
  - Live updates (no refresh needed)
  - "(Just now)" badges on new signups
  - Presence indicator for other admins (if editing same event)

**Design Notes:** Admin needs visibility + quick actions. Don't hide information behind clicks.

---

#### Story 0b.5: Component Library Specification

**As a** developer
**I want** detailed specs for all reusable components (Card, Form Field, Button, Modal, Badge, etc.)
**So that** I can implement them consistently across all features.

**Acceptance Criteria:**
- [ ] Card Component spec includes:
  - States: default, hover, active, disabled, error
  - Usage: day overview, event detail, role display
  - Sizing: full-width mobile, fixed width desktop
  - Responsive behavior documented
  - CSS class names (.card, .card--active, etc.)
- [ ] Form Field Component spec includes:
  - States: default, focus, valid (✓), error, disabled
  - Label behavior: always visible (not floating)
  - Error display: message below field in red (aria-describedby linked)
  - Validation feedback: on blur, not on keystroke
  - Required vs. optional indicator
  - Field sizes: standard (44px), compact (32px)
- [ ] Button Component spec includes:
  - Primary: full-width, 44px, blue bg, white text, bold font
  - Secondary: outlined style, normal width
  - Destructive: red bg, for removal only
  - States: default, hover (slight shade), active (darker shade), disabled (grayed, cursor-not-allowed), loading (spinner inside)
  - Icon support (if used)
  - CSS class names (.btn, .btn--primary, .btn--secondary, .btn--destructive)
- [ ] Modal/Dialog Component spec includes:
  - Fullscreen on mobile, centered on desktop
  - Close button (X) and ESC key dismiss
  - Overlay opacity (semi-transparent dark background)
  - Animation (slide up mobile, fade desktop)
  - CSS classes (.modal, .modal__overlay, .modal__content)
- [ ] Badge/Pill Component spec includes:
  - Role names, status indicators
  - Color variants (info=blue, success=green, warning=orange, error=red)
  - Size options: small (12px), medium (14px)
  - Examples: "Canteen", "[FULL]", "(Just now)"
- [ ] Loading Spinner Component spec includes:
  - Animated spinner icon (SVG or CSS)
  - Loading message below spinner
  - Optional cancel button
  - Used in form submissions, data loading
- [ ] Error State Component spec includes:
  - Error icon or color indicator
  - Error message (constructive, helpful tone)
  - Recovery action (try again, contact admin, go back)
  - Examples documented
- [ ] Toast Notification Component spec includes:
  - Slide in from bottom on mobile
  - Position: bottom center on mobile, bottom-right on desktop
  - Auto-dismiss after 3-5 seconds
  - Icon + message
  - CSS classes (.toast, .toast--success, .toast--error, .toast--info)
- [ ] All components documented with:
  - CSS class names and structure
  - Spacing/sizing values (e.g., 44px button, 16px padding)
  - Responsive behavior (stack on mobile, grid on desktop)
  - Accessibility requirements (aria-labels, focus states, keyboard navigation)
  - Visual examples or ASCII mockups

**Design Notes:** Component library is the implementation guide. Be thorough but not verbose. Focus on what developers need to code.

---

#### Story 0b.6: Accessibility Compliance Checklist

**As a** developer
**I want** a comprehensive accessibility checklist ensuring WCAG 2.1 Level AA compliance
**So that** the platform is usable by people with disabilities.

**Acceptance Criteria:**
- [ ] HTML Structure checklist:
  - Semantic HTML tags used (h1, h2, h3, label, button, input, nav, main, etc.)
  - Proper heading hierarchy (no skipped levels)
  - Form labels associated with inputs (for/id attributes)
  - ARIA labels on icon-only buttons, aria-live regions for dynamic updates
- [ ] Color & Contrast checklist:
  - Text contrast ≥4.5:1 on body text (WCAG AA standard)
  - UI component contrast ≥3:1
  - Color not sole method for conveying info (use icons, text, patterns)
  - State changes (error, success) not color-only
- [ ] Keyboard Navigation checklist:
  - All interactive elements focusable via Tab key
  - Logical tab order (visual left-to-right, top-to-bottom)
  - Focus indicators visible (outline or highlight, not invisible)
  - ESC key closes modals
  - Enter/Space activates buttons
  - Arrow keys for lists (if applicable)
- [ ] Form Accessibility checklist:
  - Labels visible and linked to inputs (for/id, not aria-label)
  - Error messages linked to fields (aria-describedby)
  - Required fields marked (e.g., asterisk or "Required" text)
  - Helpful error messages (constructive tone: "Email should be user@example.com", not "Invalid")
  - Form hints/help text visible below label
  - Password fields support autofill (autocomplete attributes)
- [ ] Screen Reader Support checklist:
  - aria-labels for icon buttons ("Close", "Add Volunteer", etc.)
  - aria-live regions for dynamic updates (slot count changes, "(Just now)" badges)
  - Form field descriptions read aloud
  - Skip links present (if long content)
  - Images have descriptive alt text
  - Empty decorative images marked with alt=""
- [ ] Visual Design checklist:
  - Large tap targets (44px minimum per iOS HIG)
  - Sufficient spacing between interactive elements (8px+)
  - Clear focus indicators on all buttons/inputs (visible outline or highlight)
  - No time-limited interactions (auto-dismiss with user control)
  - Blinking/animation can be paused if >5 seconds
- [ ] Responsive Design checklist:
  - Works on mobile (375px), tablet (768px), desktop (1024px+)
  - No horizontal scroll on mobile
  - Readable at 200% zoom (reasonable, not all content)
  - Touch-friendly on mobile (44px buttons, proper spacing)
- [ ] Test cases documented:
  - Keyboard-only navigation: Tab through entire page, all buttons accessible
  - Screen reader test: NVDA or VoiceOver reads form labels and errors correctly
  - Color contrast check: WebAIM Contrast Checker passes all text/UI
  - Mobile responsiveness: Tested on iPhone SE, iPad Pro
  - Zoom test: 200% zoom readable without horizontal scroll

**Design Notes:** Accessibility is not a checkbox. Build it in from the start.

---

### Epic 1: Volunteer Discovery & Signup
**Goal:** Volunteers can discover available slots and sign up without friction (3-click experience).

**User Outcome:** Volunteer sees event → clicks slot → fills form → gets instant success confirmation.

**FRs covered:** FR1, FR2, FR3, FR7
**UX-DRs covered:** UX-DR1-UX-DR20 (landing board, card layout, signup form, confirmation states)
**NFRs addressed:** NFR1, NFR2, NFR7 (load <2s, form instant, real-time updates)

**Key Deliverables:**
- Volunteer board endpoint (`GET /api/volunteer/org/{orgname}/events`)
- Events list with slot availability
- Slot details endpoint (`GET /api/volunteer/org/{orgname}/events/{eventid}/slots`)
- Signup form UI (card layout, responsive design)
- Form submission endpoint (`POST /api/volunteer/org/{orgname}/slots/{slotid}/signup`)
- Validation: name (2+ chars), phone (format), email (format)
- Success confirmation screen with role/date/time
- Event-log write for signup creation
- Real-time slot count updates (via WebSocket from Epic 3)

**Acceptance Criteria (High-Level):**
- Volunteer board loads <2 seconds
- Card layout displays role, volunteer names (first + last initial), availability count
- Clicking slot opens form instantly (no loading)
- Form validation on blur provides helpful error messages
- Signup success screen unambiguous ("You're signed up!")
- Volunteer name appears on roster instantly after signup

**Design Reaffirmation:** Before stories, team reviews wireframes for volunteer board + signup form + success state

#### Story 1.0: Root Page Club Search & Discovery

**As a** volunteer
**I want** to search for my club or team name on the root page
**So that** I can find the right volunteer signup link even if I forgot the exact club URL or came to the domain directly.

**Acceptance Criteria:**
- [ ] Root page `volentry.com/` displays:
  - [ ] Centered search box with placeholder text: "Search your club or team name"
  - [ ] Optional: Recent clubs section (stored in localStorage for returning visitors)
  - [ ] Optional: Help text: "Can't find your team? [Contact us]"
  - [ ] Clean, minimal design (focus on search, not marketing copy)
- [ ] Search endpoint `GET /api/public/clubs/search?q={searchterm}` returns:
  ```json
  {
    "results": [
      {
        "orgname": "edjfc",
        "displayName": "Edison Youth Football Club",
        "volunteers": 47,
        "eventCount": 3,
        "recentEvent": "Spring Cleanup - Apr 12"
      }
    ]
  }
  ```
- [ ] Search indexing:
  - [ ] Index organization: display name, orgname, optional city
  - [ ] Fuzzy matching (typos OK: 'edjfc' finds 'Edison DJFC')
  - [ ] Case-insensitive search
  - [ ] Response time <200ms for typical queries
- [ ] Search results UI:
  - [ ] Display matching clubs with name + volunteer count + next event
  - [ ] Click result → redirect to `volentry.com/{orgname}` (volunteer board landing)
  - [ ] Empty results → show friendly message: "No teams found. [Contact support]"
  - [ ] Search on enter key OR click search button
- [ ] Mobile responsive:
  - [ ] Search box full-width on mobile
  - [ ] Results displayed as vertical cards
  - [ ] Buttons 44px+ for tap targets
- [ ] Error handling:
  - [ ] Org not found → return empty results (not 404)
  - [ ] Empty search term → show recent clubs or nothing
  - [ ] Server error → show helpful message: "Can't search right now. Try again in a moment."
- [ ] Analytics (optional for MVP):
  - [ ] Track search queries (helps understand naming patterns)
  - [ ] Track successful searches (volunteer found club)
  - [ ] Track failed searches (volunteer couldn't find club, support opportunity)

**UX Notes:**
- This solves the 'lazy volunteer' problem: they type volentry.com directly instead of using club's shared link
- Catches 5-10% of volunteers who forget the exact club URL
- Also serves as implicit landing page (no separate marketing site needed for MVP)
- Future: can add smart redirect logic (geolocation, referrer, device history) in Release 2

**Technical Notes:**
- Public endpoint (no authentication required)
- Search database: query organization collection (name, displayName, city)
- Build search index when club is created (Story 5.2: admin first-time setup)
- For MVP, simple substring/fuzzy matching (can upgrade to Elasticsearch later)
- Redirect: JavaScript `window.location = '/org/{orgname}'` after result click
- Recent clubs: store in browser localStorage under key `recentClubs_[browserID]`

**Related:** Depends on Epic 0 (org creation), Epic 5 (admin setup creates club record)

---

#### Story 1.1: Volunteer Board – Public Endpoint & Events List

**As a** volunteer
**I want** to view all available upcoming events with role names and slot counts
**So that** I can quickly see what needs help and decide what to sign up for.

**Acceptance Criteria:**
- [ ] Endpoint `GET /api/volunteer/org/{orgname}/events` returns:
  - Event ID, date, time range, location (optional)
  - All timeslots for that event
  - For each slot: role names, volunteer count, capacity, open spots remaining
- [ ] Response example:
  ```json
  {
    "events": [
      {
        "id": "evt-001",
        "date": "2025-04-12",
        "timeRange": "09:00-17:00",
        "slots": [
          {
            "id": "slot-001",
            "roles": [
              { "name": "BBQ", "volunteers": 2, "capacity": 3, "open": 1 },
              { "name": "Canteen", "volunteers": 1, "capacity": 2, "open": 1 }
            ]
          }
        ]
      }
    ]
  }
  ```
- [ ] Query parameters:
  - `?weeks=1` (default: show next week)
  - `?weeks=4` (show next 4 weeks)
  - `?weeks=12` (show 3 months)
- [ ] Response is fast (<500ms) for typical load (50+ events)
- [ ] Empty slots shown clearly (open count, not just volunteers/capacity)
- [ ] Endpoint handles org-not-found (404), invalid weeks parameter (400)

**Technical Notes:**
- Query materializes from event log (read-optimized view)
- No authentication required (public endpoint)
- Partition on organizationId for multi-tenancy
- Consider caching for 1 minute if load becomes issue
- Test: curl to verify response times <500ms

**Related:** Depends on Epic 0 (Project setup, data schema)

---

#### Story 1.2: Volunteer Board UI – Hierarchical Day-Card View

**As a** volunteer
**I want** to see the volunteer board with a clear, hierarchical layout (days first, then roles)
**So that** I can quickly scan available events without cognitive overload.

**Acceptance Criteria:**
- [ ] Frontend renders volunteer board using Story 1.1 data:
  - Calls `GET /api/volunteer/org/{orgname}/events?weeks=1`
  - Displays hero section (optional featured day, or closest urgent day)
  - Displays "This Week" / "Next Week" / "Upcoming" section (smart logic per wireframes)
  - Day cards show: date (Mon, Apr 12), time range, all roles with counts
  - Each day card has "[View Details]" button (leads to Story 1.3)
  - "Beyond" section collapsed (Show More link)
- [ ] Mobile responsive (<768px):
  - Single-column card layout
  - Cards are full width
  - Text is readable (16px+)
  - Buttons are 44px tall minimum
- [ ] Desktop responsive (>1024px):
  - Cards in 2-column grid
  - More events visible at once
  - Sidebar (optional: organization info, my signups link)
- [ ] Hero section behavior:
  - If no hero set by admin: auto-populate with closest urgent day (short-staffed roles)
  - If hero set: highlight that day prominently
  - Show urgency badge ("CRITICALLY SHORT-STAFFED") if <2 slots open in any role
- [ ] Upcoming Week smart logic:
  - Detects closest week with at least 1 available slot
  - Skips weeks with no events (pause weeks)
  - Label adapts: "This Week" (if current), "Next Week" (if next 7 days), "Upcoming Week" (otherwise)
- [ ] Load time <2 seconds on typical internet (test: Chrome DevTools, 4G throttle)
- [ ] Error handling: If API fails, show friendly message ("Can't load slots right now. Try again in a few seconds.")

**Technical Notes:**
- Frontend: React/Vue component for volunteer board
- API client handles retries (3 attempts, exponential backoff)
- Responsive design: mobile-first CSS, media queries @768px + @1024px
- Performance: measure paint time with Lighthouse CI

**Related:** Depends on Story 1.1

---

#### Story 1.3: Slot Details Modal & Signup Form UI

**As a** volunteer
**I want** to click a day card and see all roles for that day, then fill a simple form to sign up
**So that** I can commit to a role in a few clicks without friction.

**Acceptance Criteria:**
- [ ] Clicking "[View Details]" on a day card opens a modal showing:
  - Event date, time range
  - All roles for that day (e.g., "BBQ 2/3", "Canteen 1/1 FULL")
  - Full volunteer names per role: "John Smith | Sarah Jones | [1 spot open]"
  - Role selection buttons (clickable, clear selection state)
- [ ] After selecting a role, form appears with fields:
  - **Name** (required, 2+ chars, label: "Your Name")
  - **Phone** (required, format: 10 digits or +1-###-###-####)
  - **Email** (required, valid email format)
  - **Team** (optional, label: "Which team are you from?", default: "Not specified")
  - 2-day rule checkbox: "I understand I can't cancel within 2 days of the event"
  - [SIGN ME UP] button (primary, 44px, disabled until form valid)
- [ ] Form validation (on blur):
  - Name: 2+ characters, no special chars (alphanumeric + space/hyphen OK)
  - Phone: 10 digits or international format, show helpful error ("e.g., 555-123-4567")
  - Email: valid email, show error ("e.g., name@example.com")
  - 2-day checkbox: must be checked before submit
  - Green checkmarks appear on valid fields
- [ ] Loading state (on submit):
  - Button shows spinner + "Signing you up..." text
  - Button disabled (no double-click)
  - User cannot dismiss modal
- [ ] Success state:
  - Clear message: "You're signed up!"
  - Show confirmation: role, date, time, volunteer count (e.g., "You're #2 for BBQ on Apr 12")
  - Show next steps: calendar icon "Add to calendar", email icon "Confirmation sent", [Done] button
  - [Done] closes modal, refreshes volunteer board
- [ ] Failure state (slot filled):
  - Message: "Just missed it! 2 others clicked BBQ at 9:47 AM. You're next if someone cancels."
  - Show: other available roles for same day, or [Go Back] button
  - [Try Another Slot] button (re-opens day view)
- [ ] Failure state (2-day rule):
  - Message: "Can't sign up - event is too close (2 days). Contact: john@example.com"
  - Show admin contact info prominently
- [ ] Responsive:
  - Mobile: full-screen modal or page transition, form fits viewport
  - Desktop: centered modal (max-width 500px)
- [ ] Accessibility:
  - Modal has focus trap (Tab stays within modal until close)
  - ESC key closes modal
  - Form fields have aria-labels
  - Error messages linked to fields (aria-describedby)

**Technical Notes:**
- Modal library: Headless UI or Radix UI (accessible by default)
- Form validation library: React Hook Form or Formik (integrates with Story 1.4 API)
- Animation: slide-up on mobile (300ms), fade on desktop (150ms)
- Test: form with valid/invalid inputs, check validation messages

**Related:** Depends on Story 1.1, Story 0b.3 (wireframes)

---

#### Story 1.4: Signup Form Submission Endpoint

**As a** system
**I want** to receive volunteer signup data and store it safely in the event log
**So that** the signup is recorded, concurrent race conditions are prevented, and the volunteer appears on the roster.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/volunteer/org/{orgname}/slots/{slotid}/signup` accepts:
  ```json
  {
    "name": "John Smith",
    "phone": "555-123-4567",
    "email": "john@example.com",
    "team": "Youth Team"
  }
  ```
- [ ] Validation (server-side, mirrors Story 1.3):
  - Name: 2+ chars, alphanumeric + space/hyphen
  - Phone: 10+ digits
  - Email: valid format
  - Returns 400 (Bad Request) with error details if invalid
- [ ] Concurrency handling (critical):
  - Request is queued to Azure Service Bus (event sourcing pattern)
  - Queue worker validates: (1) slot exists, (2) capacity not reached, (3) 2-day rule passed
  - If validation passes: write SignupCreated event to event log, return 201 (Created)
  - If slot full: return 409 (Conflict) with message "Slot full as of 9:47 AM. You're next in line."
  - If 2-day rule blocked: return 403 (Forbidden) with admin contact info
  - Idempotent: if same volunteer signs up twice with same slotid, second request succeeds with same response (no duplicate)
- [ ] Response (201 Created):
  ```json
  {
    "signupId": "signup-abc123",
    "status": "confirmed",
    "role": "BBQ",
    "eventDate": "2025-04-12",
    "eventTime": "09:00-17:00",
    "volunteerName": "John Smith",
    "slotPosition": 2,
    "slotCapacity": 3,
    "calendarUrl": "https://...",
    "message": "You're signed up!"
  }
  ```
- [ ] Response (409 Conflict - slot full):
  ```json
  {
    "status": "waitlisted",
    "message": "2 others clicked at 9:47 AM. You're next in line.",
    "timestamp": "2025-04-12T09:47:12Z"
  }
  ```
- [ ] Event log write:
  - Event type: SignupCreated
  - Contains: volunteerName, phone, email, team, slotId, eventId, timestamp
  - Immutable (no updates, only new events)
  - Enables audit trail and 2-day rule enforcement
- [ ] Rate limiting:
  - 10 requests per minute per IP (via DDoS protection, Story 0 task)
- [ ] Error cases:
  - Slot not found → 404
  - Event in past → 403 with message "Event already passed"
  - Organization not found → 404
  - Invalid JSON → 400

**Technical Notes:**
- Azure Service Bus: queue name `{orgname}-signups`, ensures ordering + at-least-once delivery
- Event log: CosmosDB collection, partition key /organizationId
- Idempotency: use `Content-Idempotency-Key` header (UUID from frontend)
- Test: concurrent requests to same slot, verify only capacity-count succeed

**Related:** Depends on Story 1.1, Story 1.3, Epic 0 (Event Sourcing, Service Bus)

---

#### Story 1.5: Volunteer Roster View – Real-Time Updates

**As a** volunteer
**I want** to see who else has signed up for my role (first name + last initial) and know when slots fill
**So that** I can see I'm part of a team and feel confident about committing.

**Acceptance Criteria:**
- [ ] Endpoint `GET /api/volunteer/org/{orgname}/events/{eventid}/slots/{slotid}/volunteers` returns:
  ```json
  {
    "role": "BBQ",
    "capacity": 3,
    "volunteers": [
      { "name": "John S.", "joinedAt": "2025-04-10T14:23:00Z" },
      { "name": "Sarah M.", "joinedAt": "2025-04-11T09:15:00Z" },
      { "name": null, "joinedAt": null }
    ],
    "lastUpdated": "2025-04-11T09:15:00Z"
  }
  ```
- [ ] Only first name + last initial shown (privacy: full names hidden until admin context)
- [ ] `joinedAt` timestamps determine "(Just now)" badges:
  - < 1 min ago: "(Just now)"
  - < 1 hour ago: "(5 mins ago)"
  - < 1 day ago: "(Yesterday)"
  - Otherwise: show date
- [ ] Full volunteer list visible even if slot full (transparency)
- [ ] Real-time updates (tied to Epic 3):
  - When new volunteer signs up, list updates instantly via WebSocket
  - No page refresh needed
  - Smooth animation as new name appears
- [ ] Endpoint handles:
  - Slot not found → 404
  - Event in past → return roster as-is (no updates)
- [ ] Performance: <200ms response time

**Technical Notes:**
- Materialized view: query event log, extract SignupCreated events for slot, render last-name-initial projection
- WebSocket: tied to real-time epic (Story 3.X)
- Privacy: never expose full names in volunteer API (only first + last initial)

**Related:** Depends on Story 1.3, Epic 3 (Real-Time)

---

#### Story 1.6: Success Confirmation & Calendar Integration

**As a** volunteer
**I want** to see a confirmation screen after signing up with an option to add the event to my calendar
**So that** I have a clear record and the event appears on my calendar app.

**Acceptance Criteria:**
- [ ] Success confirmation screen (from Story 1.4) shows:
  - Large checkmark icon + "You're signed up!"
  - Event details: role, date, time, location
  - Volunteer count: "You're #2 of 3 for BBQ"
  - Confirmation message: "A confirmation email has been sent to john@example.com"
- [ ] [Add to Calendar] button that:
  - Generates .ics file (RFC 5545 format) with event details
  - Includes:
    - Event title: "BBQ - Volunteer Slot"
    - Start/end time
    - Location
    - Description: "You're signed up as #2 of 3. Can't make it? Contact john@example.com to cancel."
  - Browser downloads .ics file or opens calendar app
  - File name: `volunteer-{eventid}.ics`
- [ ] [Done] button closes modal and refreshes volunteer board
- [ ] Mobile-friendly:
  - Calendar button works on iPhone (opens Apple Calendar or Google Calendar)
  - Desktop: downloads .ics, opens in default calendar app
- [ ] Error handling: If .ics generation fails, show helpful message ("Can't generate calendar file. Try copying event details manually.")

**Technical Notes:**
- .ics generation: library like `ics.js` or `icalendar`
- Include organizer email (admin contact) so volunteer can reach out
- Test: download .ics, open in Outlook/Gmail/Apple Calendar

**Related:** Depends on Story 1.4

---

### Epic 2: Volunteer Self-Service & Cancellation
**Goal:** Volunteers can find their signups and cancel with 2-day guardrails.

**User Outcome:** Volunteer filters board by name → finds commitment → can cancel (or gets blocked with clear reason if <2 days).

**FRs covered:** FR4, FR5, FR6, FR8
**UX-DRs covered:** UX-DR21-UX-DR28 (my signups view, filtering, cancellation flow, 2-day blocking)
**NFRs addressed:** NFR22 (2-day window enforcement guaranteed by event log)

**Key Deliverables:**
- "My Signups" link on volunteer board
- Volunteer filtering endpoint (`GET /api/volunteer/org/{orgname}/my-signups`)
- My Signups view displays all volunteer commitments with dates
- Cancel button per signup
- Cancellation endpoint (`POST /api/volunteer/org/{orgname}/slots/{slotid}/cancel`)
- 2-day window validation (event log timestamp enforces rule)
- Success message: "Cancelled. Admin notified."
- Failure message: "You committed through [date]. Contact admin if something changed." + contact info
- Event-log write for cancellation (immutable record)

**Acceptance Criteria (High-Level):**
- Filtering by name returns all signups for that volunteer
- Cancel >2 days away: success, volunteer removed from roster
- Cancel <2 days away: blocked, clear message with admin contact
- Volunteer disappears from roster in real-time after cancellation

**Design Reaffirmation:** Before stories, team reviews wireframes for my-signups view + cancellation dialogs

#### Story 2.1: My Signups Endpoint – Volunteer Signup History

**As a** volunteer
**I want** to retrieve all my signups (past, upcoming, cancelled) from an API
**So that** my frontend can display my commitments and offer cancellation options.

**Acceptance Criteria:**
- [ ] Endpoint `GET /api/volunteer/org/{orgname}/my-signups?phone={phone}` returns:
  ```json
  {
    "volunteer": {
      "phone": "555-123-4567",
      "name": "John Smith"
    },
    "signups": [
      {
        "signupId": "signup-001",
        "eventId": "evt-001",
        "slotId": "slot-001",
        "eventDate": "2025-04-12",
        "eventTime": "09:00-17:00",
        "role": "BBQ",
        "status": "confirmed",
        "signedUpAt": "2025-04-10T14:23:00Z",
        "canCancel": true,
        "daysUntilEvent": 2,
        "cancelDeadline": "2025-04-10T09:00:00Z"
      },
      {
        "signupId": "signup-002",
        "eventId": "evt-002",
        "slotId": "slot-002",
        "eventDate": "2025-04-15",
        "eventTime": "10:00-14:00",
        "role": "Canteen",
        "status": "confirmed",
        "signedUpAt": "2025-04-08T10:15:00Z",
        "canCancel": false,
        "daysUntilEvent": -1,
        "reason": "Event already passed"
      }
    ]
  }
  ```
- [ ] Query parameter: `phone` (required, must match signup record)
- [ ] Sorting: upcoming events first (by eventDate), then past events (newest first)
- [ ] `canCancel` field:
  - `true` if >2 days until event
  - `false` if ≤2 days until event OR event already passed
  - Include `reason` field when false
- [ ] `daysUntilEvent`:
  - Positive: days remaining (2 = in 2 days)
  - Zero/Negative: event passed or today
- [ ] `cancelDeadline`: timestamp of 2-day cutoff (event start time - 2 days)
- [ ] Error handling:
  - No signups found → return empty array (not 404)
  - Invalid phone format → 400 (Bad Request)
  - Organization not found → 404
- [ ] Performance: <200ms for typical volunteer (10-20 signups)

**Technical Notes:**
- Query: event log for SignupCreated events matching phone + org
- Filter: exclude CancelledSignup events (if found, set status to "cancelled")
- No authentication required (phone is quasi-anonymous lookup)
- Future: add email as secondary lookup method (v1.1)

**Related:** Depends on Epic 1 (Signup creation writes events to log)

---

#### Story 2.2: My Signups UI – View & Filter Signups

**As a** volunteer
**I want** to view my upcoming commitments in a simple list and easily find events I need to cancel
**So that** I can see what I'm committed to and take action if plans change.

**Acceptance Criteria:**
- [ ] Page/view shows:
  - Input field: "Enter your phone number" (auto-fill from signup, or let user enter)
  - [FIND MY SIGNUPS] button
  - Loading state while fetching Story 2.1 endpoint
- [ ] After finding signups, display:
  - **Upcoming Events** (next 7 days, collapsible section, initially expanded)
    - Cards for each signup: date (Mon, Apr 12), time, role, [CANCEL] button
    - Color indicator: 🟢 can cancel, 🔴 cannot cancel (< 2 days)
  - **Later Events** (8+ days away, initially expanded)
    - Same layout as above
  - **Past Events** (collapsed section, "See Past Events ↓")
    - Grayed out, no cancel button, shows "Completed" badge
- [ ] Empty states:
  - No signups found → "No upcoming events. Check out the volunteer board to sign up!"
  - Phone not found → "We couldn't find signups for that number. Make sure you entered it correctly."
- [ ] Mobile responsive:
  - Cards stack vertically
  - [CANCEL] button is large (44px minimum)
  - Phone input has proper mobile keyboard (type="tel")
- [ ] [BACK] link to return to volunteer board

**Technical Notes:**
- Call Story 2.1 endpoint with phone from form input
- Parse response, group by date/status
- Show loading spinner while fetching
- Cache result for 5 minutes (reduce API calls if user refreshes)

**Related:** Depends on Story 2.1

---

#### Story 2.3: Cancellation Confirmation Dialog

**As a** volunteer
**I want** to confirm my cancellation with a clear dialog showing what I'm cancelling
**So that** I don't accidentally cancel a signup.

**Acceptance Criteria:**
- [ ] Clicking [CANCEL] button on a signup opens a modal showing:
  - Confirmation message: "Cancel your signup?"
  - Event details: date, time, role
  - Clear warning: "You're cancelling your commitment to [Role] on [Date]. Admin will see this cancellation."
  - Optional text field: "Reason (optional)" — helps admin understand why
  - [Confirm Cancellation] button (primary, red)
  - [Keep Commitment] button (secondary)
- [ ] If signup is <2 days away, modal shows different message:
  - 🔴 "You can't cancel now"
  - Explanation: "You committed through [cancel deadline date]. Contact admin if something changed."
  - Show admin contact: "john@example.com, 555-123-4567"
  - [OK] button only (no cancellation allowed)
- [ ] Accessibility:
  - Focus trap (Tab stays in modal)
  - ESC key closes modal (if >2 days away)
  - Button labels are clear and unambiguous

**Technical Notes:**
- Modal library: Headless UI or Radix UI
- Reason field is optional, stored in event log but not required
- Don't close modal on submit — wait for Story 2.4 response

**Related:** Depends on Story 2.2

---

#### Story 2.4: Cancellation Endpoint – Process & Log Cancellation

**As a** system
**I want** to safely cancel a volunteer's signup and validate the 2-day rule
**So that** cancellations are recorded in the immutable event log and the 2-day guardrail is enforced.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/volunteer/org/{orgname}/slots/{slotid}/cancel` accepts:
  ```json
  {
    "phone": "555-123-4567",
    "reason": "Got sick, won't make it"
  }
  ```
- [ ] Server-side validation:
  - Phone matches signup record for this slot (verify ownership)
  - Signup exists and hasn't been cancelled already (idempotent)
  - Event hasn't passed (can't cancel past events)
  - **2-day rule check (critical):**
    - Calculate: now() vs. event start time
    - If event starts in < 2 days: return 403 (Forbidden) with message "Can't cancel within 2 days"
    - If event starts in ≥ 2 days: allow cancellation
- [ ] On successful cancellation:
  - Write SignupCancelled event to event log (immutable)
  - Event includes: signupId, phone, role, reason, timestamp
  - Return 200 (OK) with message:
    ```json
    {
      "status": "cancelled",
      "message": "You've cancelled your commitment. Admin will find a replacement.",
      "eventDate": "2025-04-12",
      "eventTime": "09:00-17:00",
      "role": "BBQ"
    }
    ```
- [ ] On failure (< 2 days):
  - Return 403 (Forbidden):
    ```json
    {
      "status": "blocked",
      "message": "You committed through April 10. Contact admin if something changed.",
      "eventDate": "2025-04-12",
      "cancelDeadline": "2025-04-10T09:00:00Z",
      "adminEmail": "john@example.com",
      "adminPhone": "555-123-4567"
    }
    ```
- [ ] Idempotency:
  - If same request sent twice (duplicate phone + slot), second succeeds with same response (no error)
  - Use `Content-Idempotency-Key` header (UUID from frontend)
- [ ] Rate limiting: 10 requests/minute per IP (from DDoS protection)
- [ ] Event log write is immutable and tamper-proof (audit trail)

**Technical Notes:**
- Queue to Azure Service Bus (like Story 1.4) to ensure ordering
- Worker validates 2-day rule against event log timestamp
- If worker detects stale write, alert ops (prevents clock-skew attacks)
- Test: submit cancellation at 9:59 AM for event starting at 11:59 AM (2 days + 2 minutes away) — should succeed
- Test: submit at 11:01 AM for same event (now <2 days) — should fail with 403

**Related:** Depends on Story 2.1, Story 2.3, Epic 0 (Event Sourcing)

---

#### Story 2.5: Cancellation Success Screen & Admin Notification

**As a** volunteer
**I want** to see confirmation that my cancellation was successful and that admin has been notified
**So that** I know the change is registered and the slot is now open for someone else.

**Acceptance Criteria:**
- [ ] After Story 2.4 succeeds (200 OK), show success screen:
  - Large checkmark icon + "Cancellation confirmed"
  - Message: "Admin has been notified and will find a replacement for BBQ on April 12"
  - Event details removed from my signups list (refreshed via Story 2.1 re-fetch)
  - [Done] button → returns to My Signups view
  - [Back to Board] button → returns to volunteer board
- [ ] If cancellation fails (403 Forbidden):
  - Show failure screen with admin contact info
  - Message: "You can't cancel within 2 days of the event. Please contact admin directly."
  - Show: admin name, email, phone
  - [OK] button → returns to My Signups view
- [ ] Real-time roster update (tied to Epic 3):
  - Cancelled volunteer's name disappears from roster
  - Open slot count updates
  - No page refresh needed
- [ ] Admin is notified:
  - Admin dashboard shows cancellation in real-time
  - "(Just cancelled)" badge appears on roster
  - (Actual email notification is Epic 4 task)

**Technical Notes:**
- On success, refetch Story 2.1 to refresh signup list
- Animate removal of cancelled signup (fade out, 300ms)
- Real-time update: tied to WebSocket from Epic 3

**Related:** Depends on Story 2.4, Epic 3 (Real-Time)

---

### Epic 3: Real-Time Architecture (Merged 6 & 8)
**Goal:** Both volunteer board and admin roster update live without page refresh.

**User Outcome:** Volunteer watching board sees slot counts decrease as others sign up. Admin watching roster sees new names appear instantly. Real-time feel builds trust.

**FRs covered:** FR7 (volunteer board real-time), FR12, FR20 (admin roster real-time)
**UX-DRs covered:** UX-DR29-UX-DR35 (slot count updates, roster updates, smooth animations, presence indicators)
**NFRs addressed:** NFR7 (real-time updates instant), NFR6-NFR8 (performance, no refresh needed)

**Key Deliverables:**
- Azure SignalR Service setup OR raw WebSocket fallback
- Hub for volunteer board updates (slot count deltas)
- Hub for admin roster updates (new signups, cancellations)
- Delta broadcast logic (only changed records, not full board state)
- Smooth animations on DOM updates (no jumpy refreshes)
- Presence indicator (admin sees "Sarah is viewing this event")
- "(Just now)" badge on new signups (displays ~10 seconds)
- Connection lifecycle: open on page load, close on unload

**Acceptance Criteria (High-Level):**
- Volunteer board updates live as signups/cancellations occur
- Admin roster updates live with new names appearing instantly
- Changes feel smooth (animations, not jumpy)
- No page refresh needed
- Connection handles disconnects gracefully (retry, reconnect)

**Design Reaffirmation:** Before stories, team reviews wireframes for live state transitions + animations

#### Story 3.1: WebSocket Infrastructure Setup – Connection & Lifecycle

**As a** developer
**I want** to establish WebSocket infrastructure for real-time updates (Azure SignalR OR raw WebSocket)
**So that** the platform can broadcast slot/roster changes to all connected clients without page refreshes.

**Acceptance Criteria:**
- [ ] Choose real-time technology:
  - **Option A: Azure SignalR Service** (managed, recommended if cost acceptable)
    - Setup: Create SignalR service in Azure, configure ASP.NET Core SignalR hubs
    - Cost evaluation: ~$0.50-1.00 per day for MVP load (50 concurrent connections)
    - Auto-scale to 100+ concurrent if load increases
  - **Option B: Raw WebSocket fallback** (if cost prohibitive)
    - Setup: ASP.NET Core WebSocket middleware + custom hub logic
    - No external service costs, but requires load balancing across multiple servers
- [ ] Infrastructure setup includes:
  - [ ] Hub definition for volunteer board updates (`VolunteerBoardHub`)
  - [ ] Hub definition for admin roster updates (`AdminRosterHub`)
  - [ ] Hub definition for admin presence (`PresenceHub`)
  - [ ] Connection string/configuration in appsettings.json (environment-specific)
  - [ ] Dependency injection setup (IHubContext for broadcasting)
- [ ] Connection lifecycle:
  - [ ] Client connects on page load (componentDidMount / onMounted)
  - [ ] Client includes metadata: orgname, userId (or anonymous ID)
  - [ ] Connection ID assigned by server
  - [ ] Client disconnects on page unload (cleanup)
  - [ ] Server detects disconnects and removes from presence tracking
- [ ] Connection resilience:
  - [ ] Client auto-reconnects on disconnect (exponential backoff: 1s, 2s, 4s, 8s, max 30s)
  - [ ] Reconnection attempts logged (ops visibility)
  - [ ] Max 5 reconnection attempts, then show error message ("Connection lost. Refresh page")
- [ ] Security:
  - [ ] Only authenticated clients connect (admin hubs require JWT token)
  - [ ] Volunteer board hub is public (any client can subscribe to orgname)
  - [ ] Connection validates orgname from URL vs. connection metadata (prevent cross-org data leaks)
  - [ ] Rate limiting: max 10 messages/second per client (prevent spam)

**Technical Notes:**
- SignalR vs WebSocket trade-off deferred to implementation phase (cost evaluation)
- For MVP, start with Azure SignalR (easiest to scale, less ops overhead)
- Connection pooling handled by ASP.NET Core runtime
- Test: connect 50 concurrent clients, verify all receive broadcasts

**Related:** Depends on Epic 0 (Project setup, authentication)

---

#### Story 3.2: Volunteer Board Real-Time Updates – Slot Count Deltas

**As a** volunteer
**I want** to see slot counts update in real-time as others sign up/cancel
**So that** I know which slots are filling up without refreshing the page.

**Acceptance Criteria:**
- [ ] When volunteer signs up (from Story 1.4):
  - SignupCreated event written to event log
  - Event sourcing handler broadcasts delta to `VolunteerBoardHub`:
    ```json
    {
      "eventType": "slot-count-updated",
      "orgname": "football-club",
      "slotId": "slot-001",
      "role": "BBQ",
      "previousCount": 1,
      "newCount": 2,
      "capacity": 3,
      "timestamp": "2025-04-12T09:47:12Z",
      "badge": "Just now"
    }
    ```
- [ ] Client (volunteer board) receives delta and updates:
  - Find slot on page (by slotId)
  - Update volunteer count display: "BBQ 2/3" → "BBQ 2/3" (or full: "FULL")
  - Highlight changed slot with animation (pulse or brief flash)
  - Show "(Just now)" badge for ~10 seconds, then fade
  - Update open count: "1 open" → "0 open"
- [ ] When volunteer cancels (from Story 2.4):
  - CancelledSignup event written to event log
  - Handler broadcasts delta:
    ```json
    {
      "eventType": "slot-count-updated",
      "orgname": "football-club",
      "slotId": "slot-001",
      "role": "BBQ",
      "previousCount": 2,
      "newCount": 1,
      "capacity": 3,
      "timestamp": "2025-04-12T10:15:00Z",
      "badge": "Just opened"
    }
    ```
  - Client updates: "BBQ 2/3 FULL" → "BBQ 1/3" (slot reopened, highlight green)
- [ ] Multiple slots can update simultaneously:
  - Broadcast separate delta per slot (not full board state)
  - Client merges deltas without full refresh (reduces bandwidth)
  - Prevents flashing/jumpy UI
- [ ] Performance:
  - Delta broadcast <100ms from signup completion
  - Client DOM update <50ms (smooth animations)
  - Test: rapid 10 concurrent signups, verify counts update correctly

**Technical Notes:**
- Event sourcing handler: subscribed to event log, filters SignupCreated/CancelledSignup events
- Hub broadcasts: SendAsync("OnSlotUpdated", delta) to group `org-{orgname}` subscribers
- Client state management: use React context or Vuex to store counts, update on delta
- Animation: CSS transition (ease-out, 300ms) on count change
- Badge timeout: set 10-second timer, fade out badge

**Related:** Depends on Story 3.1, Story 1.4, Story 2.4

---

#### Story 3.3: Volunteer Roster – Live Volunteer Names & "(Just now)" Badges

**As a** volunteer
**I want** to see who else signed up (first name + last initial) and when they joined
**So that** I feel part of a team and see the slot is actually getting filled.

**Acceptance Criteria:**
- [ ] When volunteer signs up:
  - Signup endpoint (Story 1.4) returns signupId + volunteer name
  - SignupCreated event includes volunteer name
  - Event handler broadcasts roster update to `VolunteerBoardHub`:
    ```json
    {
      "eventType": "roster-updated",
      "orgname": "football-club",
      "slotId": "slot-001",
      "role": "BBQ",
      "volunteers": [
        { "name": "John S.", "joinedAt": "2025-04-10T14:23:00Z" },
        { "name": "Sarah M.", "joinedAt": "2025-04-11T09:15:00Z" },
        { "name": "Mike W.", "joinedAt": "2025-04-12T09:47:12Z", "badge": "Just now" }
      ],
      "timestamp": "2025-04-12T09:47:12Z"
    }
    ```
- [ ] Client (volunteer board) receives update and:
  - Updates volunteer list for that slot
  - Appends new volunteer to end of list (animation: slide in, fade in)
  - Shows "(Just now)" badge on new volunteer for ~10 seconds
  - Smooth scroll to new volunteer if list is long
- [ ] When volunteer cancels:
  - CancelledSignup event includes volunteer name + slotId
  - Handler broadcasts roster update with removed volunteer:
    ```json
    {
      "eventType": "roster-updated",
      "orgname": "football-club",
      "slotId": "slot-001",
      "volunteers": [
        { "name": "John S.", "joinedAt": "2025-04-10T14:23:00Z" },
        { "name": "Sarah M.", "joinedAt": "2025-04-11T09:15:00Z" }
      ]
    }
    ```
  - Client animation: fade out and remove cancelled volunteer from list
  - Reopened slot indicator appears (e.g., "1 spot now open", green highlight)
- [ ] Privacy:
  - Only first name + last initial shown (no full names on public board)
  - Full names only visible in admin roster (authenticated context)
- [ ] Performance:
  - Broadcast <100ms from signup/cancellation
  - Client DOM update smooth (no jumpy list)

**Technical Notes:**
- Volunteer name truncation: "John Smith" → "John S." (first name + first letter of last)
- Badge display: show for 10 seconds, fade out
- List animation: CSS transition (ease-out, 300ms) for add/remove
- Roster state: maintain in client (React state or Vue reactive data)

**Related:** Depends on Story 3.1, Story 1.5 (Volunteer Roster), Story 2.4 (Cancellation)

---

#### Story 3.4: Admin Roster – Live Coverage Status & Urgency Indicators

**As a** admin
**I want** to see the roster update in real-time and know immediately when slots fill or become open
**So that** I can spot shortages and take quick action (manual signup, emergency call).

**Acceptance Criteria:**
- [ ] Admin dashboard displays roster (from Story 6.2, depends on real-time):
  - Organized by role with capacity indicators ("BBQ 2/3", "Canteen 1/1 FULL")
  - Volunteer list with names, phone, email
  - "(Just now)" badges on new signups (displayed ~10 seconds)
  - "(Just cancelled)" badge on recently cancelled slots (red, ~10 seconds)
- [ ] When new volunteer signs up:
  - Admin roster receives broadcast from `AdminRosterHub`:
    ```json
    {
      "eventType": "signup-created",
      "eventId": "evt-001",
      "slotId": "slot-001",
      "role": "BBQ",
      "volunteerName": "Mike W.",
      "volunteerPhone": "555-987-6543",
      "volunteerEmail": "mike@example.com",
      "position": 3,
      "capacity": 3,
      "timestamp": "2025-04-12T09:47:12Z",
      "isFull": true,
      "wasShortStaffed": true
    }
    ```
  - Admin dashboard updates:
    - Volunteer name appears in roster (slide in, fade in animation)
    - "(Just now)" badge appears for 10 seconds
    - Role capacity updates: "BBQ 2/3" → "BBQ 3/3 FULL" (turn green, highlight)
    - If was short-staffed: urgency badge disappears ("2 SLOTS SHORT" → removed)
- [ ] When volunteer cancels:
  - Admin receives broadcast:
    ```json
    {
      "eventType": "signup-cancelled",
      "eventId": "evt-001",
      "slotId": "slot-001",
      "role": "BBQ",
      "volunteerName": "Mike W.",
      "position": 3,
      "capacity": 3,
      "timestamp": "2025-04-12T10:15:00Z",
      "isNowShortStaffed": true
    }
    ```
  - Admin dashboard updates:
    - Volunteer name disappears from roster (fade out, slide out animation)
    - "(Just cancelled)" badge shown (red)
    - Role capacity updates: "BBQ 3/3 FULL" → "BBQ 2/3" (turn orange, highlight)
    - If now short-staffed: alert appears ("1 SLOT SHORT FOR BBQ!", red urgency badge)
- [ ] Shortfall tracking:
  - Dashboard shows: "Total Shortfalls: 3 roles" (sticky at top)
  - Color coding:
    - 🟢 Green: full slots
    - 🟡 Yellow: at/near capacity (1-2 open)
    - 🔴 Red: critical shortage (<1 open, labeled "URGENT")
- [ ] Performance:
  - Real-time updates <100ms
  - No full roster refresh (delta updates only)
  - Smooth animations (no flashing or jumpy UI)

**Technical Notes:**
- Admin roster broadcasts separate from volunteer board broadcasts
- Admin auth required to receive AdminRosterHub messages
- Delta updates: only changed role capacities and volunteer names
- Animation: fade in (300ms) for new volunteers, fade out (300ms) for cancellations
- Color transitions: CSS ease-out (300ms) for role color changes

**Related:** Depends on Story 3.1, Story 1.4 (Signup), Story 2.4 (Cancellation)

---

#### Story 3.5: Presence Indicators & Connection State

**As a** admin
**I want** to see which other admins are viewing the dashboard
**So that** I know someone else is monitoring the same event and I don't duplicate efforts.

**Acceptance Criteria:**
- [ ] Admin dashboard shows:
  - "Viewing" indicator: "Sarah is viewing this event" (or "You're the only one")
  - Shows up to 3 other admins by name
  - If 4+ viewing: "Sarah, John, + 2 others are viewing"
- [ ] Presence tracking:
  - When admin loads dashboard, connect to `PresenceHub`
  - Send: `{ eventId, adminId, adminName, connectedAt }`
  - Hub broadcasts to other admins: "Sarah joined" (fade in message, auto-dismiss after 5s)
  - When admin unloads/leaves: broadcast "Sarah left"
  - Show list updated in real-time
- [ ] Connection state indicator:
  - Top-right corner: green dot "Connected" or red dot "Disconnected"
  - If disconnected: "Lost connection. Reconnecting..." + auto-retry
  - If reconnected: "Reconnected" flash message (brief)
  - If failed after 5 retries: "Connection lost. Refresh page to continue."
- [ ] Presence timeout:
  - If admin idle for 5 minutes, presence expires (considered left)
  - Admin can refresh page to keep presence active
- [ ] Privacy:
  - Presence only visible to authenticated admins in same org
  - Anonymous volunteers can't see admin presence

**Technical Notes:**
- PresenceHub: separate from roster hub (different auth context)
- Presence timeout: server-side 5-minute expiry, client sends heartbeat every 2 minutes
- Connection state: use client WebSocket event listeners (onopen, onclose, onerror)
- Message animations: toast notification (slide in, auto-dismiss)

**Related:** Depends on Story 3.1

---

### Epic 4: Email Confirmations & Calendar Integration
**Goal:** Volunteers receive instant confirmation email with calendar invite in <10 seconds.

**User Outcome:** Signup completes → email arrives with calendar attachment → volunteer clicks "Add to Calendar" → event syncs with Outlook/Google/Apple.

**FRs covered:** FR31, FR32, FR33
**UX-DRs covered:** UX-DR36-UX-DR40 (email template, calendar integration)
**NFRs addressed:** NFR3 (email arrives within 10 seconds)

**Key Deliverables:**
- Email service integration (Azure Communication Services OR SendGrid, cost evaluated)
- Email template design (confirmation + calendar attachment)
- RFC 5545 (.ics) calendar file generation
- Calendar invite metadata (event title, date/time, volunteer role, organization name)
- Email sending triggered on successful signup (from Epic 1)
- Support for Outlook, Google Calendar, Apple Calendar (.ics format)
- Fallback if email service down (graceful error, user sees message)

**Acceptance Criteria (High-Level):**
- Email sent within 10 seconds of signup confirmation
- Email contains volunteer details (name, role, date/time)
- Calendar invite (.ics) attachment is valid
- Clicking "Add to Calendar" in email syncs to calendar apps
- Works across all major calendar platforms

**Design Reaffirmation:** Before stories, team reviews email template wireframes + calendar invite format

#### Story 4.1: Email Service Integration & Configuration

**As a** developer
**I want** to set up email service (Azure Communication Services OR SendGrid) and configure environment
**So that** confirmation emails can be sent reliably to volunteers.

**Acceptance Criteria:**
- [ ] Choose email service (cost evaluation):
  - **Option A: Azure Communication Services** (integrated with Azure, ~$0.01 per email)
  - **Option B: SendGrid** (third-party, ~$10-20/month for MVP volume, 100+ emails/day)
  - Decision: Start with Azure Communication Services (lower cost, fewer moving parts)
- [ ] Setup includes:
  - [ ] Service credentials in appsettings.json (environment-specific)
  - [ ] Connection string or API key stored securely (Azure Key Vault)
  - [ ] Email client injected into DI container
  - [ ] Sender email address configured (noreply@myvolunteerapp.com or org-specific)
  - [ ] Retry policy (3 attempts, exponential backoff) for failed sends
- [ ] Configuration:
  - [ ] Admin can customize "From" name and email (v1.1 feature, hardcode for MVP)
  - [ ] Admin can customize email subject template (v1.1 feature, hardcode for MVP)
  - [ ] Admin email/phone stored in event log for volunteer contact (Story 2.4)
- [ ] Email sending triggered by Story 1.4 (Signup endpoint):
  - [ ] On successful signup, fire-and-forget email send (async, don't block signup response)
  - [ ] Failure to send email doesn't fail signup (graceful degradation)
  - [ ] If email send fails after 3 retries, log error + alert ops (but volunteer still confirmed)
- [ ] Testing:
  - [ ] Unit test: mock email client, verify send called with correct parameters
  - [ ] Integration test: send test email to sandbox address, verify arrival
  - [ ] Load test: send 50 emails concurrently, verify no rate-limiting
- [ ] Monitoring:
  - [ ] Track email send success/failure rates (ops dashboard)
  - [ ] Alert if send failure rate > 5% (ops on-call)

**Technical Notes:**
- Async/await: Story 1.4 doesn't await email send (fire-and-forget pattern)
- Idempotent: if send retries, include idempotency key to prevent duplicate sends
- Cost: ~$0.01-0.02 per email, estimate 100-200 emails/week for MVP = <$2/week

**Related:** Depends on Epic 1 (Signup)

---

#### Story 4.2: Email Confirmation Template & Calendar Invite (.ics)

**As a** developer
**I want** to generate HTML email template with embedded calendar invite
**So that** volunteers receive branded confirmation with one-click calendar add.

**Acceptance Criteria:**
- [ ] Email HTML template includes:
  - [ ] Organization logo (header, 200x80px)
  - [ ] Subject line: "[Organization] - You're signed up for [Role] on [Date]"
  - [ ] Greeting: "Hi [Volunteer Name],"
  - [ ] Main message: "You're signed up as #[Position] of [Capacity] for [Role] on [Date] from [Time]. Other volunteers: [Name], [Name], [Name]"
  - [ ] Event details section:
    - Event: [Event Name/Sport]
    - Date: [Date] (e.g., "Saturday, April 12, 2025")
    - Time: [Start] - [End]
    - Role: [Role Name]
    - Your position: [Position]/[Capacity]
  - [ ] Team roster section:
    - "Here's who else is helping:"
    - Bulleted list of other volunteers (first name + last initial)
  - [ ] Call to action: "[+ Add to Calendar]" button (links to .ics download)
  - [ ] Cancellation info: "Need to cancel? https://myvolunteerapp.com/my-signups - must cancel at least 2 days before event"
  - [ ] Admin contact: "Questions? Contact [Admin Name] at [Phone] or [Email]"
  - [ ] Footer: "© 2025 MyVolunteerApp"
- [ ] Calendar invite (.ics file, RFC 5545 format):
  ```
  BEGIN:VCALENDAR
  VERSION:2.0
  PRODID:-//MyVolunteerApp//Football Club//EN
  BEGIN:VEVENT
  UID:signup-001@myvolunteerapp.com
  DTSTAMP:20250412T000000Z
  DTSTART:20250412T090000
  DTEND:20250412T170000
  SUMMARY:BBQ - Volunteer Shift
  DESCRIPTION:You're signed up as #2 of 3 for BBQ. Contact: john@example.com
  LOCATION:[Event Location, if available]
  ORGANIZER:CN=Football Club;EMAIL=john@example.com
  ATTENDEE;CN=[Volunteer Name];EMAIL=[Volunteer Email]:mailto:[Volunteer Email]
  STATUS:CONFIRMED
  SEQUENCE:0
  END:VEVENT
  END:VCALENDAR
  ```
- [ ] .ics file attachment:
  - [ ] Generated on-demand from signup data
  - [ ] File name: `volunteer-signup-[SlotId].ics`
  - [ ] Valid RFC 5545 format (tested in Outlook, Google Calendar, Apple Calendar)
  - [ ] Timezone aware (use UTC or org's timezone if available)
- [ ] Email send includes:
  - [ ] HTML body (rendered template)
  - [ ] .ics attachment (calendar invite)
  - [ ] Plain text fallback (for email clients without HTML support)
- [ ] Template variables:
  - [ ] [Organization], [Volunteer Name], [Role], [Date], [Time], [Position], [Capacity]
  - [ ] [Admin Name], [Admin Email], [Admin Phone]
  - [ ] [Other Volunteers List]
- [ ] Responsive email design:
  - [ ] Mobile-friendly (tested in Gmail, Outlook mobile)
  - [ ] Font sizes readable (14px+ body text)
  - [ ] Colors accessible (contrast ≥4.5:1)

**Technical Notes:**
- .ics generation library: `icalendar.js` or `ics.js`
- Email template engine: Razor or Liquid templates (C# friendly)
- Attachment: include MIME type `text/calendar` with `method=REQUEST`
- Test: send test email, download .ics, open in 3 calendar apps (Outlook, Gmail, Apple)

**Related:** Depends on Story 4.1, Epic 1 (Signup data)

---

### Epic 5: Admin Authentication & Role Management
**Goal:** Admins can securely log in and manage their organization's admin team.

**User Outcome:** First admin created on org onboarding → auto-promoted to Super-Admin → can invite other admins → manage roles (downgrade themselves only if another Super-Admin exists) → can deactivate other admins.

**FRs covered:** FR16, FR17, FR19, FR37, FR38, FR39, FR40
**UX-DRs covered:** UX-DR41, UX-DR66-UX-DR71 (login page, invite flow, admin setup)
**ARs covered:** AR13-AR19 (auth via username + password, bcrypt hashing, token-based invites, role-based access control)

**Key Deliverables:**
- Admin login page (username, password)
- Authentication endpoint with bcrypt verification
- JWT token generation (long-lived for session persistence)
- Token-based invite flow (24-hour expiry, one-time use)
- Invite email with secure link
- Admin invite acceptance page (password setup on first login via invite link)
- Role management endpoints:
  - Downgrade Super-Admin to Regular Admin (check: must be ≥1 other Super-Admin)
  - Deactivate admin account (Super-Admin only, not self)
- Authorization middleware (enforce role-based access control on admin endpoints)
- Event-log writes for all role changes (audit trail)

**Acceptance Criteria (High-Level):**
- Admin login works with correct username + password
- First admin auto-assigned Super-Admin role
- Super-Admin can invite other admins
- Invited admin receives email with 24-hour link
- Downgrade blocked if only Super-Admin (error message)
- Deactivation prevents login for deactivated admin
- All role changes logged to event log (immutable audit trail)

**Design Reaffirmation:** Before stories, team reviews wireframes for login page + admin invite flow

#### Story 5.1: Admin Login Endpoint & Authentication

**As a** admin
**I want** to log in with username and password
**So that** I can access the admin dashboard and manage my organization's volunteers and events.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/admin/auth/login` accepts:
  ```json
  {
    "username": "sarah@footballclub.com",
    "password": "SecurePassword123",
    "orgname": "football-club"
  }
  ```
- [ ] Server-side validation:
  - [ ] Username exists in admin database for org
  - [ ] Password matches hashed value using bcrypt (12 rounds)
  - [ ] Admin account is not deactivated (active: true in DB)
  - [ ] Returns 401 (Unauthorized) if credentials wrong: "Invalid username or password"
  - [ ] Returns 403 (Forbidden) if account deactivated: "Your account has been deactivated. Contact organization owner."
- [ ] On success (200 OK):
  ```json
  {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "tokenType": "Bearer",
    "expiresIn": 86400,
    "admin": {
      "id": "admin-001",
      "name": "Sarah",
      "username": "sarah@footballclub.com",
      "role": "Super-Admin",
      "orgname": "football-club"
    }
  }
  ```
- [ ] JWT token:
  - [ ] Algorithm: HS256
  - [ ] Expiry: 24 hours (86400 seconds)
  - [ ] Payload includes: adminId, username, orgname, role
  - [ ] Secret key stored in Azure Key Vault
- [ ] Token storage (client-side):
  - [ ] Store in httpOnly cookie (secure, samesite=strict) OR localStorage (simpler, less secure)
  - [ ] Decision: httpOnly cookie for MVP (more secure, prevents XSS theft)
  - [ ] Include in Authorization header: `Bearer {token}` on all admin API requests
- [ ] Error cases:
  - [ ] Org not found → 404
  - [ ] Username/password format invalid → 400
  - [ ] Too many failed attempts (5 in 15 min) → 429 (rate limit)
- [ ] Security:
  - [ ] No plaintext passwords logged (only hash)
  - [ ] Failed attempts logged for audit trail
  - [ ] Password rules enforced: 8+ chars, 1 uppercase, 1 number (Story 5.3)

**Technical Notes:**
- bcrypt: use `BCrypt.Net-Next` NuGet package
- JWT: use `System.IdentityModel.Tokens.Jwt`
- HttpOnly cookie: set `HttpOnly=true`, `Secure=true`, `SameSite=Strict`
- Rate limiting: in-memory or Redis counter (5 failed attempts per IP/username)
- Test: valid login, wrong password, deactivated account, non-existent org

**Related:** Depends on Epic 0 (Project setup, auth)

---

#### Story 5.2: Admin First-Time Setup – Super-Admin Role Assignment

**As a** system
**I want** to assign the first admin created during org onboarding to Super-Admin role automatically
**So that** the org has a trusted admin who can invite other admins and manage the team.

**Acceptance Criteria:**
- [ ] Organization onboarding flow (triggered when org signs up):
  - [ ] Admin provides: name, email, password
  - [ ] Create admin record in database:
    ```json
    {
      "id": "admin-001",
      "orgname": "football-club",
      "name": "Sarah Jones",
      "username": "sarah@footballclub.com",
      "passwordHash": "bcrypt_hash...",
      "role": "Super-Admin",
      "isActive": true,
      "createdAt": "2025-04-01T10:00:00Z",
      "isFirstAdmin": true
    }
    ```
  - [ ] **Critical:** Automatically set `role: "Super-Admin"` and `isFirstAdmin: true`
  - [ ] Write AdminCreated event to event log with `role: "Super-Admin"`
- [ ] Verification:
  - [ ] Only one admin can have `isFirstAdmin: true` per org
  - [ ] First admin auto-assigned Super-Admin role (non-negotiable)
  - [ ] Cannot downgrade/deactivate self until another Super-Admin exists (Story 5.4)
- [ ] Email confirmation (optional for MVP, required for v1.1):
  - [ ] Send welcome email with admin dashboard link
  - [ ] Email body: "You're set up as Super-Admin for [Organization]. Log in at https://myvolunteerapp.com/admin"

**Technical Notes:**
- Org creation: separate onboarding flow, stores organization record + first admin
- Event log write: `AdminCreated` event includes adminId, role, orgname, timestamp
- Constraint: `UNIQUE (orgname, isFirstAdmin)` in database (only one per org can be true)
- Migration: if running on existing database, identify first admin by created_at, update role

**Related:** Depends on Epic 0 (Project setup)

---

#### Story 5.3: Super-Admin Invite & Invite Link Flow

**As a** super-admin
**I want** to invite other admins to join the organization
**So that** I can distribute admin responsibilities and have backup coverage.

**Acceptance Criteria:**
- [ ] Admin Dashboard > [Manage Admins] page shows:
  - [ ] List of current admins (name, role, email, status)
  - [ ] [+ Invite Admin] button
  - [ ] Form to invite: email, name, (role: Regular Admin or Super-Admin, optional)
- [ ] Invite generation:
  - [ ] Create invite record with:
    ```json
    {
      "inviteId": "invite-001",
      "email": "john@example.com",
      "invitedBy": "admin-001",
      "role": "Regular-Admin",
      "token": "unique_32_char_token",
      "expiresAt": "2025-04-03T10:00:00Z",
      "usedAt": null,
      "status": "pending"
    }
    ```
  - [ ] Token: secure random string (32 chars), expires in 24 hours
  - [ ] Write InviteSent event to event log
  - [ ] Send invitation email with link: `https://myvolunteerapp.com/admin/join?token={token}&email={email}`
- [ ] Invite email template:
  - [ ] Subject: "You're invited to be an admin for [Organization]"
  - [ ] Body: "Sarah invited you to help manage volunteers for [Organization]. Click below to set up your account (link expires in 24 hours)"
  - [ ] [Accept Invite] button (links to join page)
- [ ] Accept invite flow (Story 5.4):
  - [ ] Invited user clicks link, lands on password setup form
  - [ ] Must be first time accessing (token not yet used)
  - [ ] Sets password, confirms email, creates account
  - [ ] Token marked as used, invite status: "accepted"
- [ ] Error cases:
  - [ ] Invalid token → 401 ("Invite link invalid or expired")
  - [ ] Token already used → 403 ("Invite already accepted")
  - [ ] Email already registered → 409 ("Email already registered")
- [ ] Super-Admin only:
  - [ ] Only Super-Admin can send invites
  - [ ] Regular Admin cannot access [Manage Admins] page
  - [ ] Authorization: check role from JWT token

**Technical Notes:**
- Token generation: use `System.Security.Cryptography.RandomNumberGenerator`
- Token storage: index on `token` and `expiresAt` for lookups
- Cleanup: scheduled job to delete expired/unused invites after 7 days
- Email: async send (don't block invite creation)
- Test: valid token, expired token, already-used token, missing email param

**Related:** Depends on Story 5.1 (Auth), Story 4.1 (Email)

---

#### Story 5.4: Admin Invite Acceptance & Password Setup

**As a** invited admin
**I want** to accept the invite and set up my password
**So that** I can log in and start managing volunteers.

**Acceptance Criteria:**
- [ ] Invite acceptance endpoint `POST /api/admin/auth/accept-invite` accepts:
  ```json
  {
    "token": "unique_32_char_token",
    "email": "john@example.com",
    "name": "John Smith",
    "password": "SecurePassword123"
  }
  ```
- [ ] Server-side validation:
  - [ ] Token is valid and not expired
  - [ ] Token not already used
  - [ ] Email matches token email
  - [ ] Password meets requirements: 8+ chars, 1 uppercase, 1 number
  - [ ] Email not already registered (prevent account takeover)
  - [ ] Returns 400 (Bad Request) if validation fails
- [ ] On success (201 Created):
  - [ ] Create admin record:
    ```json
    {
      "id": "admin-002",
      "orgname": "football-club",
      "name": "John Smith",
      "username": "john@example.com",
      "passwordHash": "bcrypt_hash...",
      "role": "Regular-Admin",
      "isActive": true,
      "createdAt": "2025-04-02T10:00:00Z"
    }
    ```
  - [ ] Mark invite as used: `usedAt: now(), status: "accepted"`
  - [ ] Write AdminCreated event to event log (role: "Regular-Admin")
  - [ ] Send confirmation email: "Welcome! Your admin account is set up. Log in here: [link]"
  - [ ] Return 201 with login URL: `{ "message": "Account created. Log in here.", "loginUrl": "https://myvolunteerapp.com/admin/login" }`
- [ ] Password requirements:
  - [ ] 8+ characters
  - [ ] 1 uppercase letter (A-Z)
  - [ ] 1 number (0-9)
  - [ ] Error messages: "Password must be at least 8 characters"
- [ ] Security:
  - [ ] No plaintext password in logs
  - [ ] Invite token is single-use (marked used after acceptance)
  - [ ] Token expiry enforced (24 hours from creation)

**Technical Notes:**
- bcrypt: 12 rounds (consistent with Story 5.1)
- Token lookup: query by token + orgname (prevent cross-org token reuse)
- Email uniqueness: check both invites and admins table
- Test: valid invite, expired invite, already-used invite, password validation failures

**Related:** Depends on Story 5.3 (Invite), Story 4.1 (Email)

---

#### Story 5.5: Admin Role Management – Downgrade & Deactivation

**As a** super-admin
**I want** to manage admin roles and deactivate accounts if needed
**So that** I can control access and prevent unauthorized admins from using the system.

**Acceptance Criteria:**
- [ ] Manage Admins page allows Super-Admin to:
  - [ ] View all admins: name, email, role, status (active/inactive)
  - [ ] [Change Role] button per admin
  - [ ] [Deactivate Account] button per admin (grayed out for self)
- [ ] Downgrade Super-Admin to Regular-Admin:
  - [ ] Endpoint `PUT /api/admin/org/{orgname}/admins/{adminid}/role` with:
    ```json
    { "newRole": "Regular-Admin" }
    ```
  - [ ] **Critical validation (FR37):** Downgrade only allowed if ≥1 other Super-Admin exists
    - [ ] Count Super-Admin admins in org (where role = "Super-Admin" AND isActive = true AND id != self)
    - [ ] If count < 1: return 403 (Forbidden): "Can't downgrade. Must have at least one other Super-Admin."
  - [ ] Cannot downgrade self to Regular-Admin if self is only Super-Admin
  - [ ] On success: update role, write AdminRoleChanged event to event log
- [ ] Deactivate admin account:
  - [ ] Endpoint `DELETE /api/admin/org/{orgname}/admins/{adminid}` (soft delete)
  - [ ] **Critical: Cannot deactivate self (FR40)**
    - [ ] Check: if adminid == requestingAdminId, return 403 (Forbidden): "You can't deactivate your own account."
  - [ ] On success (200 OK):
    - [ ] Update admin record: `isActive: false`
    - [ ] Deactivated admin cannot log in
    - [ ] Write AdminDeactivated event to event log (audit trail)
    - [ ] Return: `{ "status": "deactivated", "message": "Admin account deactivated." }`
  - [ ] Verification: deactivated admin attempts login → 403 "Account deactivated"
- [ ] Role change confirmation:
  - [ ] If downgrading self: warn "This will remove your ability to invite admins. Confirm?"
  - [ ] If deactivating other: warn "[Admin Name] will no longer be able to log in. Confirm?"
- [ ] Audit trail (immutable events):
  - [ ] Event: AdminRoleChanged (includes adminId, oldRole, newRole, changedBy, timestamp)
  - [ ] Event: AdminDeactivated (includes adminId, deactivatedBy, timestamp)
  - [ ] All role changes queryable for compliance

**Technical Notes:**
- Self-prevention: compare JWT token adminId with endpoint adminId
- Super-Admin count: COUNT(*) WHERE role="Super-Admin" AND isActive=true AND orgname={org} AND id != {self}
- Soft delete: don't delete record, set isActive=false (preserves audit trail)
- Test: downgrade when 1 Super-Admin (should fail), downgrade when 2+ (should succeed), try deactivating self (should fail)

**Related:** Depends on Story 5.1 (Auth), architecture decision on role-based access control

---

### Epic 6: Admin Event & Timeslot Management
**Goal:** Admins can create events, define timeslots, set custom role names, and set capacity.

**User Outcome:** Admin creates event (date/time) → defines timeslots → sets role names (e.g., "Grill", "Canteen") → sets capacity (e.g., "2 Grill, 1 Canteen") → volunteers see slots available.

**FRs covered:** FR9, FR10, FR11, FR30
**UX-DRs covered:** UX-DR51-UX-DR57 (event creation, role definition, calendar view)
**ARs covered:** AR10 (materialized views for event display)

**Key Deliverables:**
- Event creation form (date, time, event name, description)
- Timeslot creation within event (multiple slots per event)
- Role definition interface (custom role names, 1-5 per slot)
- Capacity setting per role (number of volunteers needed)
- Event editing capability (update date/time, roles, capacity)
- Organization logo upload and display
- Event list/calendar view for admin (all upcoming events)
- Event endpoints:
  - `POST /api/admin/org/{orgname}/events` (create)
  - `PUT /api/admin/org/{orgname}/events/{eventid}` (update)
  - `GET /api/admin/org/{orgname}/events` (list)
- Event-log writes for all changes

**Acceptance Criteria (High-Level):**
- Event creation form validates required fields
- Custom role names are flexible (admins can name them anything)
- Capacity numbers enforced in signup validation
- Event edits reflected instantly in public board
- Organization logo displays on signup flow and admin dashboard
- All event data persisted to event log

**Design Reaffirmation:** Before stories, team reviews wireframes for event creation flow + admin dashboard

#### Story 6.1: Event Creation Endpoint & Form Submission

**As a** admin
**I want** to create events with date, time, and event details
**So that** volunteers can see what needs help and sign up for shifts.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/admin/org/{orgname}/events` accepts:
  ```json
  {
    "name": "Spring Cleanup & BBQ",
    "description": "Annual spring event",
    "date": "2025-04-12",
    "startTime": "09:00",
    "endTime": "17:00",
    "location": "Field House"
  }
  ```
- [ ] Server-side validation:
  - [ ] Name: 3-50 chars, required
  - [ ] Date: must be future date (not past)
  - [ ] StartTime < EndTime (same day assumed)
  - [ ] Returns 400 (Bad Request) if invalid with helpful error messages
  - [ ] Returns 409 (Conflict) if event already exists for same date/time
- [ ] On success (201 Created):
  ```json
  {
    "eventId": "evt-001",
    "name": "Spring Cleanup & BBQ",
    "date": "2025-04-12",
    "startTime": "09:00",
    "endTime": "17:00",
    "status": "created",
    "nextStep": "Define roles and capacities"
  }
  ```
- [ ] Event record created:
  - [ ] EventCreated event written to event log
  - [ ] Includes: eventId, orgname, name, date, time, createdBy (adminId), timestamp
- [ ] Event is not yet visible to volunteers (hide until slots defined, see Story 6.2)
- [ ] Authorization: Admin token required (not Super-Admin only, any admin can create)

**Technical Notes:**
- Date format: ISO 8601 (YYYY-MM-DD)
- Time format: 24-hour (HH:MM)
- Event log: EventCreated event, stored as immutable record
- Status: "created" (not visible until slots added)
- Test: valid event, past date (should fail), empty name (should fail)

**Related:** Depends on Epic 0 (Auth, Event Sourcing)

---

#### Story 6.2: Timeslot & Role Definition – Dynamic Role Creation & Capacity

**As a** admin
**I want** to define timeslots within an event and specify roles (e.g., "BBQ", "Canteen") with capacities
**So that** volunteers see exactly what roles need help and how many of each.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/admin/org/{orgname}/events/{eventid}/slots` accepts:
  ```json
  {
    "startTime": "09:00",
    "endTime": "12:00",
    "roles": [
      { "name": "BBQ", "capacity": 3 },
      { "name": "Canteen", "capacity": 2 }
    ]
  }
  ```
- [ ] Server-side validation:
  - [ ] StartTime, EndTime must be within event window (Story 6.1)
  - [ ] Roles: 1-5 per slot (min/max)
  - [ ] Role names: 2-20 chars, no special chars (alphanumeric + space/hyphen OK)
  - [ ] Capacity: 1-20 volunteers per role
  - [ ] Returns 400 if validation fails
- [ ] On success (201 Created):
  ```json
  {
    "slotId": "slot-001",
    "eventId": "evt-001",
    "startTime": "09:00",
    "endTime": "12:00",
    "roles": [
      { "name": "BBQ", "capacity": 3 },
      { "name": "Canteen", "capacity": 2 }
    ],
    "status": "active"
  }
  ```
- [ ] Slot record created:
  - [ ] SlotCreated event written to event log
  - [ ] Once slot created, event becomes visible on public volunteer board
  - [ ] Roles with their capacities stored in slot definition
- [ ] Multiple slots per event:
  - [ ] Event can have 1-10 timeslots (e.g., "morning shift", "afternoon shift")
  - [ ] Each slot can have different roles or same roles with different capacities
  - [ ] Multiple slots returned as array in `GET /api/volunteer/org/{orgname}/events/{eventid}/slots`
- [ ] Role flexibility:
  - [ ] No predefined role list (custom names only)
  - [ ] Admins can name roles anything: "Grill", "Canteen", "Setup", "Cleanup", etc.
  - [ ] Same role name in different slots counts separately (separate signups)
- [ ] Authorization: Admin token required

**Technical Notes:**
- Event visibility: event only shows on volunteer board after first slot created
- Slot ordering: returned in time order (09:00 slot before 12:00 slot)
- Event log: SlotCreated event, partition on /organizationId, /eventId
- Test: valid slot creation, invalid role count (0 or 6), invalid capacity (0 or 21), overlapping times

**Related:** Depends on Story 6.1 (Event creation)

---

#### Story 6.3: Event Editing & Capacity Adjustments

**As a** admin
**I want** to edit events, change timeslots, and adjust role capacities
**So that** I can respond to changing volunteer availability without creating duplicate events.

**Acceptance Criteria:**
- [ ] Endpoint `PUT /api/admin/org/{orgname}/events/{eventid}` accepts:
  ```json
  {
    "name": "Spring Cleanup & BBQ (UPDATED)",
    "date": "2025-04-12",
    "startTime": "08:00",
    "endTime": "18:00",
    "location": "Field House (South)"
  }
  ```
  - [ ] Update event details (name, date, time, location)
  - [ ] On success: return updated event + message "Event updated"
  - [ ] Write EventUpdated event to event log (audit trail)
- [ ] Endpoint `PUT /api/admin/org/{orgname}/events/{eventid}/slots/{slotid}` accepts:
  ```json
  {
    "roles": [
      { "name": "BBQ", "capacity": 4 },
      { "name": "Canteen", "capacity": 2 }
    ]
  }
  ```
  - [ ] Update role capacities
  - [ ] Cannot remove roles (existing signups would be orphaned)
  - [ ] Can increase or decrease capacity
  - [ ] Write SlotUpdated event to event log
- [ ] Capacity adjustment rules:
  - [ ] Can increase capacity without limit (add more spots)
  - [ ] Can decrease capacity only if new capacity ≥ current volunteer count
    - [ ] Example: if 2 volunteers already signed up for BBQ, cannot set capacity to 1
    - [ ] Return 409 (Conflict) if invalid: "Can't reduce to 1 capacity. Already 2 volunteers signed up."
  - [ ] Can add new roles to slot (e.g., add "Parking" if not already present)
  - [ ] Cannot remove roles (would violate existing signups)
- [ ] Changes reflected instantly on volunteer board (via Epic 3 real-time)
- [ ] Authorization: Admin token required

**Technical Notes:**
- Validation: when decreasing capacity, count current volunteers for that role in slot
- Event log: EventUpdated + SlotUpdated events preserve full edit history
- Volunteer board: receives delta update (changed slot) via WebSocket
- Test: increase capacity, decrease capacity (valid), decrease capacity (invalid, too low)

**Related:** Depends on Story 6.1, 6.2 (Event/slot creation), Epic 3 (Real-time)

---

### Epic 7: Admin Volunteer Management (Manual Actions)
**Goal:** Admins can manually add, reassign, and remove volunteers to adjust coverage.

**User Outcome:** Admin clicks [ + Add Volunteer ] → enters name/phone/email → assigns to event/role → volunteer appears on roster instantly. Admin can reassign volunteer between roles or remove them.

**FRs covered:** FR13, FR14, FR15
**UX-DRs covered:** UX-DR58-UX-DR65 (add form, reassign, remove flows)
**NFRs addressed:** NFR16-NFR23 (concurrency safe, idempotent)

**Key Deliverables:**
- Add volunteer form (name, phone, email, event select, role select)
- Add volunteer endpoint (`POST /api/admin/org/{orgname}/volunteers`)
- Reassign volunteer endpoint (`PUT /api/admin/org/{orgname}/volunteers/{volunteerid}`)
- Remove volunteer endpoint (`DELETE /api/admin/org/{orgname}/volunteers/{volunteerid}`)
- All actions trigger event-log writes
- All changes reflected in real-time roster (via Epic 3 WebSocket)
- Volunteer detail view (full contact info, edit/reassign/remove options)

**Acceptance Criteria (High-Level):**
- Add volunteer form validates all fields
- Added volunteer appears on roster instantly
- Reassign updates role without losing volunteer
- Remove deletes volunteer from roster instantly
- All actions are idempotent (retries don't create duplicates)
- All changes logged to event log (audit trail)

**Design Reaffirmation:** Before stories, team reviews wireframes for add/reassign/remove flows

#### Story 7.1: Add Volunteer Endpoint & Form – Manual Signup

**As a** admin
**I want** to manually add a volunteer to an event/role
**So that** I can fill gaps when no one signs up online or when offline volunteers need entry.

**Acceptance Criteria:**
- [ ] Endpoint `POST /api/admin/org/{orgname}/volunteers` accepts:
  ```json
  {
    "name": "Jane Doe",
    "phone": "555-234-5678",
    "email": "jane@example.com",
    "team": "Youth Team",
    "eventId": "evt-001",
    "slotId": "slot-001",
    "role": "Canteen"
  }
  ```
- [ ] Server-side validation:
  - [ ] Name: 2+ chars, required
  - [ ] Phone: 10+ digits, required
  - [ ] Email: valid format, required
  - [ ] Team: optional
  - [ ] Event + Slot + Role: must exist and match
  - [ ] Capacity check: if role at capacity, return 409 (Conflict): "Canteen is full (2/2). Can't add more."
  - [ ] Duplicate check: if same volunteer (phone) already signed up for this slot/role, return 409: "Already signed up"
- [ ] On success (201 Created):
  ```json
  {
    "signupId": "signup-003",
    "status": "confirmed",
    "message": "Jane Doe added to Canteen for April 12",
    "volunteerName": "Jane Doe",
    "role": "Canteen",
    "position": 2,
    "capacity": 2
  }
  ```
- [ ] Volunteer signup recorded:
  - [ ] SignupCreated event written to event log
  - [ ] Event includes: volunteerName, phone, email, team, slotId, eventId, addedBy (adminId), timestamp
  - [ ] Note: `addedBy` field marks as admin-added (not self-service)
- [ ] Real-time updates:
  - [ ] Volunteer appears on admin roster instantly (via Epic 3 WebSocket)
  - [ ] Volunteer count increases on volunteer board (via Epic 3)
  - [ ] No email sent to volunteer (they were added offline, optional v1.1 feature)
- [ ] Authorization: Admin token required

**Technical Notes:**
- Event log: SignupCreated event with `source: "admin"` field to distinguish from self-service signups
- Capacity check: query event log for existing SignupCreated events for this slot/role, count active signups
- Phone matching: normalize phone (remove formatting) before duplicate check
- Test: valid add, duplicate phone, slot full, invalid email

**Related:** Depends on Epic 0 (Auth, Event Sourcing), Story 6.2 (Slot/role definition)

---

#### Story 7.2: Reassign Volunteer – Change Role or Timeslot

**As a** admin
**I want** to move a volunteer from one role to another (or to a different timeslot)
**So that** I can adjust coverage on the fly if a volunteer prefers a different role.

**Acceptance Criteria:**
- [ ] Endpoint `PUT /api/admin/org/{orgname}/volunteers/{volunteerid}` accepts:
  ```json
  {
    "slotId": "slot-002",
    "role": "BBQ"
  }
  ```
  - [ ] Can change both slot and role, or just role
  - [ ] New slot and role must exist and match
- [ ] Server-side validation:
  - [ ] Volunteer exists in event log
  - [ ] New slot/role exists and is valid
  - [ ] New role has capacity (don't move to full slot)
  - [ ] Volunteer isn't already in new slot/role (prevent duplicate)
- [ ] On success (200 OK):
  ```json
  {
    "status": "reassigned",
    "message": "Jane Doe moved from Canteen to BBQ",
    "oldRole": "Canteen",
    "newRole": "BBQ",
    "oldPosition": 2,
    "newPosition": 2,
    "eventDate": "2025-04-12"
  }
  ```
- [ ] Event log record:
  - [ ] Write VolunteerReassigned event (immutable record)
  - [ ] Includes: signupId, oldSlotId, newSlotId, oldRole, newRole, reassignedBy (adminId), timestamp
- [ ] Real-time updates:
  - [ ] Volunteer removed from old role on roster (fade out)
  - [ ] Volunteer added to new role on roster (fade in)
  - [ ] Slot counts update (old role capacity increases, new role decreases)
  - [ ] No email sent to volunteer (optional v1.1)
- [ ] Authorization: Admin token required

**Technical Notes:**
- Event log: VolunteerReassigned event (conceptually: old SignupCreated + new SignupCreated in same transaction)
- Capacity check: count active signups for new role after this operation
- Test: reassign to different role, reassign to different slot, reassign to full role (should fail), reassign to self (should fail with message)

**Related:** Depends on Epic 0 (Event Sourcing), Story 7.1 (Signup management)

---

#### Story 7.3: Remove Volunteer – Delete Signup

**As a** admin
**I want** to remove a volunteer from an event
**So that** the slot becomes available for someone else (e.g., if volunteer cancels via phone or no-shows).

**Acceptance Criteria:**
- [ ] Endpoint `DELETE /api/admin/org/{orgname}/volunteers/{volunteerid}?slotId={slotid}` removes volunteer
- [ ] Server-side validation:
  - [ ] Volunteer exists in event log
  - [ ] Volunteer is actually signed up for this slot (prevent orphan deletes)
- [ ] On success (200 OK):
  ```json
  {
    "status": "removed",
    "message": "Jane Doe removed from Canteen",
    "volunteerName": "Jane Doe",
    "role": "Canteen",
    "eventDate": "2025-04-12"
  }
  ```
- [ ] Event log record:
  - [ ] Write CancelledSignup event (immutable, marks signup as cancelled)
  - [ ] Includes: signupId, role, removedBy (adminId), reason (optional, e.g., "No-show"), timestamp
  - [ ] Note: don't delete, just mark cancelled in event log
- [ ] Volunteer removed from roster:
  - [ ] Name disappears from role list (fade out animation)
  - [ ] Slot count decreases (role now has 1 open)
  - [ ] Slot capacity updated (highlight reopened slot green)
  - [ ] Real-time updates via Epic 3 WebSocket
- [ ] No email sent to volunteer (they were removed by admin, optional notification v1.1)
- [ ] Authorization: Admin token required

**Technical Notes:**
- Event log: CancelledSignup event, soft-delete semantics (record marked cancelled, not deleted)
- Slot availability: recount volunteers for role, show new capacity
- Test: valid removal, non-existent volunteer (should fail with 404), invalid slotId (should fail with 400)

**Related:** Depends on Epic 0 (Event Sourcing), Story 7.1 (Volunteer management), Epic 3 (Real-time)

---

## FR Coverage Map

FR1: Epic 1 (Volunteer board display with real-time capacity)
FR2: Epic 1 (Signup form submission)
FR3: Epic 4 (Email confirmation with calendar invite)
FR4: Epic 2 (Self-service cancellation)
FR5: Epic 2 (Public board filtering by name)
FR6: Epic 2 (2-day cancellation blocking)
FR7: Epic 1 & Epic 3 (Real-time slot updates)
FR8: Epic 2 (View all signups)
FR9: Epic 6 (Event creation)
FR10: Epic 6 (Timeslot and custom role definition)
FR11: Epic 6 (Capacity setting per role)
FR12: Epic 3 (Admin roster with real-time updates)
FR13: Epic 7 (Manual volunteer add)
FR14: Epic 7 (Volunteer reassignment)
FR15: Epic 7 (Volunteer removal)
FR16: Epic 5 (Username + password authentication)
FR17: Epic 5 (Super-Admin invite flow)
FR19: Epic 5 (First admin auto-Super-Admin)
FR20: Epic 3 (Real-time roster updates)
FR21: Epic 0 (Encryption at rest via CosmosDB)
FR22: Epic 5 (Bcrypt password hashing)
FR23: Epic 0 (Data deletion capability - user-initiated request)
FR24: Epic 0 (Privacy policy documentation)
FR25: Epic 1 (First name + last initial on public board)
FR26: Epic 0 (Admin contact info never shared publicly)
FR27: Epic 0 (Multi-tenant isolation - separate DB per org)
FR28: Epic 0 (Organizations cannot access each other's data)
FR29: Epic 0 (Unique URL per organization)
FR30: Epic 6 (Organization logo upload and display)
FR31: Epic 4 (Email confirmations)
FR32: Epic 4 (RFC 5545 calendar invites)
FR33: Epic 4 (Calendar integration - Outlook/Google/Apple)
FR34: Epic 4 (SMS confirmations - v1.1+, not MVP)
FR35: Epic 4 (Reminder notifications - v1.1+, not MVP)
FR36: Epic 5 (Reassignment notifications - v2, not MVP)
FR37: Epic 5 (Super-Admin downgrade with constraint)
FR38: Epic 5 (Super-Admin downgrade with constraint - explicit requirement)
FR39: Epic 5 (Super-Admin can deactivate other admins)
FR40: Epic 5 (Super-Admin cannot deactivate themselves)

**All 40 FRs mapped to epics. ✅**
