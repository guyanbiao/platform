class Filter
  include Mongoid::Document
  field :level, :type => String
  field :members, :type => Array
end
