class Meaning
  include Mongoid::Document
  embedded_in :category
  field :num, :type => Integer
  field :description => String
end
