class Task < ActiveRecord::Base
  attr_accessible :assigned_to, :autor, :autor2, :kommentar, :priority, :projekt_id, :status, :tag, :tasktype, :titel, :wichtig
end
