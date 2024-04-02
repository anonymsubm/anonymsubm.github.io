import polars as pl

df = pl.read_csv("./target_text.txt", separator="|")
df.write_json("./data.json", row_oriented=True)
