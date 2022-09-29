FROM python:3.8-slim-bullseye
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt

# to fix https://security.snyk.io/vuln/SNYK-DEBIAN11-EXPAT-3023031
RUN apt update -y && apt install libexpat1

CMD ["python3", "app.py"]