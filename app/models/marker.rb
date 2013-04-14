class Marker
  include Mongoid::Document
  belongs_to :sense
  has_many :articles
end
