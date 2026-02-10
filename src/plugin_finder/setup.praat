# Copyright 2017-2026 Rolando Munoz Aramburú
if variableExists("plugin_dir$") == 0
    plugin_dir$ = "."
endif


# Define the version check logic
is_old = praatVersion < 6406
is_buggy_range = praatVersion > 6451 and praatVersion < 6460

if is_old or is_buggy_range
    appendInfoLine: "Plugin: Finder"
    
    if is_old
        appendInfoLine: "Warning: This plugin requires Praat version 6.4.06 or later."
    else
        appendInfoLine: "Warning: This plugin is incompatible with Praat version 'praatVersion$' due to internal bugs in this specific release."
    endif

    appendInfoLine: "Please update to the latest version of Praat."
    appendInfoLine: "Website: http://www.fon.hum.uva.nl/praat/"
    exitScript()
endif

# Return to default preferences
if not fileReadable("'plugin_dir$'/preferences.txt")
  pref$ = readFile$("'plugin_dir$'/preferences_default.txt")
  writeFile: "'plugin_dir$'/preferences.txt", pref$
endif

# Commands

## Static menu
Add menu command: "Objects", "Goodies", "Finder", "", 0, ""

### Query section
Add menu command: "Objects", "Goodies", "Create index...", "Finder", 1, "'plugin_dir$'/scripts/create_index-dialog.praat"
Add menu command: "Objects", "Goodies", "Search...", "Finder", 1, "'plugin_dir$'/scripts/search.praat"

### Do section
Add menu command: "Objects", "Goodies", "Tasks", "Finder", 1, ""
Add menu command: "Objects", "Goodies", "View & Edit files...", "Tasks", 2, "'plugin_dir$'/scripts/open_files.praat"
Add menu command: "Objects", "Goodies", "Extract files...", "Tasks", 2, "'plugin_dir$'/scripts/extract_files-dialog.praat"
Add menu command: "Objects", "Goodies", "Open script template", "Tasks", 2, "'plugin_dir$'/scripts/open_script_template.praat"
Add menu command: "Objects", "Goodies", "-", "Tasks", 2, "'plugin_dir$'/scripts/open_files.praat"
Add menu command: "Objects", "Goodies", "Search report", "Tasks", 2, "'plugin_dir$'/scripts/report_search.praat"
Add menu command: "Objects", "Goodies", "Frequency report", "Tasks", 2, "'plugin_dir$'/scripts/report_frequency.praat"
Add menu command: "Objects", "Goodies", "", "Tasks", 2, ""
Add menu command: "Objects", "Goodies", "Filter search...", "Tasks", 2, "'plugin_dir$'/scripts/filter_search.praat"

### Share section
Add menu command: "Objects", "Goodies", "Share", "Finder", 1, ""
Add menu command: "Objects", "Goodies", "Export search...", "Share", 2, "'plugin_dir$'/scripts/index_export.praat"
Add menu command: "Objects", "Goodies", "Import search...", "Share", 2, "'plugin_dir$'/scripts/index_import.praat"

### About section
Add menu command: "Objects", "Goodies", "-", "Finder", 1, ""
Add menu command: "Objects", "Goodies", "About", "Finder", 1, "'plugin_dir$'/scripts/about.praat"

## Dynamic menu
Add action command: "Table", 1, "", 0, "", 0, "Finder", "", 0, ""
Add action command: "Table", 1, "", 0, "", 0, "Import search", "Finder", 0, "'plugin_dir$'/scripts/index_import_from_praat_objects.praat"

### Create a local directory
createDirectory: "'plugin_dir$'/temp"
