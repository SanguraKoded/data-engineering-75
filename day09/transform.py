import pandas as pd
def clean_weather_data(df):
    if df.empty:
        raise ValueError("DataFrame is empty")
    # Drop rows with any missing values
    df = df.dropna()
    return df