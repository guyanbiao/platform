%w[high middle primary].each do |level|
  doc = File.read(Rails.root + 'doc' + "#{level}.txt")
  arr = doc.split(/\r\n/)
  Filter.create(:level => level, :members => arr)
end
