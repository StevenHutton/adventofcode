#import "Basic";
#import "Windows";
#import "File";
#import "Machine_X64";

file_open_and_read_all :: () -> string
{
	file, open_success := file_open("input2.txt", false, true, true);
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
	return file_contents;
}

puzzle_func :: ()
{
	
}

puzzle_func_2 :: ()
{
	
}

main :: ()
{
	begin_counter, end_counter, perf_frequency : s64;
	begin_cycle_count, end_cycle_count : u64;
	QueryPerformanceCounter(*begin_counter);
	QueryPerformanceFrequency(*perf_frequency);
	begin_cycle_count = rdtsc();
	
	temp_context := context;
	temp_context.allocator = temp;
	
	push_context temp_context {							
		puzzle_func();
		puzzle_func_2();
	}
	reset_temporary_storage();
	
	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * 1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %us, MegaCycles : %, QPC : %\n", elapsed_time,
		  elasped_cycles / (1000*1000), end_counter - begin_counter);
}