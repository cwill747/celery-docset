#!/usr/bin/env python

import sys
from bs4 import BeautifulSoup

with open(sys.argv[1], 'r+') as my_file:
    soup = BeautifulSoup(my_file.read(), 'html.parser')
    for div in soup.findAll('div', 'related'):
        div.extract()
    for div in soup.findAll('div', 'sphinxsidebar'):
        div.extract()
    for div in soup.findAll('p', 'searchtip'):
        div.extract()
    my_file.seek(0)
    my_file.write(str(soup))
    my_file.truncate()
    my_file.close()
