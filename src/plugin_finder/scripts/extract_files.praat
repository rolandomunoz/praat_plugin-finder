#   extract_files - Extract files from a table
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
form: "Extract Sound & TextGrid"
	sentence: "sound_dirname", "."
	word: "sound_extension", ".wav"
	optionmenu: "Path type", 2
		option: "Relative to TextGrid location"
		option: "Absolute path"
	sentence: "search_table_path", "../temp/search.Table"
	folder: "dst_dirname", "C:\Users\lab\Desktop\test\folder_01-output"
	text: "name_format", "[Filename]-[DuplicateID]"
	real: "margin", "0.1"
endform

# [ID], [DuplicateID], [Filename], [Text]
# main
search = Read from file: search_table_path$
nrows = object[search].nrow
leading_zeros_default = 3
leading_zeros = length(string$(nrows))
leading_zeros = if leading_zeros_default > leading_zeros then leading_zeros_default else leading_zeros fi

file_counter= 0
for row to nrows
	# Get audio and annotation files paths
	tg_path$ = object$[search, row, "path"]

	# Get sound path
	sd_path$ = ""
	if path_type == 1
		# foo/abc.TextGrid -> foo
		@dirname: tg_path$
		tg_dir$ = dirname.return$

		# /home/abc.TextGrid -> abc.wav
		@stem_path: tg_path$
		stem$ = stem_path.return$
		sound_basename$ = stem$ + sound_extension$

		@join_path: tg_dir$, {sound_dirname$, sound_basename$}
		sd_path$ = join_path.return$
	else
		@stem_path: tg_path$, sound_extension$
		@basename: stem_path.return$
		sound_basename$ = basename.return$

		@join_path: sound_dirname$, {sound_basename$}
		sd_path$ = join_path.return$
	endif

	# Get matched text information
	text$ = object$[search, row, "text"]
	tmin = object[search, row, "tmin"]
	tmax = object[search, row, "tmax"]
	tmid = tmin + (tmax - tmin)/2

	# Open one by one all files
	if fileReadable(tg_path$) and fileReadable(sd_path$)
		file_counter+=1

		tg = Read from file: tg_path$
		sd = Open long sound file: sd_path$

		left_margin = if (tmin - margin) > 0 then margin else tmin fi
		right_margin = if (object[sd].xmax - tmax) >= margin then margin else object[sd].xmax-tmax fi

		## Extract TextGrid
		selectObject: tg
		tg_extracted = Extract part: tmin, tmax, "no"
		nocheck Extend time: left_margin, "Start"
		nocheck Extend time: right_margin, "End"
		Shift times to: "start time", 0

		## Extract audio
		selectObject: sd
		sd_extracted = Extract part: tmin - left_margin, tmax + right_margin, "no"

		# File names
		@zfill: string$(file_counter), leading_zeros
		numeric_id$ = zfill.return$

		new_name$ = replace$(name_format$, "[ID]", numeric_id$, 0)
		new_name$ = replace$(new_name$, "[Filename]", stem$, 0)
		new_name$ = replace$(new_name$, "[Text]", text$, 0)

		if index(new_name$, "[DuplicateID]")
			repetitionID = 0
			repeat
				repetitionID += 1
				@zfill: string$(repetitionID), leading_zeros
				repetitionID$ = zfill.return$
				new_name_test$= replace$(new_name$, "[DuplicateID]", repetitionID$, 0)
				tg_path_dst$ = dst_dirname$ + "/" + new_name_test$ + ".TextGrid"
			until !fileReadable(tg_path_dst$)
		else
			tg_path_dst$ = dst_dirname$ + "/" + new_name$ + ".TextGrid"
		endif

		# Create the destination directory for the TextGrid and audio files.
		# Because the output format allows for user-defined subfolders (via slashes
		# and tags), this code automatically generates the necessary directory
		# tree. This provides the flexibility to organize data across multiple
		# nested subdirectories.
		@dirname: tg_path_dst$
		tg_dirname_dst$ = dirname.return$
		@make_dir: tg_dirname_dst$

		# Save files
		selectObject: sd_extracted

		@swap_extension: tg_path_dst$, sound_extension$
		sd_path_dst$ = swap_extension.return$

		Save as WAV file: sd_path_dst$
		selectObject: tg_extracted
		Save as text file: tg_path_dst$
		removeObject: tg, tg_extracted, sd, sd_extracted
	endif
endfor

removeObject: search
writeInfoLine: "Extract Sound & TextGrid"
appendInfoLine: "Number of extracted files: ", file_counter * 2
appendInfoLine: "- Annotation files: ", file_counter
appendInfoLine: "- Sound files: ", file_counter

procedure zfill: .number$, .width
	.digits = length(.number$)
	if .digits < .width
		.zeroes$ = ""
		.max = (.width - .digits)
		for .i to .max
			.zeroes$ = .zeroes$ + "0"
		endfor
		.return$ = .zeroes$ + .number$
	else
		.return$ = .number$
	endif
endproc

include ../procedures/paths.proc
