class MarkedWord
  include Mongoid::Document
  validates_uniqueness_of :sense, :scope => :article
  belongs_to :article
  belongs_to :sense
  field :word, :type => String
end
