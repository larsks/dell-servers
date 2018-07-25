# Replace lines of the form:
#
# #include filename
#
# with the content of the reference file.
/^#include/ {
	while ( (getline line < $2) > 0) {
		print line
		}
		close($2)
		next
	}

# Replace lines of the form
#
# #exec command
#
# with the output produced by running the command.
/^#exec/ {
	$1 = ""
	while ( ($0 | getline line) > 0) {
		print line
		}
		close($0)
		next
	}

{print}
