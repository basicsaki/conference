require_relative ("./session.rb")

class Parser

	attr_accessor :data,:processed_data

	#initialize a new conference settings
	def initialize(path = "")
		path = "" if path.nil?
		data = File.open(path,"r"){|f| f.read} if File.exists?(path)
		@data = data.nil? ? mock_data : data
	end

	#incase data is not provided when the operation is called
	def mock_data
		puts "Failsafe. Using mock data as no data is provided or the file path is not a complete file path or file does not exist"
		data = File.open("./conference/data/problem_data.txt","r+") do |f|
			f.read
		end 
		return data
	end

	#process the data provided to get a confined hash
	def process_data
		arr = data.split("\n")
		@processed_data = []
		arr.each_with_index do |string,a|
			time_index = string.index( /[0-9]min|lightning/ )
			if time_index != nil 
				time_arr = []
				(0..2).each do |n|
					time = string[time_index-n]
					time_arr << time if ( time != " " && time.index(/[a-z]/)==nil )
				end
				time = time_arr.reverse.join("").strip.to_i
				title = string.gsub(/#{time}min|#{time}lightning/,"").strip
				if string.index( /lightning/ )==nil
				  time   
				else
				  time = (time == 0? 5 : (time*5))
				end
				session = Session.new(a,title,time)
				@processed_data << session
			end
		end
	end

end