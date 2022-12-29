import boto3
import os
import json
import psycopg2


db_host = os.environ['DB_HOST']
db_user = os.environ['DB_USER']
db_pass = os.environ['DB_PASSWORD']
db_name = os.environ['DATABASE_NAME']


def lambda_function(event, context):

    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_pass)

    cur = conn.cursor()
    cur.execute("SELECT text FROM tweets WHERE username='" + event['queryStringParameters']['username'] + "';")
    record = cur.fetchall()
    print("Result ", record)

    return {
        'statusCode': 200,
        'body': json.dumps(record)
    }