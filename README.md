# Event Organizer API

A Rails JSON API for authenticated event planning. Users register and sign in through Devise JWT, create events they organize, discover upcoming events they have not joined, join events once, and retrieve their joined-event list.

This repository contains the backend API rather than a bundled responsive web interface.

## Domain flow

```text
Devise signup/login -> JWT-authenticated user
                           |
          +----------------+----------------+
          v                                 v
   organize events                    join other events
          |                                 |
          +---------- EventUser ------------+
                           |
                           v
                 joined / discoverable lists
```

## Routes

Authentication routes are mounted at the root:

- `POST /signup`
- `POST /login`
- `DELETE /logout`

Event routes are under `/api/v1/events`:

| Method | Route | Purpose |
| --- | --- | --- |
| `GET` | `/api/v1/events` | List events organized by the current user |
| `POST` | `/api/v1/events` | Create an event for the current user |
| `GET` | `/api/v1/events/:id` | Retrieve an event |
| `PATCH` | `/api/v1/events/:id` | Update an event |
| `DELETE` | `/api/v1/events/:id` | Delete an event |
| `GET` | `/api/v1/events/get_events` | Discover upcoming events not organized or joined by the user |
| `POST` | `/api/v1/events/add_user_to_events` | Join an event once |
| `GET` | `/api/v1/events/joined_events` | List joined events |

### Create an event

```http
POST /api/v1/events
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "event": {
    "name": "Rails Community Night",
    "description": "Short talks and project demos",
    "date": "2026-06-30T18:00:00Z",
    "location": "Community Hall"
  }
}
```

The organizer ID is derived from the authenticated user rather than accepted from the request body.

## Local setup

```bash
git clone https://github.com/alirazawatoo/event-organizer-rails-api.git
cd event-organizer-rails-api
bundle install
bin/rails db:prepare
bin/rails server
```

The application requires PostgreSQL plus Devise JWT configuration. Review the credential and environment files before supplying local secrets.

## Tests

```bash
bundle exec rspec
```

The tracked specs cover users, events, event membership, serializers, controllers, and request behavior. They were inspected but not executed during this review.

## Current boundaries

- `set_event` retrieves events globally by ID; update and delete actions do not visibly scope the record to its organizer.
- The `User` model declares two associations named `events`, making organizer and joined-event semantics ambiguous at the model layer.
- Duplicate membership is validated in Rails but should also be enforced with a composite database uniqueness constraint.
- Some empty collections respond with HTTP 204 while still rendering an array, which should be normalized.
- The matching frontend, if used, is maintained as a separate repository.

## Next improvements

1. Authorize show, update, and destroy operations against the event organizer.
2. Rename organizer and joined-event associations so both relationships remain explicit.
3. Add a database uniqueness constraint for event memberships.
4. Standardize JSON error envelopes and empty-collection status codes.
