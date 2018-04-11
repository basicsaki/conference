class Slot
	attr_accessor :maximum_value,:sum,:sessions

	def initialize(maximum_value = 180)
		@maximum_value = maximum_value
		@sessions = [] 
	end

	def slot_space_left?
		self.sum == 180 ? false : true
	end

	def sum
		@sum = self.sessions.map{|a| a.time}.inject(0,:+)
	end
	
end