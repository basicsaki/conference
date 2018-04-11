require ("./conference/parser.rb")
require ("./conference/validate_data.rb")
require ("./conference/algo.rb")
require ("./conference/print.rb")

parsed_data = Parser.new(ARGV[0])
parsed_data.process_data

v_data = ValidateData.new(parsed_data.processed_data)

validated_data = v_data.validate_data
v_data.stats_and_check_validations

if v_data.errors.length != 0
	puts "Please fix these errors below first \n"
	puts v_data.errors
else
	obj = Algo.new(validated_data)
	obj.algo
	obj.prepare_final_data
	print_obj = Print.new(obj.sorted_data)
	print_obj.print_output
	puts print_obj.print_arr
end
