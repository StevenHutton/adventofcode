#import "Basic";
#import "Windows";
#import "File";
#import "Machine_X64";
#import "String";

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

direction :: enum {
	down;
	forward;
	up;
}

puzzle_func :: ()
{
	file_content_prime := file_open_and_read_all();
	defer free(file_content_prime);
	
	file_content := file_content_prime;	
	
	out_int : int;
	out_dir : direction;
	success : bool;
	
	depth : s32 = 0;
	pos : s32= 0;
	while file_content.count > 0 {		
		out_dir, success = parse_enum(*file_content, direction, DEFAULT_DELIMITERS, " \t\n");
		out_int, success = parse_int(*file_content, int, " \t\n", DEFAULT_DELIMITERS);
		
		if out_dir == {
			case .down;
			{
				depth += xx out_int;
			}
			case .forward;
			{
				pos += xx out_int;
			}
			case .up;
			{
				depth -= xx out_int;
				if depth < 0 depth = 0;
			}
		}
	}
	
	print("Depth : %\n", depth);
	print("Horizontal Pos : %\n", pos);
	print("Solution : %\n", pos*depth);
}

main :: ()
{
	begin_counter, end_counter, perf_frequency : s64;
	begin_cycle_count, end_cycle_count : u64;
	QueryPerformanceCounter(*begin_counter);
	QueryPerformanceFrequency(*perf_frequency);
	begin_cycle_count = rdtsc();
	
	puzzle_func();

	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * 1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %us, MegaCycles : %, QPC : %\n", elapsed_time,
		  elasped_cycles / (1000*1000), end_counter - begin_counter);
}