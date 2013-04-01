class Fuzzy
  include Mongoid::Document
  field :title, :type => String
  field :derivations, :type => Array
end
