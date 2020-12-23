import os

struct Point {
mut:
	x int
	y int
}

// Starting from the top left of a square map and climbing down with
// (3, 1) moves, count the number of `#` you encounter. The map has
// infinite (repeating) width.
fn part1(gmap []string) int {
	mut count := 0
	mut pos := Point{}
	for pos.y < gmap.len {
		if gmap[pos.y][pos.x % gmap[0].len] == `#` {
			count++
		}
		pos.x += 3
		pos.y++
	}
	return count
}

// Same as part1 but the result is given by multiplying the result of
// (1, 1), (3, 1), (5, 1), (7, 1), (1, 2) moves.
fn part2(gmap []string) i64 {
	mut result := i64(1)
	moves := [
		Point{1, 1},
		Point{3, 1},
		Point{5, 1},
		Point{7, 1},
		Point{1, 2}
	]
	for m in moves {
		mut pos := Point{}
		mut count := 0
		for pos.y < gmap.len {
			if gmap[pos.y][pos.x % gmap[0].len] == `#` {
				count++
			}
			pos.x += m.x
			pos.y += m.y
		}
		result *= count
	}
	return result
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	gmap := lines.filter(it != '')

	println('Part 1: ${part1(gmap)}')
	println('Part 2: ${part2(gmap)}')
}
