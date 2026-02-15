# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- `Create index...`: Improved character handling in tier names to prevent
	crashes and support special characters (`/\:*?"<>`) and 
	whitespace (`\t\n`).

### Changed

- Update documentation website.
- `Create index...`: verify if input directory exists before running the command.
- `Create index...`: Use `folder` type instead of `text` in  the TextGrid directory field.
- `Extract files...`: Use `folder` type instead of `text` in 'Save in' field.
- UI: Refined dialog labels for better clarity.

## [v2.3.1] - 2025-08-11

### Changed

- `View & Edit files`: Prevented unintended volume entry from appearing when opening `LongSound` objects.
- `View & Edit files`: Resolved a runtime issue caused by an uninitialized variable when exiting via the `Quit` button.

## [v2.3.0] - 2022-05-01

### Added

- New procedures

### Changed

- Changes in dialog windows

## [v2.2.0] - 2020-07-04

### Fixed

- `View & Edit` files and `Extract files` fully support any filename characters (white spaces and others).

## [v2.1.0] - 2020-04-02

### Added

- Create Table Search report
- Create Table Frequency report

## [v2.0.1] - 2018-05-09

### Added

- Error message: Create an index before doing a search

### Changed

- Minor changes in plug-in menu

## [v2.0.0] - 2018-05-06

### Added

- New command 'Open script template'
- New command in the Object window when selecting a Table, 'Import search'
- Search: update search mode
- Search: select between a list of commands what comes next after doing a search
- Create Index: select between a list of commands what comes next after indexing

### Changed

- Rename the plug-in
- Commands has been renamed
- Commands use the Info window to show messages
- More detailed messages for all commands
- New buttons in the dialogue boxes: Cancel, Apply and 'Ok'
- A better interface for the command 'Filter Search...'
- Support relative paths: audio file paths can be defined in relation to the location of their TextGrid files. 
- 'Import search' check the column names
  
### Fixed

- A bug in 'Extract files...'. Intervals are extracted with the correct margin.

## [v1.0.0] - 2018-03-13

#### Added

- Command: `Create index`
- Command: `Query by tier name...`
- Command: `Export query...`
- Command: `Import query...`
- Command: `View & Edit files...`
- Command: `Extract files...`
- Command: `Filter query...`
- Command: `About`
