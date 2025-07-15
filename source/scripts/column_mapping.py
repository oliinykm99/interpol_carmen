import pandas as pd
from pathlib import Path
import csv

SEEDS_DIR = "seeds"
OUTPUT_CSV = "seeds/column_mappings.csv"
COMMON_DICT = [
    "date_witness",
    "date_agent",
    "witness",
    "agent",
    "latitude",
    "longitude",
    "city",
    "country",
    "region_hq",
    "has_weapon",
    "has_hat",
    "has_jacket",
    "behavior"
]

def generate_mappings():
    with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['region', 'source_column', 'target_column', 'dtype'])
        
        for csv_file in Path(SEEDS_DIR).glob("region_*.csv"):
            region = csv_file.stem.replace("region_", "")
            df = pd.read_csv(csv_file, nrows=1)
            
            for src_col, target_col in zip(df.columns, COMMON_DICT):
                # Auto-detect data type
                dtype = (
                    'date' if 'date_' in target_col else
                    'float' if target_col in ['latitude', 'longitude'] else
                    'boolean' if target_col.startswith('has_') else 'text'
                )
                writer.writerow([region, src_col, target_col, dtype])

if __name__ == "__main__":
    generate_mappings()

if __name__ == "__main__":
    generate_mappings()