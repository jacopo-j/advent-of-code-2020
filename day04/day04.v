import os
import regex

fn validate_year(str string, typ string, min int, max int) bool {
	mut re := regex.regex_opt(typ + r':(\d{4})\s') or { panic(err) }
	start, _ := re.find(str)
	if start < 0 {
		return false
	}
	year := re.get_group_by_id(str, 0).int()
	return year >= min && year <= max
}

fn validate_height(str string) bool {
	mut re := regex.regex_opt(r'hgt:(\d+)((cm)|(in))') or { panic(err) }
	start, _ := re.find(str)
	if start < 0 {
		return false
	}
	height := re.get_group_by_id(str, 0).int()
	unit := re.get_group_by_id(str, 1)
	return match unit {
		'cm' { height >= 150 && height <= 193 }
		'in' { height >= 59 && height <= 76 }
		else { false }
	}
}

fn validate_regex(str string, exp string) bool {
	mut re := regex.regex_opt(exp) or { panic(err) }
	start, _ := re.find(str)
	return start >= 0
}

// Calculate the number of passports that contain all the required
// properties.
fn part1(vals []string) int {
	props := ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
	mut count := 0
	p_loop: for passport in vals {
		for prop in props {
			if !(prop + ':' in passport) {
				continue p_loop
			}
		}
		count++
	}
	return count
}

// Calculate the number of passports whose properties pass the
// validation.
fn part2(vals []string) int {
	mut count := 0
	for passport in vals {
		if validate_year(passport, r'byr', 1920, 2002) && validate_year(passport, r'iyr', 2010, 2020) &&
			validate_year(passport, r'eyr', 2020, 2030) && validate_height(passport) && validate_regex(passport, r'hcl:#[0-9a-f]{6}\s') &&
			validate_regex(passport, r'ecl:((amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth))') && validate_regex(passport, r'pid:\d{9}\s') {
			count++
		}
	}
	return count
}

fn main() {
	batch := os.read_file('input.txt') or { panic(err) }
	vals := batch.split('\n\n').filter(it != '').map(it + '\n')
	// Note that a trailing '\n' was added to each "passport" in order
	// to workaround a bug (#7522) the current version of the regex
	// library, which does not match the '$' in '(\s|$)'. This way,
	// using '\s' is enough.
	println('Part 1: ${part1(vals)}')
	println('Part 2: ${part2(vals)}')
}
