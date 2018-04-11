class Print

	attr_accessor :print_arr

	def initialize(sorted_data)
		@data = sorted_data
	end

	#prepare data for output
	def print_output
		@str = []
		print_slot(@data)
		@print_arr = @str.join("\n")
	end

	#slot wise output
	def print_slot(slot)
		time = Time.new
		slot.each do |session|
			slot_time = "#{session.time}min" if session.time!=""
			if session.time == nil
				hr_time = ""
				slot_time = ""
			else
				time = Time.new(2018,3,3,12,00,00) if session.title == "Lunch"
				hr_time = time.strftime('%I:%M%p')
				slot_time = session.title != "Lunch" ? "#{session.time}min" : "" 
			end

			hr_time = Time.new(2018,3,3,17,00,00).strftime('%I:%M%p') if session.title == "Networking Event"

			@str << "#{hr_time} #{session.title} #{slot_time}"
			time = session.time == nil ? Time.new(2018,3,3,9,00,00) : time + session.time*60 
		end
		return time
	end

end