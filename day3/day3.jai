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
	
	print_to_builder(*builder, "int.[");
	for lines {
		print_to_builder(*builder, "0b%\n,", it);
	}
	print_to_builder(*builder, "];");
	return builder_to_string(*builder);
}

ints := #insert #run generate_input();

puzzle_func :: ()
{	
	comparator :int = 0b100000000000;
	gamma : int;
	epsilon : int;
	
	for 0..11 {
		set_count := 0;
		unset_count := 0;
		
		most_common := get_most_common_bit(ints, comparator);
		
		if most_common {
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

get_most_common_bit :: (values : []int, comparator : int, tie_breaker : bool = true) -> bool {
	set_count := 0;
	unset_count := 0;
	
	for values {
		value := it & comparator;
		if value != 0 {
			set_count += 1;
		}
		else {
			unset_count += 1;
		}
	}
	
	if set_count == unset_count return tie_breaker;
	
	return ifx set_count > unset_count then true else false;
}

get_least_common_bit :: (values : []int, comparator : int, tie_breaker : bool = true) -> bool {
	set_count := 0;
	unset_count := 0;
	
	for values {
		value := it & comparator;
		if value != 0 {
			set_count += 1;
		}
		else {
			unset_count += 1;
		}
	}
	
	if set_count == unset_count return tie_breaker;
	
	return ifx set_count > unset_count then false else true;
}

puzzle_func_2 :: ()
{
	comparator := 0b100000000000;
	
	o2 : [..]int;
	co2 : [..]int;
	
	most_common := get_most_common_bit(ints, comparator);
	
	for ints {
		if (it & comparator) > 0 == most_common {
			array_add(*o2, it);
		}
		else {
			array_add(*co2, it);
		}
	}
	
	print("%\n", o2);
	print("%\n", co2);
	
	while o2.count > 1 {
		comparator = comparator >> 1;
		most_common = get_most_common_bit(o2, comparator);
		
		for o2 {
			if (it & comparator) > 0 != most_common {
				remove it;
			}
		}
	}
	
	comparator = 0b100000000000;
	
	while co2.count > 1 {
		comparator = comparator >> 1;
		most_common = get_least_common_bit(co2, comparator, false);
		
		for co2 {
			if (it & comparator) > 0 != most_common {
				remove it;
			}
		}
	}
	
	print("o2 : %\n", o2[0]);
	print("o2 : %\n", co2[0]);
	print("answer : %\n", o2[0] *co2[0]);
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