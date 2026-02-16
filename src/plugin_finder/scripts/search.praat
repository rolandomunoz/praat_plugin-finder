#   search - Filter an index table object
#   Copyright (C) 2017-2026 Rolando Muñoz A. <rolando.muar@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <https://www.gnu.org/licenses/>.
#
#
cancel_btn = 1
apply_btn = 2
ok_btn = 3

config_path$ = "../preferences.txt"
index_table_path$ =  "../temp/index.Table"
tier_table_path$ = "../temp/tier_summary.Table"

script_name$# = {
	... "",
	... "open_files.praat",
	... "extract_files-dialog.praat",
	... "filter_search.praat",
	... "report_search.praat",
	... "report_frequency.praat"
	...}

temp_object# = selected#()

if not fileReadable(index_table_path$)
	@quit_dialog: "Create an index first. In the plug-in menu, go to ""Create index..."""
endif

tb_all_tiers = Read from file: tier_table_path$
tier_names$# = Get all texts in column: "tier"
tier_filenames$# = Get all texts in column: "filename"

removeObject: tb_all_tiers

selectObject: temp_object#
repeat
	@config.init: config_path$
	beginPause: "Search"
		optionMenu: "Tier name", number(config.init.return$["search.tier_name_option"])
			for i to size(tier_names$#)
				option: tier_names$#[i]
			endfor
		sentence: "Search for", config.init.return$["search.search_for"]
		optionMenu: "Mode", number(config.init.return$["search.mode"])
			option: "is equal to"
			option: "is not equal to"
			option: "contains"
			option: "does not contain"
			option: "starts with"
			option: "does not start with"
			option: "ends with"
			option: "does not end with"
			option: "contains a word equal to"
			option: "does not contain a word equal to"
			option: "contains a word starting with"
			option: "does not contain a word starting with"
			option: "contains a word ending with"
			option: "does not contain a word ending with"
			option: "matches (regex)"
			comment: "Next..."
		optionMenu: "Action", number(config.init.return$["search.do"])
			option: ""
			option: "View & Edit files..."
			option: "Extract files..."
			option: "Filter search..."
			option: "Search report"
			option: "Frequency report"
	clicked = endPause: "Cancel", "Apply", "OK", 3, 1

	if clicked == cancel_btn
		exitScript()
	endif

	@config.set_value: "search.tier_name_option", string$(tier_name)
	@config.set_value: "search.search_for", search_for$
	@config.set_value: "search.mode", string$(mode)
	@config.set_value: "search.do", string$(action)
	@config.set_value: "open_file.row", "1"
	@config.write

	# Make a search
	table_basename$ = "index_" + tier_filenames$#[tier_name] + ".Table"
	table_path$ = "../temp/'table_basename$'"
	tb_tier = Read from file: table_path$
	tb_search = nowarn Extract rows where column (text): "text", mode$, search_for$
	n_cases = object[tb_search].nrow

	Save as text file: "../temp/search.Table"
 	
	## Print Info
	writeInfoLine: "Search complete."
	appendInfoLine: ""
	appendInfoLine: "Pattern: ", """", search_for$, """"
	appendInfoLine: "Mode: ", """", mode$, """"
	appendInfoLine: "Tier: ", """", tier_name$, """"
	appendInfoLine: "Matches: ", n_cases
	appendInfoLine: ""

	if n_cases > 0
		appendInfoLine: "Unique Results"
		appendInfoLine: "--------------"

		selectObject: tb_search
		Append column: "tmp_count"
		Formula: "tmp_count", ~1

		tb_stats = Collapse rows: { "text" }, { "tmp_count" }, 
					... empty$# (0), empty$# (0),
					... empty$# (0), empty$# (0)

		labels$# = Get all texts in column: "text"
		count# = Get all numbers in column: "tmp_count"
		n_categories = size(labels$#)
		n_categories_tmp = if n_categories > 20 then 20 else n_categories fi
		for i to n_categories_tmp
			appendInfoLine: i, ": ", labels$#[i], " (= ", count#[i], ")"
		endfor
		if n_categories > 20
			appendInfoLine: "and more..."
		endif
		removeObject: tb_stats
	endif

	# Action
	if n_cases
		selectObject: tb_search
		if action > 1
			runScript: script_name$#[action]
		endif
	else
		@warning_dialog: "No results found. Please, make another search."
	endif

	removeObject: tb_tier, tb_search

until clicked = ok_btn

include ../procedures/config.proc
include _warning_dialogs.praat
