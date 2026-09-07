# Game Concept — Hide, Chase, Rescue & Deceive

## 1. Overview

A team-based multiplayer game inspired by **Patintero, Taguan, Agawan Base, and social-deduction games such as Among Us**.

The game is built around a shared set of mechanics:

- Hiding and camouflage
- Observation and uncertainty
- Dangerous crossings and chokepoints
- Chasing and tagging
- Capture and Jail
- Teammate rescue
- Team objectives
- A possible hidden Impostor

The game is **not grid-based**. Patintero is an inspiration for the *gameplay tension* of crossing defended territory, not a requirement that maps use a literal grid.

The main design goal is to create situations where players constantly have to decide:

> **Do I hide, move, chase, rescue, protect, pursue the objective, or trust my teammate?**

---

# 2. Core Identity

The game combines four major ideas.

### Patintero — Crossing

Players need to move through areas controlled by opponents.

The important question is:

> **Can I get through without being caught?**

This can happen through roads, courtyards, bridges, hallways, fields, chokepoints, or other environmental spaces.

There is no requirement for painted lines or a fixed grid.

### Taguan — Hiding

Players can use the environment to remain unseen or difficult to identify.

The important question is:

> **Do they know where I am?**

Maps should provide concealment, shadows, vegetation, buildings, obstacles, alternate routes, and different visibility conditions.

### Agawan Base — Capture & Rescue

Being caught does not necessarily eliminate a player.

A captured player is sent to **Jail**.

Their teammates can attempt to rescue them.

The important question is:

> **Is rescuing my teammate worth exposing myself?**

This creates cooperative risk and forces teams to make decisions between progressing the objective and saving teammates.

### Impostor — Trust & Deception

At some point during the match, players are warned that there **may** be an Impostor on their team.

The warning is also shown when there is **no Impostor**.

Therefore, the warning itself provides no certainty.

The important question becomes:

> **Can I trust my teammate?**

The Impostor is a **core feature**, not a separate hidden mode.

---

# 3. General Match Structure

A match consists of teams with opposing objectives.

One team generally acts as the **attacking/objective team**, while the other acts as the **defending team**.

The exact roles can vary depending on the objective mode.

Teams can alternate roles between rounds so that both sides experience the different gameplay perspectives.

The shared gameplay loop is:

```text
Spawn
  ↓
Explore / Position
  ↓
Hide / Observe
  ↓
Move through dangerous areas
  ↓
Encounter enemy
  ↓
Chase / Evade / Capture
  ↓
Jail / Rescue
  ↓
Progress toward objective
  ↓
Final objective confrontation
  ↓
Win / Lose
  ↓
Roles or objectives change
```

The game should not force every match to follow exactly this sequence. Good maps and objectives should allow different paths and strategies.

---

# 4. Objective-Based Game Modes

The core mechanics remain largely the same across modes.

What changes is the **winning objective**.

## Mode 1 — Plant

### Objective

The attacking team carries an objective to one of several possible planting sites and successfully plants it.

### Attackers

- Infiltrate enemy territory
- Reach a planting site
- Plant the objective
- Protect the planter
- Prevent the defenders from stopping the plant

### Defenders

- Patrol and protect important areas
- Find attackers
- Capture attackers
- Protect planting sites
- Stop or disable the planted objective

### Why it works

Planting creates a strong final confrontation.

Multiple possible planting sites create uncertainty:

> "Which site are they attacking?"

The planting interaction also creates a vulnerable period where teammates need to protect the planter.

**Core feeling:** Infiltrate and establish.

---

# 5. Mode 2 — Capture the Flag

### Objective

Steal the enemy's flag and bring it back to your own base.

### Attackers

- Infiltrate the enemy area
- Reach the enemy flag
- Take the flag
- Escape
- Return the flag to their base

### Defenders

- Protect their flag
- Detect attackers
- Capture the flag carrier
- Recover the flag

The flag carrier should still be able to use hiding and environmental cover.

This keeps the mode connected to the game's core identity instead of becoming a conventional Capture the Flag game.

**Core feeling:** Steal and escape.

---

# 6. Mode 3 — Deliver

### Objective

Carry an item to a designated destination.

Unlike Capture the Flag, the objective is not necessarily taken from the enemy.

A team receives an item and must successfully deliver it.

### Attackers

- Locate or obtain the delivery item
- Transport it
- Protect the carrier
- Reach the destination

### Defenders

- Locate the carrier
- Intercept them
- Capture players
- Prevent delivery

