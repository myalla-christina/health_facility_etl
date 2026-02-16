\# Health Facility ETL Pipeline
Health Facility ETL Pipeline
Overview

The Health Facility ETL Pipeline is a standardized, reproducible framework to collect, clean, harmonize, and merge health facility data from multiple countries in Sub-Saharan Africa. The goal is to create a global health facility dataset that is standardized, validated, and ready for downstream analysis such as geospatial modeling, accessibility studies, and reporting.


This project handles:

Multi-country raw health facility datasets (currently Tanzania, Uganda, Zambia, Nigeria, Malawi)

Data harmonization using a master schema

Coordinate cleaning and validation

Automated ETL execution per country

Global dataset creation by merging standardized country datasets

Key Features

Standardized schema ensures all health facilities have consistent identifiers, service categories, administrative hierarchy, and geospatial fields.

Reusable R scripts for extraction, transformation, and loading (ETL).

Automated pipeline for running country-level ETL and generating a global dataset.

Logging at each step for debugging and traceability.

Flexible structure for adding new countries in the future.
