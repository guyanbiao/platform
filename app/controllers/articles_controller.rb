class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
  def new
    @article = Article.new
  end
  def create
    @article = Article.new(params[:article])
    if @article.save
      session[:article_id] = @article.id
      redirect_to '/raffle'
    else
      render :action => :new
    end
  end

  def update
    @article = Article.find(params[:id])
    render json: @article
  end
end
