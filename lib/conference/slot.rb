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

	#check if a slot is already full.
	def check_full(slot,session)		
		sum = slot.map{|a| a.time}.inject(0,:+)
		if sum == 180
			false
		else
			add_in_slot(sum,slot,session)
			true
		end
	end

	#check and add in a slot value. Recheck if a session needs to be removed/added in the  slot.
	def add_in_slot(sum,slot,session)
		flag = 0
		if (((sum + session.time) <= 180))
			slot << session
		else
			flag = 0
			slot.each do |el|
				 if (((sum + session.time) - el.time) == 180 && session.time != el.time)
					 flag = 1
					 slot.delete_at(slot.index(el))
					 @left_slots.push(el)
					 slot << session
					 @left_slots.delete(session) if @left_slots.include?(session)
					else	
				end
			end
			if flag == 0
				 @left_slots.push(session) if @left_slots.include?(session) == false
			end
		end
	end

end