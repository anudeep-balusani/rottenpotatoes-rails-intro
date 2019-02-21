class Movie < ActiveRecord::Base
	def self.ratings_list
		self.all.uniq.pluck(:rating)
	end
end
