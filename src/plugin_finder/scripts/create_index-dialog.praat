#   create_index-dialog - UI for indexing TextGrid files into a Table object
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

# Constants
config_path$ = "../preferences.txt"
temp_directory$ = "../temp"
index_path$ = "'temp_directory$'/index.Table"
cancel_btn = 1
apply_btn = 2
ok_btn = 3

repeat
	@config.init: config_path$
	beginPause: "Create index"
		folder: "Folder with annotation files", config.init.return$["textgrids_dir"]
		word: "Annotation file extension:", "TextGrid"
		boolean: "Include subfolders", number(config.init.return$["create_index.include_subfolders"])
		boolean: "Keep empty intervals", number(config.init.return$["create_index.keep_empty_intervals"])
		comment: "Next..."
		optionMenu: "Action", number(config.init.return$["create_index.do"])
			option: ""
			option: "Search..."
	clicked = endPause: "Cancel","Apply", "OK", 3, 1

	# Stop
	if clicked == cancel_btn
		exitScript()
	endif

	textgrid_dir$ = folder_with_annotation_files$

	# Verify the data in the dialog
	if not folderExists(textgrid_dir$)
		@quit_dialog: "The directory ""'textgrid_dir$'"" does not exist."
		exitScript()
	endif


	# Set values
	@config.set_value: "textgrids_dir", textgrid_dir$
	@config.set_value: "create_index.do", string$(action)
	@config.set_value: "create_index.include_subfolders", string$(include_subfolders)
	@config.set_value: "create_index.keep_empty_intervals", string$(keep_empty_intervals)
	@config.set_value: "search.tier_name_option", "1"
	@config.set_value: "search.search_for", ""
	@config.set_value: "search.mode", "1"
	@config.set_value: "search.do", "1"
	@config.set_value: "filter_search.tier_name_option", "1"
	@config.set_value: "filter_search.search_for", ""
	@config.set_value: "filter_search.do", "1"
	@config.set_value: "open_file.row", "1"
	@config.set_value: "sounds_dir", "."
	@config.set_value: "extract_files.save_in", ""
	@config.write

	# Create an index
	runScript: "create_index.praat", textgrid_dir$, annotation_file_extension$, include_subfolders, keep_empty_intervals, temp_directory$

	if not fileReadable(index_path$)
		@warning_dialog: "No TextGrid files found"
	else
		if action == 2
			runScript: "search.praat"
		endif
	endif

until clicked == ok_btn

include ../procedures/config.proc
include ../procedures/list_recursive_path.proc
include ../procedures/paths.proc
include _warning_dialogs.praat
