PROG6212-ST10449569-POE-PART-1

RaceDay – Event Management System

Project Description
RaceDay is a full-stack web-based event management system built for the South African road running, walking, and cycling community. It allows Event Organisers to create and manage events, categories, and participant results, while Participants can browse upcoming events, enter events, and track their personal performance history.

This is Part 1 of a three-part Portfolio of Evidence: system planning, including an Entity Relationship Diagram (ERD), a full API endpoint plan, and a SQL database script.

User Roles
- **Organiser** — can create, edit, and delete events, manage event categories, capture participant results, and view all event enrolments.
- **Participant** — can create an account, browse events, enter an event by selecting a category, view their own enrolments, and track their personal results.

Contents of /docs
- `raceday_erd.png` — Entity Relationship Diagram showing all entities, attributes, primary/foreign keys, and cardinality.
- `api_endpoint_plan.md` — Full API endpoint specification table covering Authentication, User Profile, Events, Categories, Enrolments, and Results.
- `raceday_schema.sql` — SQL Server script that creates the database schema and seeds sample data.

Setup Instructions
1. Install SQL Server (Express edition or higher) and SQL Server Management Studio (SSMS).
2. Open `docs/raceday_schema.sql` in SSMS.
3. Press F5 or click Execute to run the script — it creates the `RaceDayDB` database, all tables, and seeds sample data.
4. Verify by expanding Databases → RaceDayDB → Tables in Object Explorer.



<img width="1362" height="767" alt="sql" src="https://github.com/user-attachments/assets/2b7f2bad-c3ae-4eee-a528-6a0b968c8b3e" />


## AI Tool Disclosure
AI tools (Claude, Anthropic) were used during this project for planning assistance, drafting the ERD structure, SQL script scaffolding, and troubleshooting setup issues. All work was reviewed, tested, and adapted by the author.
