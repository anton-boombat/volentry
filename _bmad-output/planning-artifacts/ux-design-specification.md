---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-03-core-experience", "step-04-emotional-response", "step-05-inspiration-and-screens"]
inputDocuments: ["/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/prd.md", "/Users/anton/Repos/omegasq/sign-up/_bmad-output/planning-artifacts/architecture.md"]
---

# UX Design Specification - Volunteer Signup Platform

**Author:** Anton
**Date:** 2026-03-29

---

## Executive Summary

### Project Vision

**Volunteer Signup Platform** is a multi-tenant SaaS designed to democratize volunteer recruitment through radical simplicity. The core insight: volunteers want to help but lack visibility into opportunities. By removing friction—no login, no forms, just "click slot → fill minimal info → done"—the platform transforms volunteer recruitment from a push (hard to find) to pull (easy to discover).

**Radical Simplicity Philosophy:** No dashboards, no approvals, no training. Volunteers don't need accounts. The entire signup flow is 3 clicks. Simplicity is the competitive advantage.

### Target Users

**Volunteers:** Parents, community members, athletes—people who want to help but need visibility into opportunities. Primarily desktop and mobile via shared social links (Facebook, WhatsApp). Tech-savvy to non-tech-savvy. Motivation: social contribution, flexibility, minimal friction.

**Club Admins:** Volunteer coordinators managing small groups (10-50 regular volunteers). Desktop-primary. Motivation: ease of signup management, real-time coverage visibility, no complicated training.

**Club Leadership:** Want simple digital replacement for paper signup sheets. Minimal interaction with platform (mostly receive shared link and trust admins).

### Key UX Design Challenges

1. **Extreme Simplicity Under Complexity:** Backend is complex (event sourcing, queues, real-time), but UX must hide all this. Volunteers see only: events → click → confirm. Admin must see control without overwhelm.

2. **Real-Time Reliability Perception:** Volunteers see real-time slot availability. Concurrent signups can feel "laggy" if not handled well. Need clear feedback: "Signing up..." → "Confirmed!" or "Sorry, someone beat you!" Race conditions must feel fair, not broken.

3. **2-Day Cancellation Guardrail:** Hard rule: can't cancel within 2 days. Must be obvious at signup time and when blocked. Clear messaging prevents frustration.

4. **Zero Login Friction for Volunteers:** No email verification, no password, no account creation. But admin needs full contact info. Trust challenge: how do we trust volunteer identity without authentication?

5. **Mobile-First Accessibility:** Volunteers access via shared social links on mobile. Must be thumb-friendly, fast, minimal typing. Admin dashboard can be desktop-focused.

### Design Opportunities

1. **Obvious Availability at a Glance:** Show slots visually: [John S.] [Open] [Open]. Volunteers know instantly if room. Real-time updates make slots disappear/reappear as people sign up.

2. **Joyful Confirmation:** Calendar invite + email creates "permanent" feeling. Admin sees their name instantly on roster (validation moment).

3. **Transparent Concurrency:** When 5 people click for last slot, show "4 others clicked too. Slot filled by 12:34:56pm. Try another time!" Makes race feel fair, not broken.

4. **Admin Dashboard as Club Command Center:** Coverage status view—which slots are full? any emergencies (short-staffed)? Real-time roster updates give live feedback.

5. **Trust Through Transparency:** Show who's signed up (first name + last initial) to build social proof: "John S., Sarah M., and 3 others signed up."

---

## Core User Experience

### Defining Experience

**The ONE thing that defines success:** A volunteer discovers an available slot and commits to it in under 2 minutes, with zero barriers.

The core product loop:
1. Volunteer sees event via shared link
2. Volunteer clicks a slot they can fill
3. Volunteer submits minimal info (name, phone, email, optional team)
4. Volunteer gets confirmation email + calendar invite
5. Volunteer is on the roster, commitment made

Everything else (admin management, real-time updates, 2-day guardrails) exists to make this loop effortless.

### Platform Strategy

**Primary Platform:** Responsive web application (desktop + mobile)
- Accessed via shared link (no app install required)
- Mobile-first design (thumb-friendly, fast)
- Optimized for both desktop (admin dashboard) and mobile (volunteer signup)
- No native app: Shared links are more frictionless than app downloads
- Admin dashboard: Desktop-optimized but functional on tablet

