# CSV Module

The CSV module provides fast analytics over CSV/TSV data with DuckDB SQL and optional matplotlib plots. It wraps the `bin/csvql.py` Python helper to make data analysis effortless and consistent.

## Overview

The CSV module is designed to streamline data analysis workflows by providing:

- **SQL Analytics**: Query CSV/TSV files with familiar SQL syntax using DuckDB backend
- **Visualization**: Create scatter, line, and bar plots with matplotlib
- **Session Management**: Manage default settings via dedicated `csv:set:*`, `csv:get:*`, and `csv:unset:*` commands
- **Golf-Specific Features**: Optional overlays for golf hole outlines and bullseye rings
- **Virtual Environment**: Automatically bootstrap local Python environment with dependencies

## Quick Start

```bash
# Initialize CSV tools
caddie csv:init

# Set up a workflow session
caddie csv:set:file target/putt_data.csv
caddie csv:set:x target_distance
caddie csv:set:y success_rate

# Query your data
caddie csv:query "SELECT * FROM df WHERE distance > 20"

# Create visualizations
caddie csv:scatter --rings --ring_radii "3,6,9"
```

## Commands

### Environment Setup

#### `caddie csv:init`

Initialize or update the local csvql virtual environment.

**Examples:**
```bash
# Initialize CSV environment
caddie csv:init

# Update environment (idempotent)
caddie csv:init
```

**What it does:**
- Creates or updates a self-contained Python virtual environment
- Installs required dependencies (DuckDB, pandas, matplotlib)
- Records pinned versions in `requirements.txt`
- Sets up Python environment for CSV operations

**Output:**
```
Setting up csvql environment
✓ csvql environment ready
```

**Requirements:**
- macOS or Linux with Python 3.10+
- Network access for downloading dependencies
- Internet connection for dependency installation

**Idempotent:** Yes - can be run multiple times safely

### Data Query and Analysis

#### `caddie csv:query [file] [sql] [-- flags]`

Execute SQL queries on CSV/TSV files using DuckDB.

**Arguments:**
- `file`: (optional) Path to CSV/TSV file (uses default if not provided)
- `sql`: (optional) SQL query (uses default if not provided)
- Additional flags passed to csvql.py

**Examples:**
```bash
# Query with default settings
caddie csv:query

# Query specific file
caddie csv:query data.csv

# Custom SQL query
caddie csv:query "SELECT COUNT(*) FROM df"

# Complex analysis
caddie csv:query "SELECT distance, AVG(success_rate) FROM df GROUP BY distance ORDER BY distance"
```

**What it does:**
- Loads CSV/TSV file into DuckDB database

- Executes SQL query against the data
- Returns results in tabular format
- Automatically summarizes large result sets (>20 rows)

**Output:**
```
Running csvql on putt_data.csv
distance  avg_success_rate
---------  ---------------
1.5       0.95
4.5       0.72
7.5       0.48
10.5      0.34
15.0      0.19
21.0      0.12
27.0      0.08
35.0      0.04
```

**Requirements:**
- CSV file must have header row
- File must be readable (permissions)
- SQL syntax compatible with DuckDB

#### `caddie csv:scatter [file] [output.png] [-- flags]`

Create scatter plot visualizations using matplotlib.

**Arguments:**
- `file`: (optional) Path to CSV/TSV file
- `output.png`: (optional) Output file path for saving plot
- Additional plotting flags

**Examples:**
```bash
# Scatter plot with defaults
caddie csv:scatter

# Save to specific file
caddie csv:scatter putt_data.csv output.png

# Custom plot with overlays
caddie csv:scatter --rings --ring_radii "3,6,9" --hole --title "Putting Performance"
```

**What it does:**
- Creates scatter plot using matplotlib
- Applies current axis settings (x, y columns)
- Optionally adds hole outline and bullseye rings
- Can save to file or display interactively
- Uses configured plot settings from session defaults

