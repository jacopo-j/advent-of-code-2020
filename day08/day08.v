import os

fn run_until_loop(code []string, i_pos int, i_acc int) (bool, int) {
	mut pos := i_pos
	mut acc := i_acc
	mut seen := []int{}
	for pos < code.len {
		if pos in seen {
			return true, acc
		}
		seen << pos
		instr := code[pos].split(' ')
		if instr[0] == 'jmp' {
			pos += instr[1].int()
		} else if instr[0] == 'acc' {
			acc += instr[1].int()
			pos++
		} else {
			pos++
		}
	}
	return false, acc
}

// Each instruction consists of an operation and an argument.
// Immediately before any instruction is executed a second time,
// what value is in the accumulator?
fn part1(code []string) int {
	_, acc := run_until_loop(code, 0, 0)
	return acc
}

// Exactly one instruction is corrupted: either a jmp is supposed
// to be a nop, or vice versa. Repair the code to make it terminate.
// What is the value of the accumulator after the program terminates?
fn part2(code []string) ?int {
	mut acc := 0
	mut pos := 0
	mut tried := []int{}
	for {
		instr := code[pos].split(' ')
		if instr[0] == 'acc' {
			acc += instr[1].int()
			pos++
		} else {
			if pos in tried {
				if instr[0] == 'jmp' {
					pos += instr[1].int()
				} else {
					pos++
				}
			} else {
				tried << pos
				mut new_code := code.clone()
				if instr[0] == 'jmp' {
					new_code[pos] = code[pos].replace('jmp', 'nop')
				} else {
					new_code[pos] = code[pos].replace('nop', 'jmp')
				}
				loop, result := run_until_loop(new_code, pos, acc)
				if !loop {
					return result
				}
			}
		}
	}
	error('Solving failed')
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	code := lines.filter(it != '')
	println('Part 1: ${part1(code)}')
	if res2 := part2(code) {
		println('Part 2: $res2')
	} else {
		eprintln(err)
	}
}