Possible variations:

- Multiple delivery destinations
- Destination changes during the round
- Several possible routes
- Delivery sites with different levels of risk

**Core feeling:** Escort and survive.

---

# 7. Mode 4 — Retrieve

### Objective

Collect neutral objects scattered around the map and return them to your base.

For example:

> First team to retrieve enough artifacts wins.

Players must decide whether to:

- Search for another item
- Return safely with what they already have
- Protect the carrier
- Intercept an enemy carrier
- Rescue a captured teammate

This mode makes the entire map useful rather than focusing gameplay around one location.

**Core feeling:** Explore and extract.

---

# 8. Mode 5 — Hold

### Objective

Claim a neutral objective and maintain control of it.

Unlike a conventional King-of-the-Hill mode, control does not have to mean simply standing inside a circular zone.

The team may need to claim the objective and then protect the player/team currently controlling it.

The opposing team must find and disrupt them.

This allows the objective itself to interact with the game's hiding and information mechanics.

**Core feeling:** Find and protect.

---

# 9. Mode 6 — Sabotage

### Objective

Attackers must disable several important objectives around the map.

Examples:

- Generators
- Communication systems
- Power sources
- Gates
- Equipment

The attackers may only need to disable a certain number rather than everything.

This creates multiple fronts and forces defenders to decide where to protect.

Attackers can create distractions and make defenders unsure which objective is the real target.

**Core feeling:** Distract and disrupt.

---

# 10. Mode 7 — Hunt

### Objective

One team must protect and extract a designated target.

The opposing team must find and capture that target.

The target becomes extremely valuable.

The protecting team must:

- Keep the target hidden
- Move the target safely
- Distract pursuers
- Rescue captured teammates
- Reach extraction

The opposing team must:

- Discover the target
- Track them
- Capture them
- Prevent extraction

This mode strongly emphasizes Taguan's hiding and information mechanics.

**Core feeling:** Hide and protect.

---

# 11. Recommended Initial Modes

Although several objective modes can exist, the initial game should focus on a smaller set.

Recommended foundation:

1. **Plant** — structured tactical objective
2. **Capture** — simple and immediately understandable
3. **Retrieve** — strongly expresses the game's unique hide/chase/rescue identity

Other modes can be added after the core systems are proven:

- Deliver
- Hold
- Sabotage
- Hunt

The goal is to build **one strong core game** rather than seven unrelated games.

---

# 12. Map Philosophy

Maps should **challenge and complement the mechanics**.

They should not simply be designed around a grid.

The map itself should create strategic decisions.

A good map should contain combinations of:

### Concealment Spaces

Places where players can disappear or reduce visibility.

Examples:

- Houses
- Buildings
- Vegetation
- Crops
- Shadows
- Alleys
- Crowds
- Obstacles
- Interior spaces

Purpose:

> **Give players opportunities to hide and reposition.**

### Exposure / Transition Spaces

Areas where movement is more dangerous.

Examples:

- Roads
- Courtyards
- Bridges
- Open fields
- Hallways
- Large rooms

Purpose:

> **Create Patintero-like crossing tension without requiring a grid.**

### Control Spaces

Strategically important locations.

Examples:

- Jail
- Base
- Objective sites
- Bridges
- Central areas
- Important shortcuts
- Narrow entrances

Purpose:

> **Give defenders and attackers important locations to contest.**

---

# 13. Map Example Concepts

Maps should have their own identities and should not all play the same way.

## Abandoned Village

Possible elements:

- Houses
- Alleys
- Backyards
- Fences
- Open roads
- Vegetation
- Shortcuts

Gameplay:

> Players can disappear behind structures and choose between short exposed routes and longer concealed routes.

---

## Rice Fields

Possible elements:

- Long crop rows
- Irrigation paths
- Narrow bridges
- Open areas
- Dense vegetation

Gameplay:

> Crops provide concealment while irrigation paths and bridges become dangerous exposure zones.

---

## School Grounds

Possible elements:

- Classrooms
- Corridors
- Staircases
- Playground
- Covered court
- Storage rooms
- Fences

Gameplay:

> Interior and exterior spaces create very different visibility and pursuit conditions.

---

## Barangay Fiesta

Possible elements:

- Stalls
- Decorations
- Tarps
- Vehicles
- Crowds
- Lighting
- Shadows

Gameplay:

> Environmental visual noise makes it harder to distinguish players from their surroundings.

---

## River Crossing

Possible elements:

- Bridges
- Shallow crossings
- Narrow paths
- Riverbanks
- Dense vegetation

Gameplay:

> Chokepoints and alternative crossings create strong decisions about where to risk exposure.

---

# 14. Jail System

Jail is one of the core mechanics shared across the game.

When a player is captured:

```text
Player is caught
      ↓
Player goes to Jail
      ↓
Player is temporarily unable to continue normally
      ↓
Teammate can attempt a rescue
      ↓
Rescue succeeds or fails
```

The Jail should not simply be a punishment.

It should create a strategic decision.

A team may have to choose between:

> **Continue the objective**

or

> **Risk the objective to rescue a teammate.**

The Jail's location should therefore matter greatly to map design.

It can become a strategic point that defenders must protect while attackers may attempt dangerous rescue operations.

---

# 15. Rescue

A teammate can attempt to rescue a jailed player.

A rescue should expose the rescuer to danger.

Possible rescue situations:

- Sneaking into the Jail
- Distracting defenders
- Approaching from an alternate route
- Coordinating with another teammate
- Using abilities
- Waiting for defenders to leave

A successful rescue can create dramatic moments because the rescued player immediately returns to the match.

The system should encourage meaningful risk rather than making rescue an automatic action.

---

# 16. Impostor System

The Impostor is a **core game feature**.

It is not a separate mode.

A match may contain an Impostor, or it may contain no Impostor.

Players do not initially know which situation is active.

At a certain point in the match, everyone receives a warning.

Example:

> ⚠️ **Something isn't right...**  
> **Be careful who you trust.**

This notification appears whether an Impostor exists or not.

Therefore:

```text
Warning received
      ↓
Maybe there is an Impostor
      ↓
Maybe there isn't
      ↓
Players become suspicious
      ↓
Normal gameplay continues
```

The system creates uncertainty without requiring a traditional social-deduction meeting.

---

# 17. The Impostor's Role

The Impostor is still a normal player on their team.

They have the same basic gameplay capabilities.

However, they receive a secret secondary objective.

Example:

> **You are the Impostor.**
>
> Prevent your team from completing the objective.

The Impostor should not be able to instantly win through a single button.

They need to:

- Make believable decisions
- Create delays
- Mislead teammates
- Cause risky situations
- Manipulate routes
- Sabotage objectives
- Take advantage of normal gameplay

The goal is to create uncertainty about whether a player's behavior is intentional sabotage or simply a mistake.

---

# 18. Impostor + Game Modes

The Impostor can have different sabotage opportunities depending on the objective.

## Plant

The Impostor might:

- Mislead the team about the best planting site
- Intentionally expose the planter
- Interrupt or sabotage the plant
- Abandon the team at a critical moment

## Capture

The Impostor might:

- Mislead teammates about the flag
- Intentionally lose the flag
- Lead the carrier toward danger
- Delay the escape

## Deliver

The Impostor might:

- Send the carrier toward dangerous routes
- Delay delivery
- Abandon the carrier
- Interfere with the delivery

## Retrieve

The Impostor might:

- Mislead players about item locations
- Hide or relocate collected items
- Lead teammates away from useful areas
- Cause unnecessary captures

## Hold

The Impostor might:

- Abandon the objective at a critical moment
- Mislead teammates about enemy positions
- Break defensive coordination

## Sabotage

The Impostor might:

- Prevent teammates from coordinating
- Protect the wrong area
- Cause unnecessary captures
- Mislead the team about which objective to attack

## Hunt

The Impostor might:

- Expose the target
- Mislead the team about enemy locations
- Abandon the target
- Intentionally create unsafe routes

---

# 19. No Traditional Among Us Meeting

The game should not simply copy the emergency-meeting system.

The match should continue while suspicion develops.

Players can communicate normally:

> "I saw Josh near the objective."

> "Why didn't he help?"

> "I think he's the Impostor."

But the game does not automatically stop.

This preserves the action and keeps social deduction integrated into the actual gameplay.

The important question is:

> **Can you recognize betrayal while still trying to win the objective?**

---

# 20. Impostor Reveal

At the end of the round, the game reveals whether an Impostor existed.

### If there was one:

> 🔴 **IMPOSTOR REVEALED**
>
> Josh was the Impostor.

### If there wasn't:

> 🟢 **NO IMPOSTOR**
>
> There was no Impostor this round.

This makes suspicious moments meaningful even after the match.

A player may realize:

> "I thought he was sabotaging us, but he wasn't."

