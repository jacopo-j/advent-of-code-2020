import os

// take a list of integers and find two whose sum is 2020;
// return the product of these integers
fn part1(vals []int) ?int {
	for val in vals {
		compl := 2020 - val
		if compl in vals {
			return val * compl
		}
	}
	return error('No solution found for part 1!')
}

// take a list of integers and find *three* whose sum is 2020;
// return the product of these integers
fn part2(vals []int) ?int {
	for val1 in vals {
		for val2 in vals {
			compl := 2020 - val1 - val2
			if compl in vals {
				return val1 * val2 * compl
			}
		}
	}
	return error('No solution found for part 1!')
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	vals := lines.filter(it != '').map(it.int())
	if res1 := part1(vals) {
		println('Part 1: $res1')
	} else {
		eprintln(err)
	}
	if res2 := part2(vals) {
		println('Part 2: $res2')
	} else {
		eprintln(err)
	}
}
