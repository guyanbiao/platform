module ApplicationHelper
  def article_name(article_id)
    Article.find(article_id).try(:name)
  end
end
