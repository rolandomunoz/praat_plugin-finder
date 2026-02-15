#   Filter - Filter a search table
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
cancel_btn = 1
apply_btn = 2
ok_btn = 3

repeat
	@config.init: "../preferences.txt"
	if fileReadable("../temp/search.Table")
		search = Read from file: "../temp/search.Table"
		Append column: "temp"
	else
		@quit_dialog: "Make a search first"
	endif

	# Open the table containig all the tier names, then remove it before being displayed by the pause window
	tb_all_tiers = Read from file: "../temp/tier_summary.Table"
	tier_names$# = Get all texts in column: "tier"

	removeObject: tb_all_tiers

	beginPause: "Filter search"
		optionMenu: "Tier name", number(config.init.return$["filter_search.tier_name_option"])
		for i to size(tier_names$#)
			option: tier_names$#[i]
		endfor
		sentence: "Search for (Regex)", config.init.return$["filter_search.search_for"]
		comment: "Next..."
		optionMenu: "Action", number(config.init.return$["filter_search.do"])
			option: "Nothing"
			option: "View & Edit files..."
			option: "Extract files..."
			option: "Filter search..."
	clicked = endPause: "Cancel", "Apply", "OK", 3, 1

	if clicked = cancel_btn
		exitScript()
	endif

	@config.set_value: "filter_search.tier_name_option", string$(tier_name)
	@config.set_value: "filter_search.search_for", search_for$
	@config.set_value: "filter_search.do", string$(action)

	for i to object[search].nrow
		tg_path$ = object$[search, i, "path"]
		tmin = object[search, i, "tmin"]
		tmax = object[search, i, "tmax"]
		tmid = (tmax + tmin)*0.5
		tg = Read from file: tg_path$
		@index_tiers
		@get_tier_position: tier_name$
		tier = get_tier_position.return
		if tier
			interval = Get interval at time: tier, tmid
			interval_label$ = Get label of interval: tier, interval
			if index_regex(interval_label$, search_for$)
				selectObject: search
				Set numeric value: i, "temp", 1
			endif
		endif
		removeObject: tg
	endfor
	selectObject: search
	search_extracted = nowarn Extract rows where column (number): "temp", "equal to", 1
	Rename: "search"
	Remove column: "temp"

	removeObject: search
	writeInfoLine: "Filter search..."
	appendInfoLine: "Search pattern: ", search_for$
	appendInfoLine: "Tier name: ", tier_name$
	appendInfoLine: "Total number of occurrences: ", object[search_extracted].nrow

	if object[search_extracted].nrow
		@config.set_value: "open_file.row", "1"
		selectObject: search_extracted
		Save as text file: "../temp/search.Table"
		removeObject: search_extracted
		
		scriptName$# = {"", "open_files.praat", "extract_files-dialog.praat", "filter_search.praat"}
		if action > 1
			runScript: scriptName$#[action]
		endif
	endif
until clicked == ok_btn

include ../procedures/config.proc
include ../procedures/qtier.proc
include _warning_dialogs.praat
