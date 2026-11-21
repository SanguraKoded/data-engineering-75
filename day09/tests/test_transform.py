import pandas as pd
import pytest
from day09.transform import clean_weather_data

def test_data_input():
    # Test with a valid DataFrame
    df = pd.DataFrame({
        'temperature': [20, 30],
        'humidity': [30, 50]
    })

    results = clean_weather_data(df)

    assert len(results) == 2
    assert results.columns.tolist() == ['temperature', 'humidity']

def test_empty_dataFrame():
    df = pd.DataFrame()
    with pytest.raises(ValueError):
        clean_weather_data(df) 

def test_null_values():
    df = pd.DataFrame({
        'temperature': [20, None, 30],
        'humidity': [30, 50, None]
    })

    results = clean_weather_data(df)

    assert len(results) == 1
    assert results.isnull().sum().sum() == 0  # Ensure no null values remain

