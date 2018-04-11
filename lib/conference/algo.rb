require_relative "./slot"

class Algo

attr_accessor :data_clone,:sorted_data #,:time,:title,:processed_data,:errors,:days,:remainder,:total_time,:result

	#init data
	def initialize(data)
		@data = data
	end

	def init_basic_elements
		@data_clone = @data
		@slot_1 = Slot.new(180)
		@slot_2 = Slot.new(240)
		@slot_3 = Slot.new(180)
		@slot_4 = Slot.new(240)
		@left_sessions = [] 
	end

	def check_full(slot,session)		
		sum = slot.sessions.map{|a| a.time}.inject(0,:+)
		if sum == 180
			false
		else
			add_to_slot(sum,slot,session)
			true
		end
	end

	#check and add in a slot value. Recheck if a session needs to be removed/added in the  slot.
	def add_to_slot(sum,slot,session)
		flag = 0
		if (((sum + session.time) <= 180))
			slot.sessions << session
		else
			flag = 0
			slot.sessions.each do |el|
				 if (((sum + session.time) - el.time) == 180 && session.time != el.time)
					 flag = 1
					 slot.sessions.delete_at(slot.sessions.index(el))
					 @left_sessions.push(el)
					 slot.sessions << session
					 @left_sessions.delete(session) if @left_sessions.include?(session)
					else	
				end
			end
			if flag == 0
				 @left_sessions.push(session) if @left_sessions.include?(session) == false
			end
		end
	end

	#match the sessions in the given time scope.
	def algo
		#4 slots for 2 days
		#morning slots to have near about 180 minutes as time can not go beyond lunch time
		#evening slots can have more time than morning ones. Therefore left slots are added afterwards.
		init_basic_elements

		#proc elements to contain the value from the switch case conditional
		add_to_slot_1 = Proc.new { |session| check_full(@slot_1,session) }
		add_to_slot_2 = Proc.new { |session| check_full(@slot_2,session) }
		add_to_slot_3 = Proc.new { |session| check_full(@slot_3,session) }
		add_to_slot_4 = Proc.new { |session| check_full(@slot_4,session) }

		#more the number of iterations better will be result. In case there is no possibility of addition of data elements to be exactly 180 or 240
		# or in case if the data elements do sum up to be 180. The add_to_slot returns with a false. so the number of iterations is significantly reduced.
		#This below is the scruffy logic which takes in consideration the fact that the data may 
		#not be consistent with the problem statement but can contain random values
		#needs more optimization however.

		#instead of predefined case switch the same can be done through meta programming.
		#new code will be written in optimized beta file in the same folder with extensive use of eval.

		(0..11).each do |n| 

		@data_clone.each do |session|
			case n 
			#every range can be replaced by 3.times do etc.	
			 when(0...2)
			 	case session
					when add_to_slot_1
					when add_to_slot_2
					when add_to_slot_3
					when add_to_slot_4
				end
			 when(3...5)
			 	case session
			 		when add_to_slot_2
					when add_to_slot_1
					when add_to_slot_3
					when add_to_slot_4
				end
			 when(6...9)
			 	case session
			 		when add_to_slot_3
					when add_to_slot_2
					when add_to_slot_1
					when add_to_slot_4
				end
			 else
				case session
			 		when add_to_slot_4
					when add_to_slot_3
					when add_to_slot_2
					when add_to_slot_1
				end
			 end
			end

			#for the last iteration check if any session/slot is left and add to evening slots.
			if (n == 11)
				@left_slots = @data - @slot_1.sessions - @slot_2.sessions - @slot_3.sessions - @slot_4.sessions
			else
				@data_clone = @left_sessions
				@left_sessions = []
			end

		end

		@left_sessions.each do |session|
			if @slot_2.sessions.map{|a| a.time}.inject(0,:+) + session.time <= 240
				@slot_2.sessions << session
			else
				@slot_4.sessions << session
			end
		end
		#based on the data in 4 arrays slot1 slot2 slot3 slot4 add in the data elements
	end

	def prepare_final_data
		lunch_time = Session.new("","Lunch",60,"" )
		networking_time = Session.new("","Networking Event",nil,"" )
		track_title_1 = Session.new("","Track 1:",nil,"")
		track_title_2 = Session.new("","Track 2:",nil,"")
		#Track 1
		@sorted_data = [track_title_1] + @slot_1.sessions + [lunch_time] + @slot_2.sessions + [networking_time] + [track_title_2] + @slot_3.sessions + [lunch_time] + @slot_4.sessions + [networking_time]
	end

end