### Calories tracker web app
* The user must be able to create an account and log in (DONE)
* When logged in, the user can see a list of his meals and calories (the user enters calories manually, no auto calculations)... (DONE)
* ...and should be able to edit and delete (DONE)
* Each entry has a date, time, text, and number of calories (DONE)
* Filter by dates from-to, time from-to (e.g., how much calories have I had for lunch each day in the last month, if lunch is between 12:00 and 15:00) (DONE)
* User setting – Expected number of calories per day: When displayed, it goes green if the total for that day is less than the expected number of calories per day, otherwise goes red (DONE)
* The back-end must be in Ruby on Rails (DONE)
* Minimal UI/UX design is needed (DONE)
* Most actions need to be done client side using AJAX, refreshing the page is not acceptable (DONE)
* REST API. Make it possible to perform all user actions via the API, including authentication. (DONE)
* Write tests! Decide which areas are worth testing and which kind of tests (unit, integration etc.) to utilize. Run `./scripts/run_tests.sh` or `rake test` at project root (DONE)
  - Unit tests
  - Functional tests
  - Integration tests
