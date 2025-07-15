import pandas as pd
from pathlib import Path

script_dir = Path(__file__).parent

input_dir = script_dir / "../input_data"
seeds_dir = script_dir / "../../seeds"

for file in input_dir.glob("*.xlsx"):
    xls = pd.ExcelFile(file)
    for sheet_name in xls.sheet_names:
        df = pd.read_excel(xls, sheet_name=sheet_name)
        output_path = seeds_dir / f"region_{sheet_name.lower()}.csv"
        df.to_csv(output_path, index=False)

print("All CSV files generated successfully!")