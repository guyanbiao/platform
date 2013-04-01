class Category
  include Mongoid::Document
  embedded_in :dictionary
  embeds_many :senses
end
