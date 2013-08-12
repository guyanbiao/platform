class QueryController < ApplicationController

  def add_marked_word
    article = Article.find params[:article_id]
    if article.marked_words.map(&:sense_id).include? params[:sense_id]
      render josn: {result: 'fail', reason: 'duplicated'}
    else
      sense = Sense.find params[:sense_id]
      word = sense.category.dictionary.word
      meaning = sense.description
      render json: {word: word, meaning: meaning, sense_id: sense.id}
    end
  end

  def marked_words
    article = Article.find params[:article_id]
    m = article.marked_words.map  {|x| {word: x.word,
     meaning: x.sense.description,
     send_id: x.sense.id }}
    render json: m
  end
  
  def index
    words = Dictionary.fuzzy_find params[:word]
    result = words.map { |word| { :origin => (Fuzzy.any_in(:derivations => [params[:word]]).first.try(:title) || params[:word]),
                                  :word => word.categories.map { |category| {:cat => category.cat.speech, :sense => category.senses.map { |sense| { :description => sense.description, :id => sense.id}}}}}}
    render json: result
  end

  def check
    @filter = Filter.where(:level => params[:level]).first
    render json: @filter.try(:full_members)
  end

  def before_this
    article = Article.find params[:article_id]
    tg = article.grade
    tu = article.unit
    tl = article.lesson

    result = []
    if tg > 9
      middle = Filter.find_by(:level => 'middle').full_members
      base =  Filter.find_by(:level => 'high').full_members - middle
      ((9+1)..tg).each do |gr|
        (1..tu).each do |un|
          (1..tl).each do |le|
            this_lesson = Article.find_by(:grade => gr, :unit => un, :lesson => le)
            result.concat this_lesson.marked_words.map(&:word)
          end
        end
      end
    end

    render json: base - result
  end
end
