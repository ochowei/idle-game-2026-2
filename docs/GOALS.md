# Idle Game 2026 — Project Goals

> **Last Updated:** 2026-03-04
> **PM:** Claude (AI PM) | **Coder:** Claude (AI Engineer) | **Admin:** Human

---

## 1. Project Overview

**Idle Game 2026** is a browser-based idle/incremental game. Players earn currency through simple interactions (clicking), purchase upgrades and automated generators, and watch their empire grow — even while away. The game features a layered progression system with prestige mechanics to provide long-term engagement.

### Tech Stack (Proposed)

| Layer        | Technology                  |
| ------------ | --------------------------- |
| Frontend     | HTML5 + CSS3 + Vanilla JS (or lightweight framework) |
| Game Engine  | Custom JS game loop         |
| Persistence  | LocalStorage / IndexedDB    |
| Build Tool   | Vite (or plain static)      |
| Deployment   | GitHub Pages / Static host  |

### Team & Workflow

- **Human Admin** — Owns the repository, reviews PRs, makes final product decisions.
- **PM (Claude)** — Plans sprints, maintains GOALS.md, breaks down features, tracks progress.
- **Coder (Claude)** — Implements features, writes tests, submits code for review.

---

## 2. Hierarchical Goals (Epic → Feature → Task)

Status legend: `[TODO]` | `[IN PROGRESS]` | `[DONE]`

---

### Epic 1: Project Scaffolding & Dev Environment

> Set up the foundational project structure, tooling, and development workflow.

#### Feature 1.1: Repository & Project Structure

- `[TODO]` **Task 1.1.1** — Initialize `package.json` with project metadata and scripts
- `[TODO]` **Task 1.1.2** — Create directory structure (`src/`, `src/css/`, `src/js/`, `public/`, `docs/`)
- `[TODO]` **Task 1.1.3** — Set up build tooling (Vite or equivalent)
- `[DONE]` **Task 1.1.4** — Create `docs/GOALS.md` project plan (this file)

#### Feature 1.2: Development Workflow

- `[TODO]` **Task 1.2.1** — Add linter configuration (ESLint)
- `[TODO]` **Task 1.2.2** — Add code formatter configuration (Prettier)
- `[TODO]` **Task 1.2.3** — Set up local dev server with hot-reload

---

### Epic 2: Core Game Engine

> Build the fundamental game loop and state management that everything else depends on.

#### Feature 2.1: Game Loop

- `[TODO]` **Task 2.1.1** — Implement main game loop with `requestAnimationFrame` or `setInterval`
- `[TODO]` **Task 2.1.2** — Implement delta-time calculation for frame-independent updates
- `[TODO]` **Task 2.1.3** — Add pause / resume capability

#### Feature 2.2: Game State Management

- `[TODO]` **Task 2.2.1** — Define core game state schema (currency, generators, upgrades, stats)
- `[TODO]` **Task 2.2.2** — Implement centralized state store (plain object + getter/setter)
- `[TODO]` **Task 2.2.3** — Add state change event/callback system for UI binding

#### Feature 2.3: Save / Load System

- `[TODO]` **Task 2.3.1** — Implement save to LocalStorage (JSON serialization)
- `[TODO]` **Task 2.3.2** — Implement load from LocalStorage with schema migration/validation
- `[TODO]` **Task 2.3.3** — Add auto-save on interval (every 30 seconds)
- `[TODO]` **Task 2.3.4** — Add manual save / export / import (Base64 encoded string)

#### Feature 2.4: Offline Progress

- `[TODO]` **Task 2.4.1** — Calculate elapsed time since last session on load
- `[TODO]` **Task 2.4.2** — Apply offline earnings (with configurable efficiency %)
- `[TODO]` **Task 2.4.3** — Display "Welcome back" summary popup

---

### Epic 3: Core Gameplay Mechanics

> The click-earn-upgrade loop that forms the heart of the idle game experience.

#### Feature 3.1: Click-to-Earn

- `[TODO]` **Task 3.1.1** — Implement primary currency (e.g., "coins")
- `[TODO]` **Task 3.1.2** — Create click handler that awards currency
- `[TODO]` **Task 3.1.3** — Add click value scaling (base + bonuses from upgrades)
- `[TODO]` **Task 3.1.4** — Add floating "+N" text animation on click

#### Feature 3.2: Generators (Auto-Earners)

- `[TODO]` **Task 3.2.1** — Define generator data model (name, baseCost, baseOutput, count)
- `[TODO]` **Task 3.2.2** — Implement generator purchase logic with exponential cost scaling
- `[TODO]` **Task 3.2.3** — Integrate generators into game loop (auto-earn per tick)
- `[TODO]` **Task 3.2.4** — Create at least 5 tiers of generators with balanced progression

#### Feature 3.3: Upgrades

- `[TODO]` **Task 3.3.1** — Define upgrade data model (name, cost, effect, target, isUnlocked)
- `[TODO]` **Task 3.3.2** — Implement upgrade purchase logic (one-time purchase)
- `[TODO]` **Task 3.3.3** — Apply upgrade effects (multipliers to click value, generator output, etc.)
- `[TODO]` **Task 3.3.4** — Create initial set of 10+ upgrades tied to progression milestones

#### Feature 3.4: Achievements

- `[TODO]` **Task 3.4.1** — Define achievement data model (name, description, condition, reward)
- `[TODO]` **Task 3.4.2** — Implement achievement check system (on state change)
- `[TODO]` **Task 3.4.3** — Add achievement unlock notification (toast popup)
- `[TODO]` **Task 3.4.4** — Create initial set of 15+ achievements

---

### Epic 4: User Interface

