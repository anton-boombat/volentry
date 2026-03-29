# Copilot Instructions

## Tech Stack
- Backend: .NET 8 (C#)
- Cloud: Azure
- Infrastructure: Terraform (preferred over Bicep)
- Messaging: Azure Service Bus

## Architecture
- Prefer clean architecture principles where practical
- Keep services small and focused
- Separate API, application, and infrastructure concerns
- Avoid unnecessary abstraction

## Coding Standards
- Use async/await correctly (avoid blocking calls)
- Always support CancellationToken in async methods where appropriate
- Prefer explicit types when it improves readability
- Use dependency injection via constructor injection

## Testing
- Add unit tests for business logic
- Avoid over-mocking
- Prefer meaningful test names over short ones

## API Design
- Use consistent route naming
- Return appropriate HTTP status codes
- Validate inputs early

## Infrastructure
- Prefer Terraform for new infrastructure
- Keep infrastructure definitions close to application code
- Avoid manual Azure configuration where possible

## Refactoring Rules
- Keep changes minimal unless explicitly asked
- Explain trade-offs before large changes
- Do not introduce new frameworks without justification

## What to Avoid
- Over-engineering
- Deep inheritance hierarchies
- Static state unless necessary