**Output:**
```
Rendering scatter plot for putt_data.csv
✓ Scatter plot rendered successfully
```

**Requirements:**
- X and Y axis columns must be defined (`caddie csv:set:x` and `caddie csv:set:y`)
- Data columns must exist in the file
- Plotting dependencies must be installed

### Session Management

#### `caddie csv:list`

Display all current default values in the shell session.

**Examples:**
```bash
# Show all defaults
caddie csv:list

# Check configuration after setup
caddie csv:set:file data.csv
caddie csv:set:x distance
caddie csv:list
```

**What it does:**
- Lists all supported configuration keys
- Shows current values or "(unset)" status
- Displays settings in organized format
- Helps debug configuration issues

**Output:**
```
CSV session defaults
  file             target/putt_data.csv
  x                target_distance
  y                success_rate
  sep              ,
  plot             (unset)
  title            (unset)
  limit            (unset)
  save             (unset)
  success_filter   (unset)
  scatter_filter   (unset)
  sql              (unset)
  hole             (unset)
  rings            (unset)
  hole_x           (unset)
  hole_y           (unset)
  hole_r           (unset)
  ring_radii       (unset)
```

### Configuration Commands

Configuration commands follow the pattern `caddie csv:set:<key>`, `caddie csv:get:<key>`, and `caddie csv:unset:<key>`.

#### File Configuration

##### `caddie csv:set:file <path>`

Set the default CSV/TSV file for the current session.

**Arguments:**
- `path`: Path to CSV/TSV file

**Examples:**
```bash
# Set default file
caddie csv:set:file "target/putting_analysis.csv"

# Set with relative path
caddie csv:set:file "./data/results.tsv"
```

**Output:**
```
✓ Set file to target/putting_analysis.csv
```

##### `caddie csv:get:file`

Show the current default file path.

**Examples:**
```bash
caddie csv:get:file
```

**Output:**
```
file = target/putting_analysis.csv
```

##### `caddie csv:unset:file`

Clear the default file setting.

**Examples:**
```bash
caddie csv:unset:file
```

**Output:**
```
✓ Cleared file
```

#### Plot Configuration

##### `caddie csv:set:x <column>`

Set the X-axis column for plotting.

**Arguments:**
- `column`: Column name for X-axis data

**Examples:**
```bash
# Set distance as X-axis
caddie csv:set:x distance

# Set handicap as X-axis
caddie csv:set:x handicap_level
```

**Output:**
```
✓ Set x to distance
```

##### `caddie csv:set:y <column>`

Set the Y-axis column for plotting.

**Arguments:**
- `column`: Column name for Y-axis data

**Examples:**
```bash
# Set success rate as Y-axis
caddie csv:set:y success_rate

# Set accuracy as Y-axis
caddie csv:set:y accuracy_score
```

**Output:**
```
✓ Set y to success_rate
```

##### `caddie csv:set:plot <type>`

Set the default plot type.

**Arguments:**
- `type`: Plot type (`scatter`, `line`, or `bar`)

**Examples:**
```bash
# Set scatter as default
caddie csv:set:plot scatter

# Set line plot
caddie csv:set:plot line

# Set bar chart
caddie csv:set:plot bar
```

**Output:**
```
✓ Set plot to scatter
```

#### Advanced Configuration

##### `caddie csv:set:sql <query>`

Set the default SQL query for data analysis.

**Arguments:**
- `query`: SQL query string

**Examples:**
```bash
# Set default query
caddie csv:set:sql "SELECT distance, COUNT(*) as attempts, AVG(success) as rate FROM df GROUP BY distance"

# Complex query
caddie csv:set:sql "SELECT * FROM df WHERE handicap <= 15 AND distance > 10 ORDER BY distance"
```

**Output:**
```
✓ Set sql to SELECT distance, COUNT(*) as attempts, AVG(success) as rate FROM df GROUP BY distance
```

