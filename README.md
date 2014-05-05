# March Madness
This is the web application layer for an NCAA basketball matchup prediction engine that will eventually be used to predict the full march madness bracket. Currently is a just a spike application. The C++ engine is located [here](https://github.com/hebein1/march-madness-backend).

## Requirements
Ruby 2.0.0 or greater (check via `ruby -v`, see [rvm](rvm.io) for help upgrading to a new version)

## Instructions
* Clone the repository (`git clone git@github.com:brendanjcaffrey/march-madness.git`)
* Run `bundle install` to install dependencies (and the correct version of Rails)
* Use `bundle exec rails s` to start the server on port 3000
* This will start a development server that does not attempt to connect to the backend at all
* Visit `http://localhost:3000/` in your browser to access the application

## Communicating with the backend
* Get the backend to build first
* Run `bundle exec rake assets:precompile`
* Run `bundle exec rails s -e production` to start the server
* When prompted, start the predictor by running `./mme` on the backend, the server should then finish booting
* Visit `http://localhost:3000/` in your browser to access the application
* HOWEVER, if you precompile the assets (step 2), you MUST run `bundle exec rake assets:clobber` before running the integration tests again

## To run unit tests
* Use `rake db:test:prepare` to build a test database
* Run `bundle exec rspec` to run all unit tests, you can pass in a file name to run a specific one
* ---Use the parameter `-fd` for more details about passing tests

## To run integration tests
* [phantom.js](http://phantomjs.org/download.html) must be installed, which is a headless WebKit instance
* Use `rake db:test:prepare` to build a test database
* Run `bundle exec cucumber` to run all integration tests or you can pass a filename of a .feature file
* After you start features/backend.feature, you must run `bin/mmetests` on the backend when prompted

## Troubleshooting
* Something about bundle? Run `bundle install`
* Something about migrations pending? Run `rake db:migrate`
* Tests not running? Try `rake db:test:prepare`
* Cucumber tests hanging? Try `bundle exec rake assets:clobber`
* Need to scrape data from ESPN? Run `rake espn:scrape` (this will delete anything in the database)

## Installing Ruby on windows
* Download the installer from 'http://rubyinstaller.org/downloads' 
* Be sure to download both ruby and the DevKit. For this project we are using Ruby 2.0.0
* Run the ruby installer. There should be no errors.
* Follow [these](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) directions for the DevKit.
* For me I had to manually change my config.yml when installing the dev kit. I added ` - C:\Program Files\Ruby200-x64` to the last line. But you will need to make sure that path name matches where ruby is installed on your machine.
* For me I had to make sure ruby and the ruby devkit were installed to locations without a space in the path.
