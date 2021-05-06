__author__ = "Cauê Melo"
__copyright__ = "Copyright 2007, The Cogent Project"
__credits__ = ["Cauê Melo", "Morganna Carmem Diniz"]
__license__ = "MIT"
__version__ = "0.0.1"
__maintainer__ = "Cauê Melo"
__email__ = "caue.melo@uniriotec.br"
__status__ = "Development"

from bs4 import BeautifulSoup
import requests

page = BeautifulSoup(requests.get("https://www.fifa.com/worldcup/").content, 'html.parser')

#capturar links das copas
print(page)
