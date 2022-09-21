#!/usr/bin/env python
import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': [
            'sea_surface_temperature', 'land_sea_mask'
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