> Build a clean, responsive UI that clearly communicates game state and available actions.

#### Feature 4.1: Main Game Screen

- `[TODO]` **Task 4.1.1** — Create HTML layout (header, main click area, sidebar panels)
- `[TODO]` **Task 4.1.2** — Style with CSS (dark theme, game-appropriate aesthetic)
- `[TODO]` **Task 4.1.3** — Display primary currency with animated counter (number formatting: K, M, B, T...)
- `[TODO]` **Task 4.1.4** — Display current CPS (coins per second)

#### Feature 4.2: Generator Panel

- `[TODO]` **Task 4.2.1** — List all generators with name, count, cost, output
- `[TODO]` **Task 4.2.2** — Buy button with affordability state (enabled/disabled)
- `[TODO]` **Task 4.2.3** — Bulk buy options (x1, x10, x100, Max)

#### Feature 4.3: Upgrade Panel

- `[TODO]` **Task 4.3.1** — Grid/list of available upgrades with tooltip descriptions
- `[TODO]` **Task 4.3.2** — Visual distinction for purchased vs. locked vs. affordable upgrades
- `[TODO]` **Task 4.3.3** — Upgrade effect preview on hover

#### Feature 4.4: Statistics & Settings

- `[TODO]` **Task 4.4.1** — Stats panel (total earned, total clicks, play time, etc.)
- `[TODO]` **Task 4.4.2** — Settings panel (toggle auto-save, export/import save, hard reset)
- `[TODO]` **Task 4.4.3** — Responsive design for mobile-friendly play

---

### Epic 5: Prestige System

> A meta-progression layer that resets progress in exchange for permanent bonuses, extending game longevity.

#### Feature 5.1: Prestige Currency & Reset

- `[TODO]` **Task 5.1.1** — Define prestige currency (e.g., "gems") and earning formula
- `[TODO]` **Task 5.1.2** — Implement prestige reset (soft reset: keep prestige currency, lose generators/upgrades)
- `[TODO]` **Task 5.1.3** — Show prestige preview (how many gems you would earn)

#### Feature 5.2: Prestige Upgrades

- `[TODO]` **Task 5.2.1** — Define prestige upgrade tree (permanent multipliers, unlocks)
- `[TODO]` **Task 5.2.2** — Implement prestige upgrade purchase UI
- `[TODO]` **Task 5.2.3** — Balance prestige curve (make each run faster)

---

### Epic 6: Polish & Launch

> Final quality pass, testing, and deployment.

#### Feature 6.1: Visual Polish

- `[TODO]` **Task 6.1.1** — Add particle effects / animations for clicks and milestones
- `[TODO]` **Task 6.1.2** — Add sound effects (click, purchase, achievement, prestige) with mute toggle
- `[TODO]` **Task 6.1.3** — Add favicon and Open Graph meta tags

#### Feature 6.2: Testing & QA

- `[TODO]` **Task 6.2.1** — Write unit tests for core game logic (currency, generators, upgrades)
- `[TODO]` **Task 6.2.2** — Playtest and balance full progression curve (click → prestige)
- `[TODO]` **Task 6.2.3** — Cross-browser testing (Chrome, Firefox, Safari, mobile)

#### Feature 6.3: Deployment

- `[TODO]` **Task 6.3.1** — Configure GitHub Pages (or equivalent static hosting)
- `[TODO]` **Task 6.3.2** — Set up CI/CD for auto-deploy on push to `main`
- `[TODO]` **Task 6.3.3** — Update README.md with project description, screenshot, and play link

---

## 3. MVP Scope (Phase 1)

The **Minimum Viable Product** is a fully playable idle game with the core loop intact. Players should be able to click, buy generators, purchase upgrades, and see their progress saved.

### MVP Includes

| Epic | Features Included                              |
| ---- | ---------------------------------------------- |
| 1    | 1.1 Project structure, 1.2 Dev workflow        |
| 2    | 2.1 Game loop, 2.2 State management, 2.3 Save/Load |
| 3    | 3.1 Click-to-earn, 3.2 Generators, 3.3 Upgrades |
| 4    | 4.1 Main screen, 4.2 Generator panel, 4.3 Upgrade panel |

### MVP Excludes (Post-MVP)

- Epic 2 Feature 2.4 — Offline progress
- Epic 3 Feature 3.4 — Achievements
- Epic 4 Feature 4.4 — Statistics & settings panel
- Epic 5 — Prestige system (entire epic)
- Epic 6 — Polish & launch (entire epic)

### MVP Exit Criteria

1. Player can click to earn primary currency.
2. Player can purchase at least 5 tiers of generators that auto-earn currency.
3. Player can purchase at least 10 upgrades that boost click value or generator output.
4. Currency displays use proper number formatting (K, M, B...).
5. Game state persists across browser sessions (LocalStorage).
6. UI is functional and visually coherent on desktop browsers.

---

## 4. Sprint Roadmap (Proposed)

| Sprint   | Focus                                       | Epics  |
| -------- | ------------------------------------------- | ------ |
| Sprint 1 | Project setup + game loop + state           | 1, 2   |
| Sprint 2 | Click mechanic + generators + basic UI      | 3, 4   |
| Sprint 3 | Upgrades + save/load + number formatting    | 3, 2   |
| Sprint 4 | **MVP Release** — QA + balance + deploy     | 6      |
| Sprint 5 | Offline progress + achievements             | 2, 3   |
| Sprint 6 | Prestige system                             | 5      |
| Sprint 7 | Polish, sound, animations, final deploy     | 6      |

---

*This document is the single source of truth for project goals and progress. It will be updated by the PM as tasks move through `[TODO]` → `[IN PROGRESS]` → `[DONE]`.*