##### `caddie csv:set:sep <separator>`

Set the field separator for CSV/TSV files.

**Arguments:**
- `separator`: Field separator (comma, tab, semicolon, etc.)

**Examples:**
```bash
# Default comma separator
caddie csv:set:sep ","

# Tab-separated values
caddie csv:set:sep "\t"

# Semicolon separator
caddie csv:set:sep ";"
```

**Output:**
```
✓ Set csv to ,
```

##### `caddie csv:set:limit <rows>`

Set the row limit for plotting operations.

**Arguments:**
- `rows`: Maximum number of rows to plot

**Examples:**
```bash
# Limit to 1000 rows
caddie csv:set:limit 1000

# Limit to 500 rows
caddie csv:set:limit 500
```

**Output:**
```
✓ Set limit to 1000
```

##### `caddie csv:set:title <text>`

Set the default plot title.

**Arguments:**
- `text`: Title text for plots

**Examples:**
```bash
# Set descriptive title
caddie csv:set:title "Putting Performance Analysis"

# Set title with variables
caddie csv:set:title "Shot Dispersion by Distance"
```

**Output:**
```
✓ Set title to Putting Performance Analysis
```

#### Filter Configuration

##### `caddie csv:set:success_filter <predicate>`

Set SQL predicate for filtering successful shots.

**Arguments:**
- `predicate`: SQL WHERE condition for success filtering

**Examples:**
```bash
# Filter for successful shots only
caddie csv:set:success_filter "success = true"

# Filter for short putts
caddie csv:set:success_filter "distance <= 5 AND success = true"

# Complex filter
caddie csv:set:success_filter "made_putt = 1 OR distance_to_hole <= 1.0"
```

**Output:**
```
✓ Set success filter to success = true
```

##### `caddie csv:set:scatter_filter <predicate>`

Set SQL predicate for filtering scatter plot data.

**Arguments:**
- `predicate`: SQL WHERE condition for scatter plot filtering

**Examples:**
```bash
# Filter recent data only
caddie csv:set:scatter_filter "date >= '2024-01-01'"

# Filter specific handicap range
caddie csv:set:scatter_filter "handicap BETWEEN 10 AND 20"

# Filter outliers
caddie csv:set:scatter_filter "distance_to_hole < 50"
```

**Output:**
```
✓ Set scatter filter to handicap BETWEEN 10 AND 20
```

#### Golf-Specific Configuration

##### `caddie csv:set:hole <on|off>`

Enable or disable hole outline overlay on plots.

**Arguments:**
- `on|off`: Enable or disable hole overlay

**Examples:**
```bash
# Enable hole outline
caddie csv:set:hole on

# Disable hole outline
caddie csv:set:hole off
```

**Output:**
```
✓ Set hole to on
```

##### `caddie csv:set:rings <on|off>`

Enable or disable bullseye ring overlay on plots.

**Arguments:**
- `on|off`: Enable or disable ring overlay

**Examples:**
```bash
# Enable rings
caddie csv:set:rings on

# Disable rings
caddie csv:set:rings off
```

**Output:**
```
✓ Set rings to on
```

##### `caddie csv:set:hole_x <value>`

Set the X position for hole center in plots.

**Arguments:**
- `value`: X coordinate for hole center

**Examples:**
```bash
# Set hole at origin
caddie csv:set:hole_x 0

# Set hole offset
caddie csv:set:hole_x 15.5
```

**Output:**
```
✓ Set hole x to 0
```

##### `caddie csv:set:hole_y <value>`

Set the Y position for hole center in plots.

**Arguments:**
- `value`: Y coordinate for hole center

**Examples:**
```bash
# Set hole at origin
caddie csv:set:hole_y 0

# Set hole offset
caddie csv:set:hole_y 22.3
```

**Output:**
```
✓ Set hole y to 0
```

