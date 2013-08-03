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
    @article.html = params[:html]
    @article.save


    params[:new_comer].each do |m|
      sense = Sense.find m[1].meaning
      marked = MarkedWord.new
      marked.sense = sense
      marked.article = @article
      marked.word = sense.category.dictionary.word
      marked.save
    end
    render json: {result: 'ok'}
  end
end
