# API Conventions

GraphQL conventions inspired by [GitLab's GraphQL API style guide](https://docs.gitlab.com/ee/development/api_graphql_styleguide.html).

## Mutations

Name mutations as **ResourceAction** (noun first, verb second):

```
UserUpdate, UserCreate, UserDelete
ActivityCreate, ActivityArchive
SessionStart, SessionEnd
```

Never verb-first (`CreateUser`, `UpdateActivity`).

Every mutation returns:

```ruby
field :errors, [String], null: false  # empty array on success
field :resource, Types::ResourceType, null: true
```

All arguments go inside a single `input` object — never top-level.

## Types

- PascalCase for type names: `UserType`, `ActivityType`
- camelCase for fields: `createdAt`, `updatedAt`, `fullName`
- Enums: UPPER_SNAKE_CASE values, class name ends with `Enum`
- IDs: expose Global IDs (`gid://cram/User/1`), never raw database PKs

## Queries

- Nullable by default — only mark `null: false` when a field truly cannot be nil
- Collections always use Relay-style connections with `first`, `after`, `last`, `before`
- Name connection fields as plurals: `users`, `activities`

## N+1 Prevention

Use `GraphQL::Dataloader` for all associations. Wire up a source the moment you add a `has_many` or `belongs_to` to a type — not after you notice a problem.

Test with `QueryRecorder` or log query counts in specs. Batching is unnecessary for mutations (they run serially).

## Authorization

Authorize at the resolver level using `authorized_find!`. Never trust a client-supplied ID without checking permissions.

- Single values: return `null` if unauthorized
- Collections: filter out unauthorized records silently

## Errors

Two categories:

1. **User errors** — validation failures, permission denials. Return in the mutation `errors` array.
2. **System errors** — bugs, unexpected state. Raise as top-level GraphQL errors. Never expose backtraces in production.
