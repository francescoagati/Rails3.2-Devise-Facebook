class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :last_name, :location, :login,
                  :remember_me, :confirmed_at, :first_name, :fb_token, :fb_url, :username
  
  attr_accessor :login
  

  #this method is for letting users authenticate both with emails and usernames
  def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
   end

  #this method is for finding or creating a user after we get a callback from facebook
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    info = access_token.info
    if user = User.where(:email => data.email).first
      if user.fb_token == nil && user.first_name == nil
        user.first_name = data.first_name
        user.last_name = data.last_name
        user.location = info.location
        user.fb_url = info.urls.Facebook
      end
      user.fb_token = access_token.credentials.token
      user.save
      user
    else # Create a user with a stub password, we will change it right after
      User.create!(
        :email => data.email,
        :password => Devise.friendly_token[0,20],
        :confirmed_at => Time.now,
        :first_name => data.first_name,
        :last_name => data.last_name,
        :fb_url => info.urls.Facebook,
        :location => info.location,
        :username => info.nickname,
        :fb_token => access_token.credentials.token
        ) 
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def update_with_password(params={}, userid, fbtime)
      created_date = User.find(userid).created_at
      if fbtime
        real = !((fbtime.to_time - 5.minutes) > created_date)
      end
      current_password = params.delete(:current_password)

      if params[:password].blank?
        params.delete(:password)
      end 

      result = if !params[:password] || valid_password?(current_password) || real
        update_attributes(params)
      else
        self.attributes = params
        self.valid?
        self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end 

      clean_up_passwords
      result
    end
    
  
end
