class Sense
  include Mongoid::Document
  embedded_in :category
  field :num,         :type => Integer
  field :description, :type => String
end
