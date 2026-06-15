# Event Management Application

## Introduction
This Event Management Application is a Ruby on Rails web application designed to simplify the process of creating, viewing, and joining events. It features a user-friendly interface along with an API endpoint for managing event data. This project showcases CRUD operations, authentication, and a clean, responsive UI/UX.

## Technology Stack
- **Framework:** Ruby on Rails 7.1.2
- **Language:** Ruby 3.2.2
- **Database:** PostgreSQL / SQLite
- **Frontend:** HTML, CSS/SCSS, JavaScript
- **Testing:** RSpec, FactoryBot, Faker

## Features
- User authentication (Sign up, Log in, Log out) using Devise.
- Event management (Create, Read, Update, Delete).
- RESTful API endpoints for event operations.
- Interactive and responsive user interface.
- JSON data exchange format for API.

## Setup and Installation
1. **Clone the Repository:**
   ```bash
   git clone [repository-url]
   ```
2. **Install Dependencies:**
   ```bash
   bundle install
   ```
3. **Database Setup:**
   ```bash
   rails db:create db:migrate
   ```
4. **Run the Server:**
   ```bash
   rails server
   ```

## API Endpoints
- **User Authentication:** 
  - Signup: `POST /signup`
  - Login: `POST /login`
  - Logout: `DELETE /logout`
- **Event Operations:** 
  - List all events: `GET /api/v1/events`
  - Create new event: `POST /api/v1/events`
  - Show an event: `GET /api/v1/events/:id`
  - Update an event: `PUT /api/v1/events/:id`
  - Delete an event: `DELETE /api/v1/events/:id`

## Running Tests
Execute the following command to run the suite of tests:
```bash
bundle exec rspec
```
