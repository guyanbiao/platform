class Article
  include Mongoid::Document
  has_and_belongs_to_many :senses
  has_many :marked_words
  field :grade,  :type => Integer
  field :unit,   :type => Integer
  field :lesson, :type => Integer
  field :text,   :type => String
  field :html,   :type => String
  validates_uniqueness_of :lesson, :scope => [:grade, :unit]

  def name
    "Grade #{self.grade} Unit #{self.unit} Lesson #{self.lesson}"
  end
end
