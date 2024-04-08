import os
import os.path

import requests

download_urls = [
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-version.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme-by_station.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme-by_year.txt',
    'https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt'
]


def download_other_files(current_path: str):
    for url in download_urls:
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            file_name = os.path.basename(url)
            with open('%s/%s' % (current_path, file_name), 'wb') as f:
                f.write(response.content)
            print("%s download successfully" % file_name)


if __name__ == '__main__':
    download_other_files(os.getcwd())
    print("All files have been downloaded")
