# README

# Customer Portal App

Customer Support is an app that helps an organization to manage customer service requests and interact with the customers to resolve their support tickets. The system allows customers to be able to place support request and the support agents to process the request.

## Getting started

## Installation

In order to install and run this project locally, you would need to have the following installed on you local machine.

- [**Ruby 2.6.3**](https://www.ruby-lang.org/en/downloads/)
- [**MySQL**](https://www.mysql.com/downloads/)
- [**Bundle gem**](https://https://bundler.io/)

### Installation

Take the following steps to setup the application on your local machine:

- Run `git clone https://github.com/omenkish/customer-portal.git` to clone this repository

- Run `bundle install` to install all required gems

=================================OR==================================

- Unzip the zipped file and move to the next step

### Configuring the database

_Note_ create and update your .env file with the following

```yml
DB_PASSWORD = 
DB_USERNAME =
COMPANY_EMAIL =
EMAIL_HOST =
EMAIL_USERNAME = 
EMAIL_PASSWORD = 
```

- Create these 2 databases `customer_portal_development` and `customer_portal_test`. To create them, run:

  ```bash
  rails db:create
  ```

- Next run the code below to migrate schemas that might have not been added to the database

  ```bash
  rails db:migrate
  ```
- Create 3 users with the 3 different roles each by running
    ```bash
      rails db:seed
    ```
## Starting the server

* Run `rails s` to start the application

* Visit: http://localhost:3000/ and login as admin using
- Email: `admin@admin.com`
- Password: `password`

You can also login as an agent or customer by using the same password as above but replace every instance  of the email with the role you wish to use
 - i.e to login as an agent, use `agent@agent.com` with the same password




## Tests

* Run test with `rspec`

## Assumptions made
* The app is a monolith ruby application
* I assumed that an admin can assign tickets to agents
* Admin should not be able to change his/her own role
* Send email to the agent a ticket is assigned to
* Send email to the owner of the ticket when the email is resolved
* For the sake of scalability, I implemented comments with rails action cable.
* I implemented the csv export with rails stream
* I assumed that an admin and an agent can also create tickets.


## Limitations
* The styling and UX can be greatly improved especially for smaller devices
* Email configuration may need to be updated for production
* Given that rails is well optimized for Postgres, I am wondering why we chose to use MySQL

