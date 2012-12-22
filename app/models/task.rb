class Task < ActiveRecord::Base
  attr_accessible :assigned_to, :autor, :autor2, :kommentar, :priority, :projekt_id, :status, :tag, :tasktype, :titel, :wichtig, :url, :img, :done
  belongs_to :projekt
    validates_numericality_of :projekt_id,
    :only_integer => true,
    :message => "Bitte nur ganze Zahlen eingeben"

end

