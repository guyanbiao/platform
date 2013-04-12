class Category
  include Mongoid::Document
  belongs_to :dictionary
  has_many :senses
  embeds_one :cat
end