##### `caddie csv:set:hole_r <radius>`

Set the hole radius for overlay plots.

**Arguments:**
- `radius`: Hole radius in same units as data

**Examples:**
```bash
# Standard golf hole (4.25 inch diameter)
caddie csv:set:hole_r 2.125

# Custom radius
caddie csv:set:hole_r 1.5
```

**Output:**
```
✓ Set hole r to 2.125
```

##### `caddie csv:set:ring_radii <r1,r2,...>`

Set radii for bullseye rings overlay.

**Arguments:**
- `r1,r2,...`: Comma-separated list of ring radii

**Examples:**
```bash
# Training targets at 3, 6, 9 feet
caddie csv:set:ring_radii "3,6,9"

# Precision rings at 1.5, 3 feet
caddie csv:set:ring_radii "1.5,3"

# Multiple targets
caddie csv:set:ring_radii "2,4,6,8,10"
```

**Output:**
```
✓ Set ring radii to 3,6,9
```

## Environment Variables

All CSV module settings map to environment variables with the `CADDIE_CSV_` prefix:

| Key | Environment Variable | Purpose |
|-----|---------------------|---------|
| `file` | `CADDIE_CSV_FILE` | Default CSV/TSV file path |
| `x` | `CADDIE_CSV_X` | X-axis column for plots |
| `y` | `CADDIE_CSV_Y` | Y-axis column for plots |
| `sep` | `CADDIE_CSV_SEP` | Field separator |
| `plot` | `CADDIE_CSV_PLOT` | Default plot type |
| `title` | `CADDIE_CSV_TITLE` | Default plot title |
| `limit` | `CADDIE_CSV_LIMIT` | Row limit for plots |
| `save` | `CADDIE_CSV_SAVE` | Default output file path |
| `sql` | `CADDIE_CSV_SQL` | Default SQL query |
| `success_filter` | `CADDIE_CSV_SUCCESS_FILTER` | sql predicate for success filtering |
| `scatter_filter` | `CADDIE_CSV_SCATTER_FILTER` | SQL predicate for scatter plot filtering |
| `hole` | `CADDIE_CSV_HOLE` | Enable hole overlay |
| `rings` | `CADDIE_CSV_RINGS` | Enable ring overlay |
| `hole_x` | `CADDIE_CSV_HOLE_X` | Hole center X position |
| `hole_y` | `CADDIE_CSV_HOLE_Y` | Hole center Y position |
| `hole_r` | `CADDIE_CSV_HOLE_R` | Hole radius |
| `ring_radii` | `CADDIE_CSV_RING_RADII` | Ring radii (comma-separated) |

### Setting Environment Variables Directly

```bash
# Export configuration for current shell
export CADDIE_CSV_FILE="target/data.csv"
export CADDIE_CSV_X="distance"
export CADDIE_CSV_Y="accuracy"

# Check configuration
caddie csv:list
```

**Note:** Environment variables persist only for the current shell session and are not saved globally.

## Plot Types

### Scatter Plots

Scatter plots show the relationship between two continuous variables.

```bash
# Create scatter plot
caddie csv:set:plot scatter
caddie csv:set:x distance
caddie csv:set:y success_rate
caddie csv:scatter
```

### Line Plots

Line plots connect data points to show trends over a continuous axis.

```bash
# Create line plot
caddie csv:set:plot line
caddie csv:set:x distance
caddie csv:set:y avg_attempts
caddie csv:scatter --title "Putting Efficiency by Distance"
```

### Bar Charts

Bar charts display categorical data with rectangular bars.

```bash
# Create bar chart
caddie csv:set:plot bar
caddie csv:set:x handicap_range
caddie csv:set:y avg_score
caddie csv:scatter --title "Average Score by Handicap"
```

## Golf-Specific Features

### Hole Outline Overlay

Add a circle representing the golf hole to your plots:

