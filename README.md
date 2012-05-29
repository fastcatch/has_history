# HasHistory

This gem adds a simple but effective changes history to your ActiveRecord models.  It is designed with Rails on mind but it can be used without it as well.

## Installation

Add this line to your application's Gemfile:

    gem 'has_history'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_history

## Usage

First you have to set up `has_history`:

    $ rails g has_history:install

and then migrate your database (`rake db:migrate`).

From then on whenever you add `has_history` to your ActiveRecord model like this:

    class MyModel < ActiveRecord::Base
      ...
      has_history
      ...
    end

then you 'magically' have history for the changes.  You can access history via

    MyModel.history_entries

Each entry has a `modifications` attribute that contains the changes in array of hashes:

    [{ attribute1 => {:before => value1_before, :after => value1_after} }, ..., { attributeN => {:before => valueN_before, :after => valueN_after} }]

Other useful attributes:

- `modified_by_id` is a reference to the user who made the changes
- `entity` is the model instance affected
- `created_at` is the time when the change took place

## Configuration

`has_history` has a few options to control its behavior:

- `ignore_attributes` controls which attributes are *not* included in the history tracking
- `updater_id` sets the user who made the changes (it can be taken from the record or set via some other method, such as the widespread User.current_user hack)
- `resolution_map` holds foreign key references to attributes whose value is to be materializes (that is instead of post_id it is possible to save the title of the referenced post)

For more details see `config/initializers/has_history.rb`.

Configuration options have defaults, can be set through the initializer, or can be passed in on a per-model base (as params to the `has_model` method).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
