#import "Basic";
#import "Windows";
#import "File";
#import "Machine_X64";
#import "String";

file_open_and_read_all :: (path : string) -> string
{
	file, open_success := file_open(path, false, true, true);
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

generate_input :: () -> string {
	builder : String_Builder;
	defer reset(*builder);
	
	file_content := file_open_and_read_all("input.txt");
	defer free(file_content);
	
	lines := split(file_content,"\n");
	
	print_to_builder(*builder, "u16.[");
	for lines {
		print_to_builder(*builder, "0b%\n,", it);
	}
	print_to_builder(*builder, "];");
	return builder_to_string(*builder);
}

ints := #insert #run generate_input();

puzzle_func :: ()
{	
	comparator := 0b100000000000;
	gamma : int;
	epsilon : int;
	
	for 0..11 {
		set_count := 0;
		unset_count := 0;

		for ints {
			value := it & comparator;
			if value != 0 {
				set_count += 1;
			}
			else {
				unset_count += 1;
			}
		}
		
		if set_count > unset_count {
			gamma = gamma | comparator;
			epsilon = epsilon & ~comparator;
		}
		else {
			epsilon = epsilon | comparator;
			gamma = gamma & ~comparator;
		}
		
		comparator = comparator >> 1;
	}
	
	print("%\n",formatInt(gamma, base=2));
	print("%\n",formatInt(epsilon, base=2));
	print("%\n",gamma*epsilon);
}

puzzle_func_2 :: ()
{
	comparator : u64 = 0b100000000000;
	
	o2 : [..]int;
	co2 : [..]int;	
	set_count := 0;
	unset_count := 0;
	
	for ints {
		value := it & comparator;
		if value != 0 {
			set_count += 1;
		}
		else {
			unset_count += 1;
		}
	}
	
	for ints {
		
	}
	
	for 0..11 {
		
		
		comparator = comparator >> 1;
	}
}

main :: ()
{
	begin_counter, end_counter, perf_frequency : s64;
	begin_cycle_count, end_cycle_count : u64;
	QueryPerformanceCounter(*begin_counter);
	QueryPerformanceFrequency(*perf_frequency);
	begin_cycle_count = rdtsc();
	
	puzzle_func();
	puzzle_func_2();
	
	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * 1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %us, MegaCycles : %, QPC : %\n", elapsed_time,
		  elasped_cycles / (1000*1000), end_counter - begin_counter);
}