```bash
# Enable hole overlay
caddie csv:set:hole on
caddie csv:set:hole_x 0
caddie csv:set:hole_y 0
caddie csv:set:hole_r 2.125  # Standard golf hole radius
caddie csv:scatter --title "Shot Dispersion Around Hole"
```

### Bullseye Rings Overlay

Add concentric rings for target practice visualization:

```bash
# Enable rings with training targets
caddie csv:set:rings on
caddie csv:set:ring_radii "3,6,9"  # 3, 6, and 9 foot rings
caddie csv:scatter --title "Putting Accuracy Training"
```

### Combined Overlays

Use both hole and ring overlays together:

```bash
# Enable both overlays
caddie csv:set:hole on
caddie csv:set:rings on
caddie csv:set:hole_r 2.125
caddie csv:set:ring_radii "1,3,5"
caddie csv:scatter --title "Complete Putting Analysis"
```

## File Formats

### Supported Formats

| Format | Extension | Separator | Notes |
|--------|-----------|-----------|-------|
| CSV | `.csv` | Comma (`,`) | Standard CSV format |
| TSV | `.tsv` | Tab (`\t`) | Tab-separated values |
| Custom | Any | User-defined | Use `caddie csv:set:sep` |

### Required Format

- Must have header row with column names
- Consistent separator throughout file
- Numeric data should be numeric (no quotes for numbers)
- Missing values can be empty fields or "NULL"

### Example CSV Format

```csv
distance,handicap,success,x_position,y_position,distance_to_hole
10.5,15,true,0.2,-1.5,1.8
15.0,20,false,2.3,1.1,2.6
7.5,5,true,-0.8,0.3,0.9
```

## SQL Support

The CSV module uses DuckDB for SQL queries, providing extensive SQL support including:

### Basic Operations

```sql
-- Select specific columns
SELECT distance, success FROM df

-- Filter data
SELECT * FROM df WHERE handicap < 15

-- Aggregate statistics
SELECT distance, COUNT(*), AVG(success_rate) FROM df GROUP BY distance

-- Order results
SELECT * FROM df ORDER BY distance DESC

-- Limit results
SELECT * FROM df LIMIT 100
```

### Advanced Operations

```sql
-- Conditional aggregation
SELECT 
    handicap_range,
    COUNT(*) as total_shots,
    SUM(CASE WHEN success = true THEN 1 ELSE 0 END) as successful_shots,
    AVG(distance_to_hole) as avg_distance_to_hole
FROM df 
GROUP BY handicap_range

-- Window functions
SELECT 
    distance,
    success_rate,
    AVG(success_rate) OVER (ORDER BY distance ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) as moving_avg
FROM df

-- Complex filtering
SELECT * FROM df 
WHERE (handicap BETWEEN 10 AND 20) 
  AND (distance > 5 AND distance < 20)
  AND (distance_to_hole < 3)
```

### DuckDB-Specific Features

```sql
-- String operations
SELECT UPPER(handicap_category), LENGTH(player_name) FROM df

-- Date/time operations
SELECT DATE_TRUNC('day', shot_timestamp), COUNT(*) FROM df GROUP BY 1

-- Mathematical functions
SELECT SQRT(x_position*x_position + y_position*y_position) as euclidean_distance FROM df

-- Statistical functions
SELECT STDDEV(distance_to_hole), VARIANCE(success_rate) FROM df
```

## Data Analysis Examples

### Golf Performance Analysis

