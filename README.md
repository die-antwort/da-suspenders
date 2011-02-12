DA-Suspenders is a base Rails application that you can upgrade.

This is a fork of [thoughtbot's original Suspenders](https://github.com/thoughtbot/suspenders/), customized to our needs.


## Installation

First install the da-suspenders gem:

    gem install da-suspenders

Then run:

    da-suspenders create projectname

This will create a Rails 3 app in `projectname'. This script creates a new git repository. It is not meant to be used against an existing repo.

Suspenders uses [Trout](https://github.com/thoughtbot/trout) to make it easier to maintain a base version of special files (like Gemfile) in Suspenders.

Whenever you want to get the latest and greatest Suspenders' Gemfile, run:

    trout update Gemfile


## Gemfile

To see the latest and greatest gems, look at DA-Suspenders'
[template/trout/Gemfile](https://github.com/die-antwort/da-suspenders/blob/master/template/trout/Gemfile), which will be copied into your projectname/Gemfile.

It includes application gems like:

* [Compass](https://github.com/chriseppstein/compass), a [Sass-based](http://sass-lang.com/) CSS Meta-Framework
* [Formtastic](https://github.com/justinfrench/formtastic) for better forms
* [Hoptoad Notifier](https://github.com/thoughtbot/hoptoad_notifier) for exception notification
* [Paperclip](https://github.com/thoughtbot/paperclip) for file uploads
* [Sprockets](https://github.com/sstephenson/sprockets) for JavaScript dependency management and concatenation
* Our fork of [jRails](https://github.com/die-antwort/jrails), which brings you [jQuery](https://github.com/jquery/jquery) and [jQuery UI](https://github.com/jquery/jquery-ui) via Sprockets


And testing gems like:

* [Cucumber, Capybara, and Akephalos](http://robots.thoughtbot.com/post/1658763359/thoughtbot-and-the-holy-grail) for integration testing, including Javascript behavior
* [RSpec](https://github.com/rspec/rspec) for awesome, readable isolation testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for easier creation of test data
* [Timecop](https://github.com/jtrupiano/timecop) for dealing with time


## Other goodies

DA-Suspenders also comes with:

* Additional staging environment.
* German localization and timezone setting.
* Rails' flashes set up and in application layout.

See [template/files](https://github.com/die-antwort/da-suspenders/blob/master/trout) to see what is installed via Trout.


## Credits

DA-Suspenders is created by [DIE ANTWORT](http://www.die-antwort.eu), based on Suspenders created and funded by [thoughtbot, inc](http://thoughtbot.com/community).
