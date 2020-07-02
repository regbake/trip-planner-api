# README

Exercise creating an API for a Trip Planner

* Ruby Version 2.7.0
* Rails Version 6.0.3.2
* Additional usage of rails-rspec and Pry

* To run locally: Clone repo and 'bundle install'
- The test suite can be run with `rspec` in the root project dir.
- Additionally, `rails s` to start a local server. Consume endpoints with a Client (Postman was used during development)

Additional notes:
4) Locking down the API - if this API was used in production it would be useful to include a request limiter. There are no API keys currently used to query the WorldBank API and all data is Public. It would be helpful to reduce the number of calls to 'this' API in the effort to reduce spamming/overuse.

* The file 'process.txt' is included as some rough note-taking from before/while beginning the exercise.
