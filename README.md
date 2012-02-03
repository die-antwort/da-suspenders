DA-Suspenders is a base Rails application that you can upgrade.

This is a fork of [thoughtbot's original Suspenders](https://github.com/thoughtbot/suspenders/), customized to our needs.


## Installation

First install the da-suspenders gem:

    gem install da-suspenders

Then run:

    da-suspenders create projectname

This will create a Rails 3.2 app in `projectname`. This script creates a new git repository. It is not meant to be used against an existing repo.

### Mongoid 
If you want to create an app using [Mongoid](http://mongoid.org/) pass the `--with-mongoid` option:

    da-suspenders create projectname --with-mongoid


### Trout

Suspenders uses [Trout](https://github.com/thoughtbot/trout) to make it easier to maintain a base version of special files (like Gemfile) in Suspenders.

Whenever you want to get the latest and greatest DA-Suspenders' Gemfile, run:

    trout update Gemfile


## Gemfile

To see the latest and greatest gems, look at DA-Suspenders'
[template/trout/Gemfile](https://github.com/die-antwort/da-suspenders/blob/master/template/trout/Gemfile), which will be copied into your projectname/Gemfile.

It includes application gems like:

* [Compass](https://github.com/chriseppstein/compass), a [Sass-based](http://sass-lang.com/) CSS Meta-Framework
* [will_paginate](https://github.com/mislav/will_paginate/wiki/) for easy pagination
* [Paperclip](https://github.com/thoughtbot/paperclip) or [CarrierWave](https://github.com/jnicklas/carrierwave) for file uploads
* [Formtastic](https://github.com/justinfrench/formtastic) for better forms
* [Devise](https://github.com/plataformatec/devise) and [CanCan](https://github.com/ryanb/cancan) for authentication and authorization
* [AppConfig](https://github.com/die-antwort/app_config) for simple application configuration
* [Airbrake](https://github.com/thoughtbot/airbrake) for exception notification

And testing gems like:

* [Cucumber, Capybara, and Capybara-Webkit](http://robots.thoughtbot.com/post/4583605733/capybara-webkit) for integration testing, including Javascript behavior
* [RSpec](https://github.com/rspec/rspec) for awesome, readable isolation testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for easier creation of test data
* [Timecop](https://github.com/jtrupiano/timecop) for dealing with time

Some gems are commented out by default in the Gemfile – just uncomment the ones you want to use.



## Other goodies

DA-Suspenders also comes with:

* Additional staging environment.
* German localization and timezone setting.
* Rails' flashes set up and in application layout.

See [template/files](https://github.com/die-antwort/da-suspenders/blob/master/template/trout) to see what is installed via Trout.


## Credits

DA-Suspenders is created by [DIE ANTWORT](http://www.die-antwort.eu), based on Suspenders created and funded by [thoughtbot, inc](http://thoughtbot.com/community).
