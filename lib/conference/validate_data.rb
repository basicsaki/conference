class ValidateData

	attr_accessor :validated_data, :errors

	def initialize(processed_data)
		@processed_data = processed_data
	end

	def validate_data
		@validated_data = []

		@processed_data.each do |p|
			errors = check_error(p.time,p.title)
			p.errors = errors if errors
			@validated_data << p
		end
	end

	#define the stats and check the validations
	def stats_and_check_validations
		#puts "Printing the stats for the validations \n \n"
		@total_time = 0
		@errors = []

		@validated_data.each do |p|
			@total_time = @total_time + p.time
			if p.errors!=nil
				@errors << p.title.concat("      --------->      #{p.errors}")
			end
		end
	end

	#add/remove validations
	def check_error(time,title)
		if time > 60
			return "Time is greater than one hour for this session."
		#elsif (time % 5 != 0)
		#	return "Time should be a multiple of 5"
		elsif title.index(/[0-9]/) != nil
			return "Title contains a number which is not allowed."
		end
	end

end