# Test @unixpath
@unixpath: "D:\Users\path"
assert unixpath.return$ == "D:/Users/path"

@unixpath: "D:\Users\path\abc.txt"
assert unixpath.return$ == "D:/Users/path/abc.txt"

@unixpath: "D:\Users\path\"
assert unixpath.return$ == "D:/Users/path/"


# Test @normpath
if unix
	@normpath: "D:\Users\path"
	assert normpath.return$ == "D:/Users/path"

	@normpath: "D:\Users\path\abc.txt"
	assert normpath.return$ == "D:/Users/path/abc.txt"

	@normpath: "D:\Users\path\"
	assert normpath.return$ == "D:/Users/path/"
elif windows
	@normpath: "D:/Users/path"
	assert normpath.return$ == "D:\Users\path"

	@normpath: "D:\Users\path\abc.txt"
	assert normpath.return$ == "D:\Users\path\abc.txt"

	@normpath: "D:\Users\path\"
	assert normpath.return$ == "D:\Users\path\"
endif


# Test @splitext_path

paths$# = {
... "/home/foo/abc.txt",
... "/home/foo/abc.wav.TextGrid",
... "/home/foo/abc.wav..TextGrid",
... "/home/foo/..TextGrid",
... "/home/foo",
... "/home/foo/",
... "/home/foo/.txt",
... "/home/foo/abc.",
... ""
...}

results_ext$# = {
... ".txt",
... ".TextGrid",
... ".TextGrid",
... ".TextGrid",
... "",
... "",
... "",
... "",
... ""
...}

for i to size(paths$#)
	@splitext_path: paths$#[i]
	assert splitext_path.return$#[2] == results_ext$#[i]
endfor


# Test @split_path

paths$# = {
... "/home/foo/abc.txt",
... "/home/foo/abc.wav.TextGrid",
... "/home/foo/abc.wav..TextGrid",
... "/home/foo/..TextGrid",
... "/home/foo",
... "/home/foo/",
... "/home/foo/.txt",
... "/home/foo/abc.",
... ""
...}

results$# = {
... "abc.txt",
... "abc.wav.TextGrid",
... "abc.wav..TextGrid",
... "..TextGrid",
... "foo",
... "",
... ".txt",
... "abc.",
... ""
...}

for i to size(paths$#)
	@split_path: paths$#[i]
	assert split_path.return$#[2] == results$#[i]
endfor


# Test: @join_path
@join_path: "/home/", {"abc", "dbc", "abc.txt"}
assert join_path.return$ == "/home/abc/dbc/abc.txt"

@join_path: "D:\\", {"Users", "abc.txt"}
assert join_path.return$ == "D:/Users/abc.txt"

@join_path: "/home/", {"abc", "////dbc", "abc.txt"}
assert join_path.return$ == "/home/abc/dbc/abc.txt"

@join_path: "/home/", {"abc", "////dbc", "abc.txt"}
assert join_path.return$ == "/home/abc/dbc/abc.txt"

# Test: @stem_path
@stem_path: "abc.txt"
assert stem_path.return$ == "abc"

@stem_path: "/home/foo/abc"
assert stem_path.return$ == "abc"

@stem_path: "/home/foo/abc.txt/"
assert stem_path.return$ == ""

#dst_dir$ ="/home/rolando/Documents/praat_plugins/praat_plugin-finder/tests/data_output/example/speaker"
#@iterate_path: dst_dir$

@make_dir: dst_dir$
assert folderExists(dst_dir$) == 1

include ../src/plugin_finder/procedures/paths.proc
