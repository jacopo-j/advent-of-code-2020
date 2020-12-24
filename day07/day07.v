import os
import regex

fn parse_rule(rule string) (string, []string) {
	mut re := regex.regex_opt(r'(.+) bags contain (.+)\.') or { panic(err) }
	re.match_string(rule)
	color := re.get_group_by_id(rule, 0)
	rest := re.get_group_by_id(rule, 1).split(', ')
	mut contents := []string{}
	if rest[0] != 'no other bags' {
		re = regex.regex_opt(r'(\d+) (.+) bags?') or { panic(err) }
		for itm in rest {
			re.match_string(itm)
			for _ in 0 .. re.get_group_by_id(itm, 0).int() {
				contents << re.get_group_by_id(itm, 1)
			}
		}
	}
	return color, contents
}

fn make_graph(rules []string) map[string][]string {
	mut graph := map[string][]string{}
	for rule in rules {
		color, content := parse_rule(rule)
		graph[color] << content
	}
	return graph
}

fn find_shiny_gold(color string, graph map[string][]string) bool {
	mut seen := [color]
	mut queue := [color]
	for queue.len > 0 {
		cur := queue.pop()
		if seen.len > 1 && cur == 'shiny gold' {
			return true
		}
		for child in graph[cur] {
			if !(child in seen) {
				seen << child
				queue.prepend(child)
			}
		}
	}
	return false
}

fn count_sg_children(graph map[string][]string) int {
	mut queue := ['shiny gold']
	mut count := 0
	for queue.len > 0 {
		cur := queue.pop()
		for child in graph[cur] {
			count++
			queue.prepend(child)
		}
	}
	return count
}

// Bags are color-coded and must contain specific quantities of other 
// color-coded bags, according to the rules. You have a shiny gold bag.
// If you wanted to carry it in at least one other bag, how many
// different bag colors would be valid for the outermost bag?
fn part1(rules []string) int {
	graph := make_graph(rules)
	mut count := 0
	for color, _ in graph {
		if find_shiny_gold(color, graph) {
			count++
		}
	}
	return count
}

// How many individual bags are required inside your single
// shiny gold bag?
fn part2(rules []string) int {
	graph := make_graph(rules)
	return count_sg_children(graph)
}

fn main() {
	lines := os.read_lines('input.txt') or { panic(err) }
	rules := lines.filter(it != '')
	println('Part 1: ${part1(rules)}')
	println('Part 2: ${part2(rules)}')
}
