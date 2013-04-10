class QueryController < ApplicationController
  def index
    words = Dictionary.fuzzy_find params[:word]
    result = words.map { |word| { :origin => (Fuzzy.any_in(:derivations => [params[:word]]).first.try(:title) || params[:word]),
                                  :word => word.categories.map { |category| {:category => category.senses.map { |sense| { :description => sense.description, :num => sense.num}}}}}}
    render json: result
  end

  def check
    @filter = Filter.where(:level => params[:level]).first
    render json: @filter.try(:members)
  end

end
