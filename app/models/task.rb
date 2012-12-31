class Task < ActiveRecord::Base
  attr_accessible :assigned_to, :autor, :autor2, :kommentar, :priority, :projekt_id, :status, :tag, :tasktype, :titel, :wichtig, :url, :img, :done, :done_at, :done_by, :star, :trash, :trash_at, :trash_by, :timing, :highlight
  belongs_to :projekt
    validates_numericality_of :projekt_id,
    :only_integer => true,
    :message => "Bitte nur ganze Zahlen eingeben"
    validates_presence_of :projekt, :message => "Keine gueltige Projekt-Id"
end

