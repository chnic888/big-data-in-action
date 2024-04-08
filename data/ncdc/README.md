# NCDC Data

## Getting Started

Download data from Climate Data Online (CDO) https://www.ncei.noaa.gov/cdo-web/, which offers free access to the
NCDC's archive of global historical weather and climate data, along with station history information.

### Prerequisites

- Ubuntu 22.04(amd64)
- Python 3.10

## Install Dependency

Install python 3.10 and create a virtual env to install the dependencies.

```shell
sudo apt install python3.10

sudo apt install python3.10-venv

cd data/ncdc/

python3.10 -m venv venv

source venv/bin/activate

pip install -r requirements.txt
```

## Download Data

- Download ghcnd and readme related data.

```shell
python3 other_download.py
```

- Download the data partitioned by year

```shell
python3 by_year_download.py
```

- Download the data partitioned by station

```shell
python3 by_station_download.py
```