Or:

> "He was actually the Impostor the whole time."

---

# 21. Core Gameplay Tension

The game should constantly create four questions:

### Taguan

> **Where are you?**

Players hide, camouflage, observe, and deceive.

### Patintero

> **Can I safely get there?**

Players navigate dangerous exposed areas and chokepoints.

### Agawan Base

> **Will I risk myself to save you?**

Players can be captured and rescued.

### Impostor

> **Can I trust you?**

Players question whether teammates are actually helping the team.

Together, these produce the game's central experience:

> **Hide → Observe → Move → Risk exposure → Chase → Capture → Rescue → Pursue the objective → Question your teammates.**

---

# 22. Example Match Story

Team A is attacking in **Plant Mode**.

Their objective is to plant an item at one of several sites.

### Start

Team A leaves its base.

Some players move together while others take separate routes.

### Infiltration

Players use houses, vegetation, and alleys to stay hidden.

A defender spots movement.

A chase begins.

### Capture

One attacker is caught and sent to Jail.

The team now has a decision:

> Continue toward the plant or rescue their teammate?

### Suspicion Warning

The game announces:

> **Be careful who you trust. There may be an Impostor among you.**

Nobody knows whether this is true.

### The Push

The team continues toward a planting site.

One player carries the objective.

Another player scouts ahead.

Another tries to rescue the jailed teammate.

### Suspicion

The scout suddenly takes a strange route and exposes the carrier.

The team starts wondering:

> "Was that a mistake?"

> "Or is someone sabotaging us?"

### Plant

The carrier reaches the site and begins planting.

The defenders arrive.

The attackers must protect the planter.

### Final Conflict

A teammate sacrifices their position to distract the defenders.

Another teammate escapes Jail.

The plant succeeds.

### Reveal

The round ends.

The game reveals:

> **There was an Impostor.**

The suspicious scout was secretly trying to prevent the plant.

The team won despite the sabotage.

The next round switches the roles.

---

# 23. Design Principles

The game should follow these principles:

### 1. Environment over artificial lanes

Maps should naturally create routes, chokepoints, concealment, and exposure.

### 2. Information is valuable

Knowing where an enemy is should be powerful.

Not knowing should create tension.

### 3. Capture is not immediate elimination

Jail keeps players involved and creates rescue opportunities.

### 4. Rescue must involve risk

Saving a teammate should create meaningful strategic consequences.

### 5. Objectives should change the strategy

Different modes should alter what players prioritize without requiring completely different core mechanics.

### 6. Impostor behavior should be believable

The Impostor should win through deception and decision-making, not instant sabotage.

### 7. Mistakes should look suspicious

The best Impostor moments happen when players genuinely cannot tell whether something was intentional.

### 8. Maps should support multiple approaches

Players should have meaningful choices between speed, safety, concealment, and risk.

---

# 24. Current Game Foundation

The current concept can be summarized as:

> **A team-based hide, chase, capture, rescue, and objective game where players use the environment to infiltrate enemy territory and complete different objectives. Captured players can be rescued, while the possibility of an Impostor creates uncertainty about whether teammates can be trusted.**

The inspirations are used as **mechanical foundations**, not restrictions:

- **Patintero** → crossing defended territory
- **Taguan** → hiding and uncertainty
- **Agawan Base** → capture and rescue
- **Among Us** → suspicion and hidden betrayal

The maps remain free-form and environment-driven.

The objective can change through different game modes.

The core gameplay remains consistent.

---

# 25. Things Still to Define

These should be decided before detailed implementation:

1. Exact team sizes
2. Exact round length
3. Exact capture/tag rules
4. How Jail works
5. Exact rescue rules
6. Whether players can be captured repeatedly
7. How objectives are interacted with
8. How many objective sites exist
9. How the Impostor is selected
10. How many Impostors can exist
11. When the Impostor warning occurs
12. Exact Impostor win condition
13. Whether the Impostor can directly interact with enemies
14. How communication works
15. Whether players can accuse someone
16. Exact scoring system
17. How roles rotate between rounds
18. Map-specific rules
19. Character abilities
20. Match progression and economy

These should be designed **after the core round loop is validated**, rather than locking numbers prematurely.

---

# 26. One-Sentence Vision

> **A multiplayer game where getting caught is only the beginning, hiding is as important as fighting, rescuing a teammate can turn the match around, objectives force players into dangerous territory, and you can never be completely sure that the teammate beside you is actually helping you win.**