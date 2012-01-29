Devise 2.0 - Rails 3.2 - OmniAuth - Facebook - Username - Twitter Bootstrap
====
This is a very basic bootstrapping template that has the following features in place:

* Rails 3.2
* Devise 2.0

    users can login with either username or email
    
* Facebook integration (via OmniAuth)

    users can login with Facebook. I keep track of their username, location, first name, last name, url and token.
    
* Twitter Bootstrap framework in SCSS

Installation
---

Just clone the repo and start hacking on top of it.

* initializers/devise.rb
change the facebook configuration code and choose what permissions you'd like to ask.

You need to create a Facebook app and insert http://localhost:3000 as the website

    config.omniauth :facebook, "APP_ID", "APP_SECRET", {:scope => 'publish_stream,offline_access,email,read_stream,read_friendlists,user_photos,friends_photos,manage_friendlists'}


* environments/development.rb

change the mailing method and credentials

    config.action_mailer.smtp_settings = {
      :enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "gmail.com",
      :authentication => :login,
      :user_name => "your-email",
      :password => "your-password",
    }


Enjoy
---

Stefano.