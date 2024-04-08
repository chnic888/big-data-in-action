import datetime
import os

import requests

current_year = datetime.datetime.today().year


def download_data_by_year(current_path: str):
    url = "https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_year/%s"
    base_dir = "%s/by_year" % current_path

    if not os.path.exists(base_dir):
        os.makedirs(base_dir)

    for year in range(1750, current_year, 1):
        file_name = str(year) + ".csv.gz"
        full_url = url % file_name

        response = requests.get(full_url, stream=True)
        if response.status_code == 200:
            with open('%s/%s' % (base_dir, file_name), 'wb') as f:
                f.write(response.content)
            print("%s download successfully" % file_name)


if __name__ == '__main__':
    download_data_by_year(os.getcwd())
    print("All files have been downloaded")
