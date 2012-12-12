class Projekt < ActiveRecord::Base
  attr_accessible :icon, :kommentar, :name
  has_many :tasks
end
