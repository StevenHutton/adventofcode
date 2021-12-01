#import "Basic";
#import "Windows";
#import "File";

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

main :: ()
{
	ints := #insert #run generate_input_ints();
	
	last_value := 0;
	increment_count := 0;
	for ints {
		if last_value != 0 && it > last_value {
			increment_count += 1;
		}
		
		last_value = it;
	}	
	
	print("Increment Count %\n", increment_count);
}