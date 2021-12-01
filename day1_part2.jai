#import "Basic";
#import "Windows";
#import "File";

main :: ()
{
	file, open_success := file_open("input1.txt", false, true, true);
	if !open_success {
		print("error opening file");
		return;
	}
	defer file_close(*file);
	
	file_contents, read_succes := read_entire_file(file, false);
	if !read_succes {
		print("error reading file");
		return;
	}
	defer free(file_contents);
	
	ints : [..]int;
	defer array_reset(*ints);
	
	cursor : string;
	cursor.data = file_contents.data;
	cursor.count = 0;
	
	//parse the file to ints.
	for 0..file_contents.count-1 {
		if is_space(file_contents[it]) {
			value, to_int_success := to_integer(cursor);
			if !to_int_success {
				print("to int error\n");
			}
			array_add(*ints, value);
			
			cursor.data += cursor.count+1;
			cursor.count = 0;
			continue;
		}		
		cursor.count += 1;
	}
	value, to_int_success := to_integer(cursor);	
	if !to_int_success {
		print("to int error\n");
	}
	
	array_add(*ints, value);	
	
	last_value := 0;
	increment_count := 0;
	for 0..ints.count-3 {
		new_value := ints[it] + ints[it+1] + ints[it+2];
		
		if last_value != 0 && new_value > last_value {
			increment_count += 1;
		}
		
		last_value = new_value;
	}	
	
	print("Increment Count %\n", increment_count);
}