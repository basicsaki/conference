class Session

	attr_accessor :id, :time, :title, :errors

	def initialize( id = nil , title = nil, time = nil, errors = nil )
		@id = id
		@title = title
		@time = time
		@errors = errors
	end

end