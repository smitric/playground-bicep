# Purpose
Outline the steps and tools required to retrieve (meta)data from Google Sheets using it's API with a Python client.

This exercise is meant to retrieve all rows from a Google Sheet that contains all employees. This data can be leveraged to determine attributes like name, email, manager, joinDate or whether or not the employee originally started as a future.

It works by authenticating as a Google Cloud service account to the Google Sheet API with a `credentials.json` file. The service account has read permissions on the Google Sheet.

# Requirements
* Python (local or container, see below)
* Google Cloud Project - Service Account key

# Sources
- [Gsheet doc](https://developers.google.com/sheets/api/quickstart/python)]
- [Access worksheet data with Python](https://mljar.com/blog/read-google-sheets-in-python-with-no-code/)
- TODO: [Manage Keyvault with Python through service principal](https://learn.microsoft.com/en-us/samples/azure-samples/key-vault-python-manage/key-vault-python-manage/)


# Usage

## Fetch service account key
1. Follow [the documentation](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating) on how to create and download a serivce account key. 
1. Save the file to the `mcloud-az-playground/scripts/GSheet/` directory and rename to `credentials.json`.

> ❗**Note:** make sure you're not committing and pushing the `credential.json` file.

## Retrive data (runnning in a container)
Build your docker file
```
docker build -t ${name} .
```

Run container with mounted volume to working directory. Make sure you're in the following directory: `mcloud-az-playground/scripts/GSheet`, otherwise the incorrect files will be mounted. 
```
docker run -it --rm -v ${PWD}:/tmp/vol ${name} 
```

## Retrive data (runnning local)

Install python (> 3.10.7) and install required packages with pip:
```
pip install -r requirements.txt`
```

Run command following command to get data
```
python getSheet.py
```

# Possible next steps
- Create Python objects from entries in worksheet for easier access of attributes
- Add google credential to keyvault and use Azure service principal to retrieve it
- Improve interaction with Google api and add a filter for example.
