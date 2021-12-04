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


read_input :: (calls : *[..]int, tables : *[..][25]int)
{	
	file_contents := file_open_and_read_all("input.txt");	
	success, numbers_string, tables_string := split_from_left(file_contents, #char "\n");
	
	while numbers_string.count > 0 {
		number := parse_int(*numbers_string, int, " ,", DEFAULT_DELIMITERS);
		array_add(calls, number);
	}
	
	while tables_string.count > 0 {
		table : [25]int;
		for 0..24 {
			out_int := parse_int(*tables_string, int, " \t\n", DEFAULT_DELIMITERS);
			table[it] = out_int;
		}
		array_add(tables, table);
	}
}

table_wins_at :: (table : [25]int, calls: [..]int) -> int
{
	earliest_win := 99000;//arbitrarily high number because I can't remember the jai version of INT_MAX;
	//rows
	for 0..4 {
		row_count := it;
		highest_index := 0;
		for 0..4 {
			value := table[(row_count*5) + it];
			found, index := array_find(calls, value);
			if !found print("Gregory! There's been a terrible ham mistake!\n");
			
			if index > highest_index highest_index = index;
		}		
		if highest_index < earliest_win earliest_win = highest_index;
	}
	
	//columns
	for 0..4 {
		col_count := it;
		highest_index := 0;
		for 0..4 {
			value := table[(col_count) + it*5];
			found, index := array_find(calls, value);
			if !found print("Gregory! There's been a terrible ham mistake!\n");
			
			if index > highest_index highest_index = index;
		}		
		if highest_index < earliest_win earliest_win = highest_index;
	}
	return earliest_win;
}

score_table :: (table : [25]int, won_at : int, calls : [..]int) -> int
{
	won_at_value := calls[won_at];
	
	calls_up_to_win : []int;
	calls_up_to_win = calls;
	calls_up_to_win.count = won_at+1;
	score := 0;
	
	for table {
		if !array_find(calls_up_to_win, it) {
			score += it;
		}
	}
	
	return score * won_at_value;
}

puzzle_func :: (calls : [..]int, tables : [..][25]int)
{
	print("Day4 Puzzle 1 \n");
	
	earlist_win := 99000;
	winning_table := -1;
	for tables {
		value := table_wins_at(it, calls);
		if value < earlist_win {
			earlist_win = value;
			winning_table = it_index;
		}
	}
	print("Answer : %\n", score_table(tables[winning_table], earlist_win, calls));
}

puzzle_func_2 :: (calls : [..]int, tables : [..][25]int)
{
	print("Day4 Puzzle 1 \n");
	
	latest_win := 0;
	losing_table := -1;
	for tables {
		value := table_wins_at(it, calls);
		if value > latest_win {
			latest_win = value;
			losing_table = it_index;
		}
	}
	print("Answer : %\n", score_table(tables[losing_table], latest_win, calls));
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
		calls : [..]int;
		tables : [..][25]int;
		read_input(*calls, *tables);
		puzzle_func(calls, tables);
		puzzle_func_2(calls, tables);
	}
	reset_temporary_storage();
	
	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %ms, MegaCycles : %, QPC : %\n", elapsed_time,
		  elasped_cycles / (1000*1000), end_counter - begin_counter);
}