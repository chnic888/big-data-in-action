import os

import requests
from bs4 import BeautifulSoup


def download_file(base_dir: str, file_list: list[str]):
    url = "https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_station/"
    response = requests.get(url)
    file_set = set(file_list)

    if response.status_code != 200:
        return

    soup = BeautifulSoup(response.content, 'html.parser')
    table = soup.find('table')
    if not table:
        return

    for row in table.find_all('tr'):
        cells = row.find_all(['th', 'td'])
        row_data = [cell.get_text(strip=True) for cell in cells]
        file_name: str = row_data[0]
        if file_name.__contains__('.') and not file_set.__contains__(file_name):
            response = requests.get(url + row_data[0], stream=True)
            if response.status_code == 200:
                with open(base_dir + row_data[0], 'wb') as f:
                    f.write(response.content)
                print("%s download successfully" % row_data[0])


def list_download_files(base_dir: str) -> list[str]:
    if not os.path.exists(base_dir):
        os.makedirs(base_dir)
    files = os.listdir(base_dir)
    return [file for file in files if os.path.isfile(os.path.join(base_dir, file))]


if __name__ == '__main__':
    download_folder = "%s/by_station/" % os.getcwd()
    download_files = list_download_files(download_folder)
    download_file(download_folder, download_files)
    print("All files have been downloaded")
