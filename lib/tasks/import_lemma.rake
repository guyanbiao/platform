desc "import dictionary"
task 'lemma:import' => :environment do
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

  file_content = (open(File.join(Rails.root, 'doc', 'lemma_list.xml'))).read.encode!('UTF-8', 'UTF-8', :invalid => :replace)
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

