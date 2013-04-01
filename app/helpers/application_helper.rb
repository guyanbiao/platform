module ApplicationHelper
  def article_name(article_id)
    Article.find(article_id).name
  end
end