**Key Platform Constraint:** Zero friction means instant load (<2s), no logins, no email verification

### Effortless Interactions

**Volunteer Experience:**

1. **Finding Your Slot:** Board shows upcoming events with role names and availability instantly. "I see Canteen (2 spots), BBQ (full), Grounds (1 spot)." No clicking through menus.

2. **Signing Up:** Click slot → fill form (4 fields: name, phone, email, team) → confirm. No email verification, no "check your email," no confirmation page. Done in 90 seconds.

3. **Knowing You're Signed Up:** Calendar invite appears in email immediately (<10 seconds). Phone + email on file (admin can contact if needed). Peace of mind.

4. **Cancelling (If Needed):** Filter board by name to find your signup. Click cancel. Confirmation dialog. Done. (Unless within 2 days—then clear message: "Contact admin.")

5. **Real-Time Feedback:** When you sign up, slot count updates instantly on other screens. You see "now 1/2 available" → watch it become "2/2 full" as others commit. Feels alive.

**Admin Experience:**

6. **Coverage at a Glance:** Login → dashboard shows all events and coverage status. Red if short-staffed, green if full. No hunting for data.

7. **Real-Time Roster:** Admin roster updates live. When a volunteer signs up, their name appears instantly. When they cancel, they disappear instantly. Transparency.

8. **Quick Actions:** Click to view full contact info, add volunteer manually, reassign roles, remove volunteer. Minimal page loads.

### Critical Success Moments

**The Share Moment**
- Club admin sends link to volunteers
- Load time <2s, design is professional, volunteers immediately see what's needed
- If slow or confusing, they won't sign up

**The Signup Moment**
- Volunteer clicks slot → form appears instantly (no loading)
- Form is 4 fields only, validation is instant and helpful
- "Confirm" button is clear and large
- If clunky, volunteers bounce

**The Confirmation Moment**
- Email arrives in <10 seconds with calendar invite
- Volunteer clicks "add to calendar" and it works (Outlook, Google, Apple Calendar)
- This is the trust moment—they know they're committed

**The Admin Coverage Moment**
- Admin logs in, sees clear picture of coverage
- "3 slots short" is obvious, no guessing
- If takes 30 seconds to understand, admin won't use it

**The Live Moment**
- Volunteer watches board, sees "Sarah M. just signed up for Canteen"
- Slot count changes from "2/2" to "full"
- Real-time feel makes it trustworthy

**The Cancellation Block Moment**
- Volunteer tries to cancel within 2 days
- Clear message: "You're committing through Saturday. Contact the admin if something changed."
- Not punitive, just clear about the rule

### Experience Principles

**1. Zero Friction Over Feature Richness**
- Every design asks: "Can this friction be eliminated?"
- 3-field form beats 6-field form, even if we want more data
- Trust through simplicity, not comprehensive data collection

**2. Transparency Over Automation**
- Volunteers always know: who's signed up, how many spots left, when they're committed
- No hidden rules or surprise constraints
- "You'll commit to this date" is obvious at signup

**3. Real-Time Builds Trust**
- Slot counts update live, admin roster updates live, cancellations remove you instantly
- Not "refresh your browser"—changes appear automatically
- Real-time = feels professional and honest

**4. Success Moments Are Sacred**
- Calendar invite must be perfect
- Confirmation email must arrive instantly (<10 seconds)
- Signup confirmation must be unambiguous ("You're signed up!")
- Don't ruin these with ads, upsells, or extra clicks

**5. One-Time Users Matter**
- Many volunteers use this once per event
- Experience must feel obvious without onboarding
- First-time user success > experienced user power
- If someone can't figure out signup in 30 seconds, the product failed

---

## Desired Emotional Response

### Primary Emotional Goals

**Volunteer Experience:**

1. **Confident & Capable** — "I can do this. This is easy. I know exactly what I'm committing to."
   - Landing on the board, volunteers should feel "I understand this immediately"
   - Signing up, they should feel "This is simple enough for me"
   - Confirming, they should feel "I'm in. This is real. I'm committed."

