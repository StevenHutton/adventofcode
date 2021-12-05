#import "Basic";
#import "Windows";
#import "File";
#import "Machine_X64";
#import "String";
#import "Math";

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

line_segment :: struct {
	x1,y1,x2,y2:int;
}

point :: struct {
	x, y : int;
}

operator== :: (a : point, b : point) -> bool {
	return a.x == b.x && a.y == b.y;
}

read_input :: () -> [..]line_segment
{
	line_segments : [..]line_segment;
	
	file_contents := file_open_and_read_all("input.txt");	
	lines := split(file_contents, "\n");
	for lines {
		segment : line_segment;
		segment.x1 = parse_int(*it, int, " ->\t\n,");
		segment.y1 =  parse_int(*it, int, " ->\t\n,");
		segment.x2 =  parse_int(*it, int, " ->\t\n,");
		segment.y2 =  parse_int(*it, int, " ->\t\n,");
		
		using segment;
		if x1 == x2 || y1 == y2 array_add(*line_segments, segment);
		//if abs(x1-x2) == abs(y1-y2) array_add(*line_segments, segment);
	}
	return line_segments;
}

is_in_range :: (using seg : line_segment, p: point) -> bool
{
	min_x := min(x1, x2);
	max_x := min_x + abs(x1 - x2);
	min_y := min(y1, y2);
	max_y := min_y + abs(y1 - y2);
	
	return p.x >= min_x && p.x <= max_x && p.y >= min_y && p.y <= max_y;
}

puzzle_func :: (segments : [..]line_segment)
{
	points : [..]point;
	for segments {
		seg1 := it;
		for it_index+1..segments.count-1 {
			seg2 := segments[it];
			
			//both lines vertical
			if (seg1.x1 - seg1.x2) == (seg2.x1 - seg2.x2) {
				//check to see if they overlap then continue
				if(seg1.x1 == seg2.x1 && seg1.x2 == seg2.x2)
				{
					//if they overlap figure out how many shared points there are
					min_s1 := min(seg1.y1, seg1.y2);
					min_s2 := min(seg2.y1, seg2.y2);
					max_s1 := max(seg1.y1, seg1.y2);
					max_s2 := max(seg2.y1, seg2.y2);
					start := max(min_s1, min_s2);
					end := min(max_s1, max_s2);
					
					for start..end {
						p : point;
						p.x = seg1.x1;
						p.y = it;
						
						found := false;
						for points if it == p found = true;
						
						if !found array_add(*points, p);
					}
				}
				continue;
			}
			//both lines horizontal
			if (seg1.y1 - seg1.y2) == (seg2.y1 - seg2.y2) {				
				//check to see if they overlap then continue
				if(seg1.y1 == seg2.y1 && seg1.y2 == seg2.y2)
				{
					//if they overlap figure out how manx shared points there are
					min_s1 := min(seg1.x1, seg1.x2);
					min_s2 := min(seg2.x1, seg2.x2);
					max_s1 := max(seg1.x1, seg1.x2);
					max_s2 := max(seg2.x1, seg2.x2);
					start := max(min_s1, min_s2);
					end := min(max_s1, max_s2);
					
					for start..end {
						p : point;
						p.x = it;
						p.y = seg1.y1;
						
						found := false;
						for points if it == p found = true;
						
						if !found array_add(*points, p);
					}
				}
				continue;
			}
			
			//if we got this far the lines are perpendicular - find the intersection
			pos : point;
			//if line 1 is vertical
			if seg1.x1 - seg1.x2 == 0 {
				pos.x = seg1.x1;
				pos.y = seg2.y1;
			} else {
				pos.x = seg2.x1;
				pos.y = seg1.y1;
			}
			
			if !is_in_range(seg1, pos) || !is_in_range(seg2, pos) continue;
			
			found := false;
			for points if it == pos found = true;
			if !found array_add(*points, pos);
		}
	}
	print("points count : %\n", points.count);
}

puzzle_func_2 :: (){}

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
		line_segments := read_input();
		puzzle_func(line_segments);
		puzzle_func_2();
	}
	reset_temporary_storage();
	
	QueryPerformanceCounter(*end_counter);
	end_cycle_count = rdtsc();
	elasped_cycles := end_cycle_count - begin_cycle_count;
	elapsed_time := (1000 * (cast(float)(end_counter - begin_counter))) / perf_frequency;
	
	print("Time : %ms, MegaCycles : %, QPC : %\n", elapsed_time,
		  elasped_cycles / (1000*1000), end_counter - begin_counter);
}