FROM python:3.11.1

# Upgarde pip
RUN pip install --upgrade pip

# copy requirements.txt to /tmp and install requried packages
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR /tmp/vol
ENTRYPOINT [ "python", "getSheet.py" ]