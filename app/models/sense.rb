class Sense
  include Mongoid::Document
  belongs_to :category
  field :description, :type => String
end
