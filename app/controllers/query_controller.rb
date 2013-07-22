class QueryController < ApplicationController
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
      base = Filter.find_by(:level => 'high').full_members
      ((9+1)..tg).each do |gr|
        (1..tu).each do |un|
          (1..tl).each do |le|
            this_lesson = Article.find_by(:grade => gr, :unit => un, :lesson => le)
            result.concat this_lesson.marked_words.map(&:word)
          end
        end
      end
    end

    render json: result
  end
end
