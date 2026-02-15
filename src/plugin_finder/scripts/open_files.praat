#   open_files - Open a TextGrid and optionally a Sound in the TextGridEditor
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
message$= ". (= TextGrid location)"
sd_dirname$ = "."
cancel_btn = 1
apply_btn = 2
ok_btn = 3
sound_path = 1
sd_ext$ = ".wav"

repeat
	@config.init: "../preferences.txt"
	beginPause: "View & Edit files"
		sd_dirname$ = if sd_dirname$ == "." then message$ else sd_dirname$ fi
		text: 2, "Folder with sound files", sd_dirname$
		optionMenu: "Sound path", sound_path
			option: "Relative to TextGrid location"
			option: "Absolute path"
		word: "Sound file extension", sd_ext$
		comment: "Display settings..."
		real: "Margin", number(config.init.return$["open_file.margin"])
		boolean: "Include notes", number(config.init.return$["open_file.include_notes"])
		boolean: "Maximize volume (Scale peak)", number(config.init.return$["open_file.adjust_sound_level"])
	clicked = endPause: "Cancel", "Apply", "OK", 3, 1

	if clicked = 1
		exitScript()
	endif

	# Save in preferences
	@config.set_value: "open_file.margin", string$(margin)
	@config.set_value: "open_file.adjust_sound_level", string$(maximize_volume)
	@config.set_value: "open_file.include_notes", string$(include_notes)
	@config.write

	# Initial variables
	sd_dirname$ = folder_with_sound_files$
	sd_dirname$ = if sd_dirname$ == message$ then "." else sd_dirname$ fi
	sd_ext$ = sound_file_extension$
	relative_mode = sound_path
	row = number(config.init.return$["open_file.row"])
	pause = 1
	table_dir$ = "../temp/search.Table"
	volume = 0.99

	# Checking...

	## Check if a search is done
	if not fileReadable(table_dir$)
		@quit_dialog: "Make a search first"
	endif

	## Check if the search table have recorded cases
	search = Read from file: table_dir$
	if not object[search].nrow
		@quit_dialog: "Nothing to show. Please, make another search."
	endif

	# Start pause window
	n_rows = object[search].nrow
	while pause
		row = if row > n_rows then 1 else row fi
		#Get info from the search table
		text$ = object$[search, row, "text"]
		tg_path$ = object$[search, row, "path"]
		@basename: tg_path$
		tg_basename$ = basename.return$
		@swap_extension: tg_basename$, sd_ext$
		sd_basename$ = swap_extension.return$

		if relative_mode == 1
			sd_rel_dirname$ = sd_dirname$
			@dirname: tg_path$
			@join_path: dirname.return$, {sd_rel_dirname$, sd_basename$}
			sd_path$ =join_path.return$
		else
			# Absolute path
			@join_path: sd_dirname$, {sd_basename$}
			sd_path$ = join_path.return$
		endif
		tmin = object[search, row, "tmin"]
		tmax = object[search, row, "tmax"]
		tmid = (tmax - tmin)*0.5 + tmin
		tier$ = object$[search, row, "tier"]

		#Display
		tg = Read from file: tg_path$
		@getTierNumber
		tier = getTierNumber.return[tier$]
		sd = 0

		if fileReadable(sd_path$)
			if maximize_volume
				sd = Read from file: sd_path$
				Scale peak: volume
				show_volumne_widget = 1
			else
				sd = Open long sound file: sd_path$
				show_volumne_widget = 0
			endif
			plusObject: tg
		else
			show_volumne_widget = 0
		endif

		nowarn View & Edit
		editor: tg
		for i to tier - 1
			Select next tier
		endfor

		Select: tmin - margin, tmax + margin
		Zoom to selection
		Move cursor to: tmid

		beginPause: "View & Edit files"
			comment: "Item: 'row' of 'n_rows'"
			comment: "Label: " + if length(text$)> 25 then left$(text$, 25) + "..." else text$ fi
			comment: "File: " + tg_basename$
			natural: "Go to item", if (row + 1) > n_rows then 1 else row + 1 fi
			if show_volumne_widget
				real: "Volume", volume
			endif
			if include_notes
				text: 2, "Notes", object$[search, row, "notes"]
			endif
		clicked_finder = endPause: "Skip", "Save", "Quit", 1, 3
		endeditor

		if clicked_finder != 3
			if include_notes
				selectObject: search
				Set string value: row, "notes", notes$
				Save as text file: table_dir$
			endif
		endif

		if clicked_finder == 2
			selectObject: tg
			Save as text file: tg_path$
		endif

		removeObject: tg
		if sd
			removeObject: sd
		endif
		@config.set_value: "open_file.row", string$(row)

		if clicked_finder != 3
			row = go_to_item
		endif

		if clicked_finder == 3
			removeObject: search
			pause = 0
		endif
	endwhile

until clicked == ok_btn

include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/paths.proc
include _warning_dialogs.praat