```bash
#!/bin/bash
# putting-analysis.sh

# Set up the analysis environment
caddie csv:set:file "putting_results.csv"
caddie csv:set:x "distance"
caddie csv:set:y "success_rate"

# Analyze overall performance
caddie csv:query "SELECT COUNT(*) as total_shots, AVG(success) as overall_success_rate FROM df"

# Performance by distance
caddie csv:query "
SELECT 
    ROUND(distance, 1) as distance_bin,
    COUNT(*) as attempts,
    AVG(success*100) as success_rate_pct,
    STDDEV(distance_to_hole) as avg_precision
FROM df 
GROUP BY ROUND(distance, 1) 
ORDER BY distance_bin
"

# Performance by handicap
caddie csv:query "
SELECT 
    CASE 
        WHEN handicap <= 5 THEN 'Scratch'
        WHEN handicap <= 15 THEN 'Mid'
        WHEN handicap <= 25 THEN 'High'
        ELSE 'Beginner'
    END as skill_level,
    COUNT(*) as total_shots,
    AVG(success*100) as success_rate
FROM df 
GROUP BY skill_level
ORDER BY handicap
"

# Create visualization
caddie csv:set:hole on
caddie csv:set:rings on
caddie csv:set:ring_radii "3,6,9"
caddie csv:scatter --title "Putting Performance Analysis"
```

### Shot Dispersion Analysis

```bash
#!/bin/bash
# dispersion-analysis.sh

caddie csv:set:file "shot_positions.csv"
caddie csv:set:x "x_position"
caddie csv:set:y "y_position"

# Basic dispersion stats
caddie csv:query "
SELECT 
    COUNT(*) as total_shots,
    AVG(x_position) as avg_x,
    AVG(y_position) as avg_y,
    STDDEV(x_position) as x_precision,
    STDDEV(y_position) as y_precision
FROM df
"

# Distance from hole analysis
caddie csv:query "
SELECT 
    CASE 
        WHEN distance_to_hole <= 1 THEN 'Tap-in'
        WHEN distance_to_hole <= 3 THEN 'Very Close'
        WHEN distance_to_hole <= 6 THEN 'Close'
        WHEN distance_to_hole <= 15 THEN 'Medium'
        ELSE 'Far'
    END as proximity_category,
    COUNT(*) as shot_count,
    AVG(distance_to_hole) as avg_distance
FROM df
GROUP BY proximity_category
ORDER BY avg_distance
"

# Create scatter plot with golf context
caddie csv:set:hole on
caddie csv:set:rings on
caddie csv:set:hole_r 2.125
caddie csv:set:ring_radii "3,6,9"
caddie csv:scatter --title "Shot Dispersion Around Hole"
```

## Error Handling

### Common Errors

#### "Error: CSV file required"
**Cause**: No default file set and none provided
**Solution**: Set a default file or provide file path explicitly

```bash
caddie csv:set:file path/to/data.csv
# OR
caddie csv:query path/to/data.csv
```

#### "Error: Plotting requires both --x and --y"
**Cause**: X or Y axis column not defined
**Solution**: Set both axes before plotting

```bash
caddie csv:set:x distance
caddie csv:set:y success_rate
caddie csv:scatter
```

#### "Error: Missing columns in result set"
**Cause**: Referenced column doesn't exist in data
**Solution**: Check your SQL query and file structure

```bash
# Check available columns first
caddie csv:query "PRAGMA table_info(df)"
# Or
caddie csv:query "SELECT * FROM df LIMIT 1"
```

#### "Error: csvql.py not found"
**Cause**: CSV module not properly installed
**Solution**: Reinstall caddie modules

```bash
cd /path/to/caddie.sh
make install-dot
caddie reload
```

#### "Error: Pipeline failed"
**Cause**: Python virtual environment issues
**Solution**: Reinitialize CSV environment

```bash
caddie csv:init
```

#### "Error: Invalid ring radius"
**Cause**: Non-numeric value in ring_radii
**Solution**: Use comma-separated numeric values

```bash
caddie csv:set:ring_radii "3,6,9"  # Correct
# NOT (comma space): caddie csv:set:ring_radii "3, 6, 9 feet"
```

### Error Output Format

All errors follow a consistent format:
```
Error: <description>
Usage: caddie csv:<command> <arguments>
```

## Troubleshooting

### Virtual Environment Issues

