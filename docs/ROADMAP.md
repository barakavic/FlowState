# FlowState : Execution System Roadmap

## Milestone: Core Backend (FastAPI)

* Setup FastAPI project structure
* Define ExecutionUnit model (project, book, course)
* Define Step model (tasks, chapters, modules)
* Implement CRUD endpoints for ExecutionUnit
* Implement CRUD endpoints for Steps
* Add status transitions (active, backlog, completed)
* Implement sequential constraint for course steps

---

## Milestone: Scheduling Engine

* Accept duration (days/weeks) input
* Accept hours per day input
* Compute total available hours
* Distribute hours across steps
* Assign deadlines to each step
* Handle uneven task weighting (basic heuristic)
* Store allocated_hours and deadlines in database

---

## Milestone: Project Roadmap Parsing

* Accept roadmap.md upload or paste
* Parse markdown structure:

  * "##" → milestones
  * "-" → tasks
* Convert parsed data into Steps
* Link Steps to ExecutionUnit (project)
* Handle malformed markdown gracefully

---

## Milestone: Book Processing (PDF)

* Implement PDF upload
* Extract table of contents (TOC) using PyMuPDF
* Derive chapters with start/end pages
* Fallback: manual chapter input
* Convert chapters into Steps
* Assign deadlines via scheduling engine

---

## Milestone: Course Module Input

* Create manual input interface for course modules
* Store modules as ordered Steps
* Enforce sequential completion constraint
* Integrate with scheduling engine for deadlines

---

## Milestone: Progress Engine

* Compute progress as completed_steps / total_steps
* Track last_activity timestamp
* Detect stale units (>2 days inactivity)
* Detect overdue steps
* Generate system pressure signals

---

## Milestone: Flutter Desktop UI

* Setup Flutter project (desktop support)
* Build main layout (focus panel + secondary items + signals)
* Implement ExecutionUnit cards
* Implement Step list view (expanded plan)
* Implement creation flows:

  * Project (markdown upload)
  * Book (PDF upload)
  * Course (manual input)
* Integrate with FastAPI backend

---

## Milestone: Focus Engine

* Implement “Current Focus” selection
* Restrict UI to highlight one active unit
* Enable quick step completion
* Add “Switch Focus” interaction
* Emphasize next actionable step

---

## Milestone: Constraint System

* Limit active ExecutionUnits (e.g., max 5)
* Limit active books (e.g., max 2)
* Prevent adding beyond limits
* Surface constraint feedback in UI

---

## Milestone: Local Persistence & Setup

* Use SQLite for initial database
* Configure environment variables
* Add Docker support for backend
* Create basic docker-compose setup

---

## Milestone: Authentication (Optional Phase)

* Implement Google OAuth login
* Associate ExecutionUnits with users
* Secure API endpoints

---

## Milestone: Deployment

* Containerize FastAPI backend
* Deploy to Oracle VPS
* Configure PostgreSQL (replace SQLite)
* Enable remote access for Flutter apps

---

## Milestone: Future Enhancements (Do Not Implement Yet)

* GitHub commit verification system
* AI-based roadmap parsing improvements
* Personal PDF reader integration
* NotebookLM integration
* Course auto-ingestion from platforms