2. **Valued & Included** — "My help matters. Others are counting on me. I'm part of a team."
   - Seeing other volunteers' names ("John S., Sarah M.") builds social proof
   - Real-time slot updates show "the community is signing up"
   - Confirmation email creates "I'm on the official roster" feeling

3. **Trust & Transparency** — "I know what's happening. No surprises. They're being honest with me."
   - Clear rules: "Can't cancel within 2 days" is obvious at signup
   - Real-time updates show what's actually happening (not fake scarcity)
   - Contact info on file means "they can reach me if needed"

4. **Calm & Frictionless** — "Nothing is stressing me out. This doesn't require thought."
   - Fast load (no anxiety about waiting)
   - Simple form (no decision fatigue)
   - Instant email confirmation (no uncertainty about whether it worked)

**Admin Experience:**

5. **In Control & Informed** — "I know exactly what the coverage situation is. I can make decisions."
   - Dashboard gives complete picture instantly ("3 slots short" is obvious)
   - Real-time roster shows who's signed up right now
   - Quick actions (add volunteer, reassign, remove) feel responsive

6. **Relieved & Confident** — "This is so much easier than paper sheets. I've got this."
   - No more spreadsheets or email chains
   - Real-time updates mean no surprises on event day
   - Contact info means volunteers can't flake without admin knowing

### Emotional Journey Mapping

**Volunteer's Emotional Arc:**

| Stage | Emotion | Design Support |
|-------|---------|-----------------|
| **Discovery** | Intrigued, hopeful | Fast load, clear event list, obvious how to help |
| **Exploring Slots** | Confident, capable | Visual slot availability, role names clear, "Open" vs "Full" obvious |
| **Filling Form** | Calm, focused | Minimal fields, helpful validation, large confirm button |
| **Confirming** | Accomplished, committed | Clear confirmation message, calendar invite arriving instantly |
| **After Signup** | Reassured, proud | Email shows commitment, can find themselves on roster |
| **Before Event** | Prepared, confident | Calendar reminder, can still find their signup |
| **Cancelling (if needed)** | Understood/frustrated | Clear if <2 days, helpful if >2 days (clear message, no punishment feel) |

**Admin's Emotional Arc:**

| Stage | Emotion | Design Support |
|-------|---------|-----------------|
| **Login** | Hopeful, ready | Quick authentication, instant dashboard load |
| **Viewing Coverage** | Informed, confident | Coverage status obvious at a glance (red=short, green=full) |
| **During Event** | Calm, in-control | Real-time updates show signups/cancellations as they happen |
| **Adjusting Coverage** | Empowered | Quick add/reassign/remove, instant roster update |
| **After Event** | Satisfied | It worked smoothly, no stress |

### Micro-Emotions

**Confidence vs. Confusion**
- ✅ Volunteers feel confident (obvious role names, clear slot counts)
- ❌ Avoid confusion (no unclear abbreviations, no hidden rules)

