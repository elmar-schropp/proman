class User < ActiveRecord::Base
  attr_accessible :fullname, :is_admin, :passwort, :username
end
