class RaffleController < ApplicationController
  def index
    if params[:article_id]
      @article = Article.find params[:article_id]
      gon.article_id = @article.id.to_s
      session[:article_id] = params[:article_id]
    else
      flash[:error] = 'choose a lession'
      redirect_to :back
    end
  end
end
