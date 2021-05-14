__author__ = "Cauê Melo"
__credits__ = ["Cauê Melo", "Morganna Carmem Diniz"]
__license__ = "MIT"
__version__ = "0.0.1"
__maintainer__ = "Cauê Melo"
__email__ = "caue.melo@uniriotec.br"
__status__ = "Development"

# Desempenho do Brasil nas copas do mundo

# libs
from bs4 import BeautifulSoup
import requests
import re
from openpyxl import Workbook
from enum import IntEnum

# enum for table columns index
class CUP(IntEnum):
  CUP_ID = 1
  HOST = 2
  YEAR = 3
  FINAL_PHASE = 4
  WINNER = 5

class MATCH(IntEnum):
  GAME_ID = 1
  CUP_ID = 2
  VERSUS = 3
  PHASE = 4
  REFEREE = 5
  REFEREE_NAC = 6
  STADIUM = 7
  VENUE = 8
  TIME = 9
  WIN = 10

class GOAL(IntEnum):
  MATCH_ID = 1
  CUP_ID = 2
  PLAYER = 3
  TIME = 4

class RANK(IntEnum):
  DATE = 1
  RANK = 2
  TEAM = 3
  TOTAL_POINTS = 4
  PREVIOUS_POINTS = 5
  RANK_DIFF = 6


# table & sheet creation
workbook = Workbook()
worksheet = workbook.active
worksheet.title = "cup_info"
workbook.create_sheet("match_info")
workbook.create_sheet("goal_info")
workbook.create_sheet("rank_info")
row = 1
workbook.active = 1

worksheet.cell(row, column = CUP.CUP_ID).value = "cup_id"
worksheet.cell(row, column = CUP.HOST).value = "host"
worksheet.cell(row, column = CUP.YEAR).value = "year"
worksheet.cell(row, column = CUP.FINAL_PHASE).value = "final_phase"
worksheet.cell(row, column = CUP.WINNER).value = "winner"

worksheet = workbook["match_info"]
worksheet.cell(row, column = MATCH.GAME_ID).value = "game_id"
worksheet.cell(row, column = MATCH.CUP_ID).value = "cup_id"
worksheet.cell(row, column = MATCH.VERSUS).value = "versus"
worksheet.cell(row, column = MATCH.PHASE).value = "phase"
worksheet.cell(row, column = MATCH.REFEREE).value = "referee"
worksheet.cell(row, column = MATCH.REFEREE_NAC).value = "referee_nac"
worksheet.cell(row, column = MATCH.STADIUM).value = "stadium"
worksheet.cell(row, column = MATCH.VENUE).value = "venue"
worksheet.cell(row, column = MATCH.TIME).value = "time"
worksheet.cell(row, column = MATCH.WIN).value = "win"

worksheet = workbook["goal_info"]
worksheet.cell(row, column = GOAL.MATCH_ID).value = "match_id"
worksheet.cell(row, column = GOAL.CUP_ID).value = "cup_id"
worksheet.cell(row, column = GOAL.PLAYER).value = "player"
worksheet.cell(row, column = GOAL.TIME).value = "time"

worksheet = workbook["rank_info"]
worksheet.cell(row, column = RANK.DATE).value = "date"
worksheet.cell(row, column = RANK.RANK).value = "rank"
worksheet.cell(row, column = RANK.TEAM).value = "team"
worksheet.cell(row, column = RANK.TOTAL_POINTS).value = "total_points"
worksheet.cell(row, column = RANK.PREVIOUS_POINTS).value = "previous_points"
worksheet.cell(row, column = RANK.RANK_DIFF).value = "rank_diff"

# request && parse
page = BeautifulSoup(requests.get("https://www.fifa.com/worldcup/").content, 'html.parser')

# scrap inside editions selector
selector = str(page.find(id = "edition-selector"))
cup_links = re.findall(r'value=\"(.*)\"', selector)
cup_names = re.findall(r'\">\s*(.*)\n\s*</option>', selector)
cup_editions = []

# put all name and links for cup data inside an list of tuples
for i in range(len(cup_names) - 1):
  cup_editions.append(tuple((cup_names.pop(), cup_links.pop())))


def request_edition(link):
  matches = BeautifulSoup(requests.get("https://www.fifa.com" + link + "matches").content, 'html.parser')
  temp = str(matches.find_all(class_="tab-main-container"))
  cup_phases = re.findall(r'<span>(.*)<\/span>', temp)
  cup_phases_links = re.findall(r'<a href="(.*)">', temp)
  print(cup_phases_links)
  print(cup_phases)

request_edition(cup_editions[0][1])
# workbook.save("relatorio.xlsx")
