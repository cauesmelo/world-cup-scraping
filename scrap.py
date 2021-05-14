__author__ = "Cauê Melo"
__copyright__ = "Copyright 2007, The Cogent Project"
__credits__ = ["Cauê Melo", "Morganna Carmem Diniz"]
__license__ = "MIT"
__version__ = "0.0.1"
__maintainer__ = "Cauê Melo"
__email__ = "caue.melo@uniriotec.br"
__status__ = "Development"

# Desempenho do Brasil nas copas do mundo

from bs4 import BeautifulSoup
import requests
import re

page = BeautifulSoup(requests.get("https://www.fifa.com/worldcup/").content, 'html.parser')

selector = str(page.find(id = "edition-selector"))
cup_links = re.findall(r'value=\"(.*)\"', selector)
cup_names = re.findall(r'\">\s*(.*)\n\s*</option>', selector)
cup_editions = []

for i in range(len(cup_names) - 1):
  cup_editions.append(tuple((cup_names.pop(), cup_links.pop())))

for cup in cup_editions:
  print(cup)



