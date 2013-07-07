class ImportController < ApplicationController
  def index
  end

  def article
    doc = params[:article][:file].read
    @article = Article.find params[:article][:article_id]
    @article.text = doc
    @article.html = doc.gsub(/(\b[\w|-|']+\b)/, '<word class="word">\1</word>') 
    @article.save
    redirect_to :back
  end

  def dictionary
    doc = Nokogiri::XML((params[:dictionary][:file]).read)
    doc.xpath('main/subdict/entry/head/word').each do |word|
      d = Dictionary.create(:word => word.text)
      word.parent.parent.xpath('body/category').each do |category|
        c = d.categories.create
        c.create_cat(:speech => category.xpath('cat').text)
        category.xpath('sense').each do |sense|
          s = c.senses.create(:description => sense.xpath('description').text)
        end
      end
    end
    render text: 'success'
  end

  def fuzzy
    file_content = (params[:fuzzy][:file]).read.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    doc = Nokogiri::XML(file_content)
    doc.xpath('lemmaList/entry').each do |entry|
      if entry.xpath('body/derivations').text.length > 0
        if !Fuzzy.where(:title => entry.xpath('head/title').text).first
          Fuzzy.create(:title => entry.xpath('head/title').text, :derivations => better(entry.xpath('body/derivations').text))
        else
          fuzzy = Fuzzy.where(:title => entry.xpath('head/title').text).first
          fuzzy.derivations = (fuzzy.derivations.concat(better(entry.xpath('body/derivations').text))).uniq
          fuzzy.save
        end
      end
    end
  end

  protected
  def better(str)
    Rails.logger.info str
    if str.include? ','
      str.split ','
    elsif str.include? ';'
      str.split ';'
    else
      [str]
    end
  end

end
