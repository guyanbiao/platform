desc "import dictionary"
task 'dictionary:import' => :environment do
  doc = Nokogiri::XML((open(File.join(Rails.root, 'doc', 'dictionary.xml'))).read)
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
end
