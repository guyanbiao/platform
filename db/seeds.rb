%w[high middle primary].each do |level|
  doc = File.read(Rails.root + 'doc' + "#{level}.txt")
  arr = doc.split(/\r\n/)
  full_arr = arr.dup
  arr.each do |a|
  	puts a
  	fuzzy = Fuzzy.find_by(:title => a)
  	if fuzzy
  		fuzzy.derivations.map { |x| full_arr.push x if !full_arr.include? x}
  	end
  end
  Filter.create(:level => level, :members => arr, :full_members => full_arr)
end