If CSV operations fail due to Python environment problems:

```bash
# Check if environment exists
ls -la ~/.caddie_modules/bin/.caddie_venv

# Reinitialize environment
caddie csv:init

# Check Python installation
python3 --version
```

### Dependency Installation Failures

If dependency installation fails:

```bash
# Check network connectivity
ping pypi.org

# Check pip availability
python3 -m pip --version

# Clean and retry
rm -rf ~/.caddie_modules/bin/.caddie_venv
caddie csv:init
```

### Large File Performance

For large csv files (>100MB):

```bash
# Set reasonable limits
caddie csv:set:limit 10000

# Use specific filters to reduce data
caddie csv:set:success_filter "distance <= 20"

# Consider preprocessing with external tools
head -1000 large_file.csv > sample.csv
caddie csv:set:file sample.csv
```

### Memory Issues

If running out of memory with large datasets:

```bash
# Reduce plot data size
caddie csv:set:limit 5000

# Use SQL aggregation to reduce rows
caddie csv:query "SELECT distance, AVG(success_rate) FROM df GROUP BY distance"
```

### Plotting Issues

If plots don't display or save correctly:

```bash
# Check matplotlib backend
python3 -c "import matplotlib; print(matplotlib.get_backend())"

# For saving plots in headless environments
export MPLBACKEND=Agg
caddie csv:scatter --save output.png
```

## Best Practices

### Session Management

1. **Default Setup**: Set commonly used values once at the beginning of a session
2. **Consistent Naming**: Use clear, descriptive column names in your CSV files
3. **Clean Configuration**: Clear unused defaults with `caddie csv:unset:<key>`
4. **Document Settings**: Keep notes on your typical configuration workflows

### Data Quality

1. **Header Validation**: Always ensure CSV files have proper headers
2. **Numeric Data**: Ensure numeric columns contain numbers, not quoted strings
3. **Missing Values**: Decide on handling strategy for missing data (empty, "NULL", etc.)
4. **Consistent Format**: Use consistent separators and formatting throughout

### SQL Optimization

1. **Filter Early**: Use WHERE clauses to reduce data before processing
2. **Aggregate Appropriately**: Use GROUP BY for summarizing trends
3. **Limit Results**: Use LIMIT for large datasets
4. **Index-Friendly**: Structure queries to work efficiently with DuckDB

### Visualization Best Practices

1. **Meaningful Axes**: Choose axes that reveal insights about your data
2. **Appropriate Scales**: Use log scales for wide-ranging data
3. **Context Overlays**: Use hole and ring overlays for golf-specific analysis
4. **Clear Titles**: Always provide meaningful plot titles

### Performance Optimization

1. **Session Defaults**: Set defaults rather than specifying everything each time
2. **Data Filtering**: Use filters to reduce data volume when possible
3. **Plot Limits**: Use reasonable limits for plot operations
4. **Batch Operations**: Group multiple queries together when possible

## Examples

### Complete Analysis Workflow

