# NCDC Data

## Getting Started

Download data from Climate Data Online (CDO) https://www.ncei.noaa.gov/cdo-web/, which offers free access to the
NCDC's archive of global historical weather and climate data, along with station history information.

### Prerequisites

- Ubuntu 22.04(amd64)
- Python 3.10

## Install Dependency

```shell
sudo apt install python3.10

sudo apt install python3.10-venv

cd data/ncdc/

python3.10 -m venv venv

source venv/bin/activate

pip install -r requirements.txt
```

## Download Data

```shell


python3 by_year_download.py

python3 by_station_download.py
```