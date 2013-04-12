class Cat
  include Mongoid::Document
  field :speech
  embedded_in :category
end
