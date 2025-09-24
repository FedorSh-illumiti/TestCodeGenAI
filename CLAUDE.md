# Claude Code Instructions - SFLIGHT CAP Project

## Project Overview
This is a **SAP Cloud Application Programming (CAP) model** project implementing the SFLIGHT Travel Management System - a comprehensive travel booking demo application showcasing enterprise-grade travel management capabilities.

### Technology Stack
- **Framework**: SAP CAP (Cloud Application Programming Model)
- **Database**: SQLite (development) / SAP HANA (production)
- **Runtime**: Node.js with TypeScript
- **Testing**: Jest with Supertest
- **Deployment**: MTA (Multi-Target Application) to SAP BTP

### Project Structure
```
sflight/
├── db/
│   └── schema.cds          # Data model definitions
├── srv/                    # Service layer (to be created)
├── app/                    # UI applications (to be created)
├── mta.yaml               # Multi-target application descriptor
├── package.json           # Node.js dependencies and scripts
└── .taskmaster/           # Task Master AI project files
```

## Development Workflow Commands

### Daily Development
```bash
# Start development server with hot reload
npm run dev                 # cds watch

# Start production server
npm start                  # cds-serve

# Build project
npm run build              # cds build

# Deploy database locally
npm run deploy             # cds deploy
```

### Testing & Quality Commands
```bash
# Run all tests
npm test                   # jest

# Run tests in watch mode
npm run test:watch         # jest --watchAll

# TypeScript compilation check
npm run compile            # tsc

# Code linting
npm run lint               # eslint . --ext .js,.ts,.json
```

### CAP-Specific Commands
```bash
# Generate OData service metadata
cds compile srv/ --to edmx

# Inspect data model
cds compile db/schema.cds --to sql

# Import sample data (if available)
cds deploy --to sqlite:db.sqlite --with-mocks

# Watch for changes (alternative to npm run dev)
cds watch
```

## CAP Model Development Guidelines

### CDS Entity Conventions
- Use PascalCase for entity names (Travel, Booking, BookingSupplement)
- Use camelCase for element names (TravelID, BookingFee)
- Include `managed` aspects for audit fields (created*, modified*)
- Include `cuid` for UUID keys where appropriate
- Use compositions for parent-child relationships
- Use associations for references

### Service Layer Pattern
When creating services in `srv/`, follow these patterns:
```javascript
// srv/travel-service.cds
using { sap.fe.cap.sflight as my } from '../db/schema';

service TravelService {
  entity Travel as projection on my.Travel;
  entity Booking as projection on my.Booking;
}
```

### Implementation Guidelines
1. **Always check existing CDS models** before creating new entities
2. **Use CAP's built-in features** (managed, cuid, common types)
3. **Follow SAP naming conventions** for SFLIGHT domain
4. **Implement proper associations** between related entities
5. **Use annotations** for UI and validation hints

## Deployment Instructions

### Local Development
1. Install dependencies: `npm install`
2. Deploy to SQLite: `npm run deploy`
3. Start development server: `npm run dev`
4. Access at: `http://localhost:4004`

### Production Deployment (SAP BTP)
```bash
# Build MTA archive
mbt build

# Deploy to Cloud Foundry
cf deploy mta_archives/sflight_1.0.0.mtar
```

### Database Migration
```bash
# Deploy schema changes
cds deploy --to sqlite:db.sqlite

# For HANA (production)
cds deploy --to hana
```

## Task Master AI Instructions
**Import Task Master's development workflow commands and guidelines, treat as if import is in the main CLAUDE.md file.**
@./.taskmaster/CLAUDE.md
- don't add @title annotation

## CAP-Specific Best Practices

### Before Making Changes
1. **Always run `npm run compile`** to check TypeScript
2. **Run `npm run lint`** to ensure code quality
3. **Run `npm test`** to verify existing functionality
4. **Use `cds watch`** during development for live reload

### Entity Relationship Guidelines
- **Travel** → **Booking** (1:n composition)
- **Booking** → **BookingSupplement** (1:n composition)
- Use `@mandatory` for required fields
- Include proper validation with `@assert.range`
- Use appropriate data types (Decimal for currency, Date for dates)

### Service Implementation
When implementing services:
1. Create service definitions in `srv/`
2. Add custom handlers in JavaScript/TypeScript
3. Implement business logic in event handlers
4. Add authorization annotations
5. Test with OData queries

### Common CAP Commands to Remember
```bash
# Useful during development
cds version                 # Check CAP version
cds help                   # Get help
cds env                    # Show configuration
cds serve --help          # Service options
cds build --help          # Build options
```

## File Creation Rules
- **CDS files**: Always in `db/` for models, `srv/` for services
- **TypeScript handlers**: In `srv/` matching service names
- **Test files**: In `test/` or `__tests__/` directories
- **UI apps**: In `app/` directory (Fiori Elements)

## Important Notes
- This project uses **TypeScript** by default
- Database is **SQLite for development**, **HANA for production**
- Follow **CAP best practices** for entity modeling
- Use **Task Master AI** for complex feature planning
- Always **run tests and lint** before committing changes