class Dictionary
  include Mongoid::Document
  field :word , :type => String
  #field :phonetic, :type => String
  has_many :categories
  
  scope :fuzzy_find, ->(word) {
    if Dictionary.where(:word => word).first
      where(:word => word)
    elsif Dictionary.where(:word => word.downcase).first
      where(:word => word.downcase)
    else
      transfer = Fuzzy.any_in(:derivations => [word]).first.try(:title)
      where(:word => transfer)
    end
  }
end
