import os
import strconv

fn seat_id(code string) i64 {
	row_code := code[0..7].replace('F', '0').replace('B', '1')
	col_code := code[7..10].replace('L', '0').replace('R', '1')
	row_numb := strconv.parse_int(row_code, 2, 0)
	col_numb := strconv.parse_int(col_code, 2, 0)
	return row_numb * 8 + col_numb
}

// This airline uses binary space partitioning to seat people.
// The first 7 characters will either be F or B; these specify
// exactly one of the 128 rows on the plane. The last three characters
// will be either L or R; these specify exactly one of the 8 columns
// of seats on the plane. What is the highest seat ID?
fn part1(vals []string) i64 {
	mut max := i64(0)
	for seat in vals {
		id := seat_id(seat)
		if id > max {
			max = id
		}
	}
	return max
}

// Your seat should be the only missing boarding pass in your list.
// The seats with IDs +1 and -1 from yours will be in your list.
// What is the ID of your seat?
fn part2(vals []string) ?i64 {
	mut pass_list := []i64{cap: 1024}
	for seat in vals {
		pass_list << seat_id(seat)
	}
	for id in 1 .. 1023 {
		if !(id in pass_list) && (id - 1) in pass_list && (id + 1) in pass_list {
			return id
		}
	}
	error('Seat not found!')
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	vals := lines.filter(it != '')
	println('Part 1: ${part1(vals)}')
	if res2 := part2(vals) {
		println('Part 2: $res2')
	} else {
		eprintln(err)
	}
}