```bash
#!/bin/bash
# complete-golf-analysis.sh

echo "=== Golf Performance Analysis ==="

# Initialize environment
caddie csv:init

# Set up default configuration
caddie csv:set:file "golf_data.csv"
caddie csv:set:x "distance"
caddie csv:set:y "success_rate"

# Basic data exploration
echo "--- Data Overview ---"
caddie csv:query "SELECT COUNT(*) as total_shots FROM df"

echo "--- Performance by Distance ---"
caddie csv:query "
SELECT 
    CASE 
        WHEN distance <= 3 THEN 'Short'
        WHEN distance <= 10 THEN 'Medium' 
        WHEN distance <= 20 THEN 'Long'
        ELSE 'Very Long'
    END as distance_category,
    COUNT(*) as shots,
    AVG(success*100) as success_rate_pct
FROM df 
GROUP BY distance_category
ORDER BY MIN(distance)
"

echo "--- Performance by Skill Level ---"
caddie csv:query "
SELECT 
    CASE 
        WHEN handicap <= 5 THEN 'Expert'
        WHEN handicap <= 15 THEN 'Intermediate'
        WHEN handicap <= 25 THEN 'Beginner'
        ELSE 'Novice'
    END as skill_category,
    COUNT(*) as shots,
    AVG(success*100) as success_rate_pct,
    AVG(distance_to_hole) as avg_precision
FROM df 
GROUP BY skill_category
ORDER BY AVG(handicap)
"

# Create visualizations
echo "--- Creating Visualizations ---"

# Overall performance scatter
caddie csv:set:plot scatter
caddie csv:set:x distance
caddie csv:set:y success_rate
caddie csv:scatter --title "Overall Putting Performance" --save overall_performance.png

# Dispersion analysis
caddie csv:set:x x_position
caddie csv:set:y y_position
caddie csv:set:hole on
caddie csv:set:rings on
caddie csv:set:hole_r 2.125
caddie csv:set:ring_radii "3,6,9"
caddie csv:scatter --title "Shot Dispersion Analysis" --save dispersion.png

# Clean up configuration
echo "--- Cleaning Up ---"
caddie csv:unset:file
caddie csv:unset:x
caddie csv:unset:y

echo "✓ Analysis complete - check .png files for visualizations"
```

### Development Testing Workflow

```bash
#!/bin/bash
# quick-csv-test.sh

# Test CSV functionality
caddie csv:init

# Create test data
cat > test_data.csv << EOF
distance,handicap,success,x_position,y_position,distance_to_hole
5.0,10,true,0.5,-0.8,0.9
10.0,15,false,2.1,1.5,2.6
15.0,20,false,-1.2,0.3,1.2
3.0,5,true,-0.3,-0.1,0.3
EOF

# Test basic query
caddie csv:query test_data.csv "SELECT COUNT(*) FROM df"

# Test plotting
caddie csv:set:file test_data.csv
caddie csv:set:x distance
caddie csv:set:y distance_to_hole
caddie csv:scatter --save test_plot.png

# Test filters
caddie csv:query "SELECT * FROM df WHERE handicap <= 15"

# Clean up
rm test_data.csv
rm test_plot.png
echo "✓ CSV module test completed successfully"
```

### Integration with Other Modules

```bash
#!/bin/bash
# golf-workflow-integration.sh

# Start with Rust simulation output
echo "Running Monte Carlo simulation..."
caddie rust:run:example multi_distance_demo

# Analyze results with CSV tools
caddie csv:set:file target/putt_data.csv
caddie csv:set:x distance
caddie csv:set:y success_rate

# Create performance dashboard
caddie csv:set:hole on
caddie csv:set:rings on
caddie csv:set:ring_radii "3,6,9"
caddie csv:scatter --title "Simulation Results" --save simulation_results.png

# Generate git commit with results
caddie git:gadd target/simulation_results.png
caddie git:gcommit "Add simulation results and analysis"

echo "✓ Complete golf analysis workflow completed"
```

## Related Documentation

- **[Core Module](core.md)** - Basic Caddie.sh functions and debug system
- **[Rust Module](rust.md)** - Monte Carlo simulation tools (generate data for CSV analysis)
- **[Git Module](git.md)** - Version control for analysis results
- **[Python Module](python.md)** - Python environment that CSV module builds upon

## External Resources

- **[DuckDB Documentation](https://duckdb.org/docs/sql/introduction)** - SQL reference for the csv module's query engine
- **[matplotlib Documentation](https://matplotlib.org/stable/index.html)** - Plotting library used by CSV module
- **[pandas Documentation](https://pandas.pydata.org/docs/)** - Data manipulation library used internally

---

*The CSV module provides everything you need for professional golf data analysis. From simple queries to complex visualizations, it makes data-driven insights accessible and consistent.*
