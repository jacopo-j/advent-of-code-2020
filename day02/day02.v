import os
import regex

const (
	format = r'(\d+)-(\d+) (.): (.+)'
)

struct PolicyItem {
	min  int
	max  int
	char byte
	pass string
}

fn parse_policy(policy string) PolicyItem {
	mut re := regex.regex_opt(format) or { panic(err) }
	re.match_string(policy)
	return PolicyItem{
		min: re.get_group_by_id(policy, 0).int()
		max: re.get_group_by_id(policy, 1).int()
		char: re.get_group_by_id(policy, 2)[0]
		pass: re.get_group_by_id(policy, 3)
	}
}

// Each line gives the password policy and then the password.
// The password policy indicates the lowest and highest number of times
// a given letter must appear for the password to be valid.
// How many passwords are valid according to their policies?
fn part1(passwords []string) int {
	mut count := 0
	for item in passwords {
		policy := parse_policy(item)
		occ := policy.pass.count(policy.char.str())
		if occ >= policy.min && occ <= policy.max {
			count++
		}
	}
	return count
}

// Each policy now describes two positions in the password,
// where 1 means the first character, and so on.
// Exactly one of these positions must contain the given letter.
// How many passwords are valid according to the new interpretation
// of the policies?
fn part2(passwords []string) int {
	mut count := 0
	for item in passwords {
		policy := parse_policy(item)
		if (policy.pass[policy.min - 1] == policy.char) !=
			(policy.pass[policy.max - 1] == policy.char) {
			count++
		}
	}
	return count
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	vals := lines.filter(it != '')
	println('Part 1: ${part1(vals)}')
	println('Part 2: ${part2(vals)}')
}
