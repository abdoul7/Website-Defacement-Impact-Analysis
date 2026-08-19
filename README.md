
# Website Defacement Data Preparation

An R-based data-cleaning pipeline for historical website-defacement incident data.

An R-based data-cleaning pipeline for historical website-defacement incident data. This project was completed as part of the **Programming for Data Analysis (PFDA)** module at Asia Pacific University of Technology & Innovation (APU).

The broader group assignment investigated patterns and operational impacts associated with website defacement incidents. This repository currently contains the cleaning workflow for `HackingData_Part3.txt`, which I prepared jointly with another group member.

## What the pipeline does

The script prepares the raw dataset for further statistical analysis by:

- Importing tab-delimited incident data and recognising common missing-value markers
- Converting dates, downtime, ransom amounts, and financial losses into appropriate data types
- Converting text fields to UTF-8 and removing unnecessary whitespace
- Standardising country names and categorical values
- Removing exact duplicate records
- Replacing missing categorical and numerical values using documented rules
- Correcting invalid negative downtime, ransom, and loss values
- Applying IQR-based winsorisation to extreme loss and ransom values
- Validating the cleaned dataset before export

## Technologies

- R
- `dplyr`
- `readr`
- `stringr`
- `lubridate`

## Repository structure

```text
website-defacement-impact-analysis/
|-- data/
|   |-- HackingData_Part3.txt
|   `-- HackingData_Part3_Cleaned.csv   # generated output
|-- scripts/
|   `-- 01_data_cleaning.R
`-- README.md
```

## Running the project

1. Install R and the required packages:

```r
install.packages(c("dplyr", "stringr", "readr", "lubridate"))
```

2. Place the raw dataset in the `data` directory.
3. Ensure the script reads the dataset using a relative path such as:

```r
df <- read_delim(
  "data/HackingData_Part3.txt",
  delim = "\t",
  na = c("", "NA", "NULL", "Unknown", "UNKNOWN"),
  trim_ws = TRUE
)
```

4. Run `scripts/01_data_cleaning.R` from the repository root.

The cleaned dataset will be written to the `data` directory for subsequent analysis.

## My contribution

- Contributed to the preparation and cleaning of the Part 3 dataset
- Helped define and implement rules for missing values, invalid values, duplicates, encoding, and categorical standardisation
- Applied IQR-based winsorisation to reduce the influence of extreme financial-loss and ransom values
- Completed an individual diagnostic analysis for the wider assignment examining downtime, financial loss, web-server technology, and ransom demands

## Current scope

This repository currently preserves the Part 3 data-preparation workflow. The statistical-analysis code from the wider assignment is not currently included and may be added later if it is recovered or reconstructed.

## Academic context

This was a group university assignment. The repository documents my contribution and does not claim sole authorship of the complete group report or dataset.
defacement incidents and their financial impact.
