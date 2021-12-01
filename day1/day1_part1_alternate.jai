#import "Basic";
#import "Windows";
#import "File";
#import "Machine_X64";

//why read in the file when you can compile it directly into the code?
generate_input_ints :: () -> string {
		builder : String_Builder;
		defer reset(*builder);
			
		file, open_success := file_open("input1.txt", false, true, true);
		if !open_success {
			print("error opening file");
			return "";
		}
		defer file_close(*file);
			
		file_contents, read_succes := read_entire_file(file, false);
		if !read_succes {
			print("error reading file");
			return "";
		}
		defer free(file_contents);
			
		for 0..file_contents.count-1 {
			if file_contents[it] == #char "\n" file_contents[it] = #char ",";
		}
			
		print_to_builder(*builder, "int.[");
		print_to_builder(*builder, file_contents);
		print_to_builder(*builder, "];");
		return builder_to_string(*builder);
}

timer_macro :: (code : Code) -> float #expand {
	begin_counter, end_counter, perf_frequency : s64;
	begin_cycle_count, end_cycle_count : u64;
	QueryPerformanceCounter(*begin_counter);
	QueryPerformanceFrequency(*perf_frequency);
	begin_cycle_count = rdtsc();

	#insert code;

	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %ms, MegaCycles : %, QPC : %\n", elapsed_time, elasped_cycles / (1000*1000), end_counter - begin_counter);
	return elapsed_time;
}

ints := #insert #run generate_input_ints();

main :: ()
{
	increment_count := 0;
	timer_macro(#code {									
			last_value := 0;
					
			for ints {
				if last_value != 0 && it > last_value {
					increment_count += 1;
				}
				
				last_value = it;
			}			
		}
	);
	
	print("Increment Count %\n", increment_count);	
}