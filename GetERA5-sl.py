#!/usr/bin/env python
import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': [
            '10m_u_component_of_wind', '10m_v_component_of_wind', '2m_dewpoint_temperature',
            '2m_temperature', 'mean_sea_level_pressure', 'sea_ice_cover',
            'skin_temperature', 'snow_depth', 'soil_temperature_level_1',
            'soil_temperature_level_2', 'soil_temperature_level_3', 'soil_temperature_level_4',
            'surface_pressure', 'volumetric_soil_water_layer_1', 'volumetric_soil_water_layer_2',
            'volumetric_soil_water_layer_3', 'volumetric_soil_water_layer_4',
        ],
        'year': 'iyear',
        'month': 'imon',
        'day': 'iday',
        'time': 'itime:00',
        'format': 'grib',
        'area': [
            Nort, West, Sout,
            East,
        ],
    },
    'Output_Name-iyearimonidayitime')
