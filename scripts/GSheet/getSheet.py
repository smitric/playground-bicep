from __future__ import print_function

import os.path
import gspread

from oauth2client.service_account import ServiceAccountCredentials
from google.auth.transport.requests import requests
from google.oauth2.credentials import Credentials
#from google_auth_oauthlib.flow import InstalledAppFlow

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

# The ID and range of a sample spreadsheet.
SAMPLE_SPREADSHEET_ID = '1_LwIFK8T2HU83K1IuNvEAK9IxDezlyAQTZE3rRKN81s'
SHEET_URL = 'https://docs.google.com/spreadsheets/d/1_LwIFK8T2HU83K1IuNvEAK9IxDezlyAQTZE3rRKN81s/edit#gid=0'

def setCreds():
    scope = ['https://spreadsheets.google.com/feeds']
    creds = ServiceAccountCredentials.from_json_keyfile_name("credentials.json", scope)
    client = gspread.authorize(creds)
    return client

def getWorksheets(sheet_url):
    client = setCreds()
    sheet = client.open_by_url(sheet_url)
    worksheets = sheet.worksheets()     # This will return a list of worksheets
    for i in sheet.worksheets():
        print("Following worksheets are present:")
        print(i.title)
    return worksheets

def printSheetData(sheet_url, worksheet_name):

    client = setCreds()

    # Get complete sheet data
    sheet = client.open_by_url(sheet_url)

    # Get specific worksheet data
    worksheet_by_title = sheet.worksheet(worksheet_name)
    
    print("Getting all data from worksheet: %s" % worksheet_by_title.title)
    complete_worksheet = worksheet_by_title.get_all_values()
    print(type(complete_worksheet))

    for rule in complete_worksheet:
        print(rule)

#  Below snippet that loops through the rules is commented, but feel free to uncomment it and play around with it.
#
#        # print("")
#        for field in rule:
#
#            print(field)
#
#            # print("")
    # Print length of complete_worksheet (number of rows)
    print(len(complete_worksheet))

    # Printing headers in sheet
    print(worksheet_by_title.row_values(1))


getWorksheets("https://docs.google.com/spreadsheets/d/1_LwIFK8T2HU83K1IuNvEAK9IxDezlyAQTZE3rRKN81s/edit#gid=0")
printSheetData(SHEET_URL, "AllActiveEmployeesNL")
    