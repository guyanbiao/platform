class Sense
  include Mongoid::Document
  belongs_to :category
  field :description, :type => String
  has_and_belongs_to_many :articles
end
