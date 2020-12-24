import os

// For each of the people in their group, you write down the questions
// for which they answer "yes", one per line.
// For each group, count the number of questions to which anyone
// answered "yes". What is the sum of those counts?
fn part1(vals []string) int {
	mut count := 0
	for val in vals {
		mut seen := []byte{}
		for char in val {
			if char != `\n` && !(char in seen) {
				count++
				seen << char
			}
		}
	}
	return count
}

// For each group, count the number of questions to which *everyone*
// answered "yes". What is the sum of those counts?
fn part2(vals []string) int {
	mut count := 0
	for val in vals {
		num_people := val.split('\n').filter(it != '').len
		mut seen := map[string]int{}
		for char in val {
			if char != `\n` {
				char_str := char.str() // maps can only have string keys
				if !(char_str in seen) {
					seen[char_str] = 1
				} else {
					seen[char_str]++
				}
				if seen[char_str] == num_people {
					count++
				}
			}
		}
	}
	return count
}

fn main() {
	batch := os.read_file('input.txt') or { panic(err) }
	vals := batch.split('\n\n').filter(it != '')
	println('Part 1: ${part1(vals)}')
	println('Part 2: ${part2(vals)}')
}