**Trust vs. Skepticism**
- ✅ Volunteers trust the system (show who's signed up, calendar invites work perfectly)
- ❌ Avoid skepticism (no fake scarcity, no bait-and-switch)

**Excitement vs. Anxiety**
- ✅ Real-time updates create excitement (live slot counts update instantly)
- ❌ Avoid anxiety (clear "Signing up..." loading state)

**Accomplishment vs. Frustration**
- ✅ Successful signup feels accomplished (celebration message, instant email, clear roster appearance)
- ❌ Avoid frustration (never lose form data on validation fail, never surprise with rules)

**Delight vs. Satisfaction**
- ✅ Calendar invites working perfectly = delight moment
- ✅ Real-time roster updates = delightful (smooth animations, instant changes)
- ✅ Satisfactory at minimum (no delight OK, but delight elevates word-of-mouth)

**Belonging vs. Isolation**
- ✅ Seeing other volunteers' names creates belonging ("John S., Sarah M., and 2 others")
- ✅ Social proof builds commitment (visible roster, not hidden)
- ❌ Avoid isolation (never make signup feel lonely or uncertain)

### Emotional Design Principles

**1. Confidence Through Clarity**
- Every screen answers: "What should I do next?" without ambiguity
- Error messages are helpful, not punitive
- Rules are obvious before you break them

**2. Trust Through Transparency**
- Real-time updates show actual state (not fake or delayed)
- Who's signed up is visible, not hidden
- Rules and constraints are stated upfront

**3. Accomplishment Through Immediate Feedback**
- Confirmation message is unambiguous ("You're signed up!")
- Calendar invite arrives instantly
- Volunteer appears on roster immediately (not after refresh)

**4. Belonging Through Community Visibility**
- Other volunteers' names are visible (first name + last initial)
- Social proof ("4 others signed up") builds commitment
- Roster shows the team is coming together

**5. Calm Through Simplicity**
- Minimal form fields (only what's essential)
- Fast load times (no waiting = no anxiety)
- Clear loading states (user knows something is happening)

**6. Control Through Information**
- Admin sees complete picture instantly (coverage status obvious)
- Real-time updates prevent surprises
- Quick actions (add/assign/remove) feel responsive

---

## Inspiration Analysis & Screen Flows

### Reference Products & What Works

**SignUpGenius (Existing Competitor)**
- ✅ Simple signup flow
- ✅ Clear event listing
- ❌ **Problem:** Past slots remain visible (clunky UX)
- ❌ **Problem:** No real-time updates (feels dated)
- ❌ **Problem:** Too much cognitive load for one-time users
- **Lesson:** Remove past slots aggressively, add real-time feel

**Calendly (Inspiration for Simplicity)**
- ✅ Minimal form fields
- ✅ Instant confirmation
- ✅ Calendar integration feels magical
- ✅ One-click scheduling (no account needed)
- **Lesson:** Frictionless interactions = success; calendar invites are trust-building

**Eventbrite Ticketing**
- ✅ Clear availability display ("4 seats left")
- ✅ Visual confirmation of purchase
- ✅ Instant email confirmation
- ❌ **Problem:** Too many fields for simple volunteer signup
- **Lesson:** Keep forms minimal; ticket-like confirmation feels official

**Figma Collaboration (Real-Time Inspiration)**
- ✅ Real-time updates feel magical ("Sarah M. is editing...")
- ✅ Presence indicators build trust
- ✅ Changes appear instantly without refresh
- **Lesson:** Real-time = professional, trustworthy, modern

**WhatsApp/iMessage (Mobile Simplicity)**
- ✅ Thumb-friendly interface
- ✅ Large tap targets
- ✅ No horizontal scrolling
- ✅ Fast loading (<1s)
- **Lesson:** Mobile-first means generous spacing, vertical scrolling only

### Key Design Patterns

**Pattern 1: Slot Availability Display**

Two competing approaches tested with users:

**Option A - Card Layout (Recommended)**
```
Event: BBQ Volunteer Shift
Date: Saturday, April 12 | 10:00am - 2:00pm

[Card 1: Role=Grill]
John S. | Sarah M. | [Open] → FULL
1/3 → 2/3 → 3/3

[Card 2: Role=Canteen]
[Open] | [Open] | [Open]
0/3 → [Click here to sign up]

[Card 3: Role=Setup]
[Open]
1/1 available
```

**Why Card Layout Wins:**
- One role per card = clear cognitive load
- Visual slot display (names + open slots) is scannable
- Real-time updates per card are smooth
- Mobile: each card fits one screen without scrolling
- Tap target (whole card) is large and thumb-friendly

**Option B - Table Layout (Alternative)**
| Role | Slot 1 | Slot 2 | Slot 3 | Available |
|------|--------|--------|--------|-----------|
| Grill | John S. | Sarah M. | Full | 0 |
| Canteen | Open | Open | Open | 3 |

**Why Table Loses:**
- Requires horizontal scroll on mobile
- All roles on one screen = cognitive overload
- Hard to click on "Open" slot (small tap target)
- Real-time updates feel jumpy (whole table refreshes)

**Decision:** **Card layout is primary.** Table as admin-only dashboard option.

---

**Pattern 2: Signup Form (Mobile-First)**

```
┌─────────────────────────────┐
│  SIGNING UP FOR:            │
│  Grill • Saturday, April 12 │
│  10:00am - 2:00pm          │
└─────────────────────────────┘

Name
[________________]

Phone
[________________]

Email
[________________]

Team (Optional)
[________________]

[     SIGN ME UP     ]

☑ I can't cancel within 2 days
  (clear checkbox, high visibility)
```

**Design Rules:**
- Field labels are always visible (not floating)
- Input fields are large (44px+ tap target per iOS guidelines)
- Validation happens on blur (helpful, not punitive)
- Error messages appear below field in red (constructive tone: "Name should be 2+ characters")
- Checkbox for 2-day rule is high-contrast (red if unchecked)
- CTA button is always at bottom (sticky on mobile)
- Form fits one viewport without scrolling (minimize scrolling friction)

**Mobile-First Specifics:**
- Portrait orientation only
- One form column (no side-by-side fields)
- Email field shows keyboard: type=email (mobile browser recognizes)
- Phone field shows numeric keyboard: type=tel
- Confirm button is full width (larger tap target)

---

**Pattern 3: Confirmation States**

**Loading State (Real-Time Trust)**
```
┌──────────────────────────────┐
│  ⏳ Signing you up...         │
│                              │
│  (Spinning indicator)        │
│                              │
│  Please wait 2-3 seconds     │
└──────────────────────────────┘
```

**Success State (Unambiguous)**
```
┌──────────────────────────────┐
│  ✓ You're signed up!          │
│                              │
│  Sarah M., you're confirmed  │
│  for Grill, Saturday 10am   │
│                              │
│  📧 Email sent (check inbox) │
│  📅 Calendar invite attached │
│                              │
│  [ See all my signups ]      │
│  [ Back to board ]           │
└──────────────────────────────┘
```

**Failure State (Fair & Clear)**
```
┌──────────────────────────────┐
│  ⚠ Slot filled!              │
│                              │
│  4 others clicked too.       │
│  Slot was taken at 2:34pm   │
│                              │
│  [ Try another time ]        │
│  [ Back to board ]           │
└──────────────────────────────┘
```

**2-Day Cancellation Block (No Punishment Feel)**
```
┌──────────────────────────────┐
│  ⏸ Can't cancel              │
│                              │
│  You committed through       │
│  Saturday. Contact the admin │
│  if something changed:       │
│                              │
│  📞 (555) 123-4567          │
│  📧 admin@club.org          │
│                              │
│  [ Go back ]                 │
└──────────────────────────────┘
```

---

**Pattern 4: Admin Dashboard Coverage View**

```
ADMIN DASHBOARD

Welcome back, Sarah!  [Logout]

═══════════════════════════════════════

COVERAGE STATUS

🔴 Saturday, April 12
   3 slots short (5/8 filled)
   [View details ▼]

🟢 Sunday, April 13
   All slots filled (12/12)

─────────────────────────────────────

QUICK ACTIONS
[ + Add Volunteer ]  [ 📊 Full Report ]

═══════════════════════════════════════

LIVE ROSTER (Real-time)

Grill (2/3)
├─ John Smith  • 555-1234
├─ Sarah Miller • 555-5678
└─ [1 spot open]

Canteen (3/3) [FULL]
├─ Mike Johnson
├─ Lisa Wong
└─ Tom Brady

Setup (0/1)
└─ [1 spot open] ← URGENTLY NEEDED
```

**Admin Dashboard Design Rules:**
- Coverage status is color-coded (red=short, yellow=at-capacity, green=full)
- Shortfalls are obvious ("3 slots short" in bold)
- Live roster updates as volunteers sign up (no refresh needed)
- Quick actions are sticky at top (always accessible)
- Detailed view (click event) shows full contact info + ability to remove/reassign

---

### Critical Screen Flows

**Flow 1: Volunteer Signup (Happy Path)**

```
1. [Share Link] → Volunteer receives shared link via WhatsApp
   ↓
2. [Landing Board] → Fast load (<2s), sees events + slots
   Mobile: Cards show roles + availability
   Desktop: Cards + sidebar with event info
   ↓
3. [Click Slot] → Taps "Open" slot for Grill
   ↓
4. [Signup Form] → Modal/fullscreen form appears instantly
   ↓
5. [Fill Form] → Name, phone, email, team
   Validation on blur (helpful, not punitive)
   ↓
6. [Confirm] → Clicks "Sign Me Up" button
   ↓
7. [Loading] → Shows "Signing you up..." with spinner
   ↓
8. [Success] → "You're signed up!" confirmation
   Shows: Name confirmed, role, time, calendar + email
   ↓
9. [Post-Signup] → Volunteer can:
   - [ Back to board ] (find more slots)
   - [ See all my signups ] (view their commitments)
   
10. [Email/Calendar] → Confirmation arrives in <10s
    - Email: Confirmation + calendar (.ics) attachment
    - Calendar app: Click "Add to Calendar" → syncs with Outlook/Google/Apple
```

**Flow 2: Volunteer Cancel (2-Day Block)**

```
1. [See My Signups] → Volunteer clicks "My Signups" link on board
   ↓
2. [My Roster] → Shows all signups with dates
   Sarah M. - Grill, Saturday April 12, 10am [Cancel]
   ↓
3. [Click Cancel] → Taps "Cancel" button
   ↓
4A. [If >2 days away]
   ↓
5A. [Confirm Cancel] → "Are you sure?" dialog
   ↓
6A. [Success] → "Cancelled. Admin notified."
   Volunteer removed from roster instantly (real-time)
   
4B. [If <2 days away]
   ↓
5B. [Can't Cancel] → "You committed through Saturday.
                       Contact admin if something changed."
   Shows admin contact info
```

**Flow 3: Admin Adds Volunteer Manually**

```
1. [Admin Dashboard] → Logs in, sees coverage status
   ↓
2. [Add Volunteer] → Clicks "+ Add Volunteer"
   ↓
3. [Select Event & Role] → Picks "Saturday BBQ" → "Grill"
   ↓
4. [Enter Contact] → Name, phone, email
   ↓
5. [Confirm] → Submits
   ↓
6. [Success] → Volunteer appears on roster instantly
   Optional: Send email notification to volunteer
```

---

### Component Patterns

**Button Styles**
- **Primary CTA:** Full width, large (44px+), blue background, white text
  - Used for: "Sign Me Up", "Add Volunteer"
- **Secondary:** Outlined, normal size
  - Used for: "Cancel", "Go Back"
- **Destructive:** Red background, for removal actions
  - Used for: "Remove Volunteer" (admin only)

**Form Validation**
- Field shows ✓ on blur if valid (green checkmark, subtle)
- Error shows below field in red on blur if invalid
- Error messages are constructive: "Name should be 2+ characters" (not "Invalid name")
- Checkbox for 2-day rule: Required, high visibility

**Real-Time Indicators**
- Live roster shows "(Just now)" next to new signups
- Live slot counts update instantly without page refresh
- Admin sees presence of other admins: "Sarah is viewing this event"

**Loading States**
- Spinner appears only during actual wait (not on form blur)
- Loading message is clear: "Signing you up...", not just spinner
- Timeout gracefully: After 10s, show "Taking longer than expected. Please wait."

---

### Responsive Breakpoints

**Mobile (< 768px) - Primary**
- Volunteer board: Full-width cards, stacked vertically
- Forms: Full-screen modals or page transitions
- No horizontal scrolling
- Large tap targets (44px+ minimum)

**Tablet (768px - 1024px)**
- Volunteer board: Two-column card layout
- Admin dashboard: Side panel + main view
- Readable text size maintained

**Desktop (> 1024px)**
- Volunteer board: Multi-column grid or hybrid card + table
- Admin dashboard: Full sidebar + detailed main view
- Optional: Table view of slots for power users

---

## Summary: Design Decisions Locked In

✅ **Volunteer Experience:**
- Card-based slot layout (not table)
- Mobile-first, responsive design
- No login friction (minimal form, no email verification)
- Instant email + calendar confirmation
- Real-time roster visibility
- 2-day cancellation guardrail shown upfront

✅ **Admin Experience:**
- Coverage status dashboard (color-coded)
- Real-time roster updates
- Quick manual add/remove/reassign
- Desktop-optimized, tablet-friendly

✅ **Emotional Goals:**
- Confidence through clarity
- Trust through transparency
- Accomplishment through immediate feedback
- Belonging through community visibility
- Calm through simplicity
- Control through information

✅ **Technical Integration Points:**
- Confirmation email triggers from VolunteerService
- Real-time updates via Azure SignalR (or WebSocket fallback)
- Calendar .ics generation in email service
- Contact info validation at signup (helpful, not punitive)

---
