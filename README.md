# craft-to-logseq

A shell script that converts [Craft](https://www.craft.do/) markdown documents to Logseq markdown files, handling pages, journals, and image paths.

⚠️ **IMPORTANT**: This script moves files to your specific Logseq `pages`,  `journals` and `assets` folders. Please backup your data before running the script. The author is not responsible for any data loss that may occur during the conversion process.

## Features

- Converts Craft markdown files to Logseq-compatible format
- Handles both pages and journal entries
- Migrates over inlined images correctly.
- Converts journal file names from yyyy.mm.dd.md to yyyy_mm_dd.md format


## Prerequisites

The script requires [`longdown`](https://github.com/dundalek/longdown) to be installed via npm:

```bash
npm install -g longdown
```

## Installation

There are two ways to install the script:

### Option 1: Homebrew (Recommended)

```bash
brew tap omair-inam/tap
brew install craft-to-logseq
```

### Option 2: Manual Installation

1. Download the script from this repository
2. Make it executable:
```bash
chmod +x craft_to_logseq.sh
```

## Exporting from Craft

Follow these steps for each Craft space you want to convert:

1. Open your Craft workspace
2. Select all documents you want to export (you can use Cmd+A to select all)
3. Right-click and select "Export X item(s) as"
4. Choose "Markdown" from the export options
5. Select a destination folder for your exported files 
   - Recommendation: Choose a folder path without spaces in the name

## Usage

```bash
craft-to-logseq --logseq-path /path/to/logseq --output-dir /path/to/output [--verbose]
```

Required arguments:
- `--logseq-path`: Path to your Logseq directory
- `--output-dir`: Temporary output directory for processing

Optional arguments:
- `--verbose`: Enable verbose output
- `--help`: Show help message

## Limitations

craftdocs links are not currently ported over correctly.  The script outputs a report of the Markdown files that need to be manually updated to correctly port over Craftdoc links

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.