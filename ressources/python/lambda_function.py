import json
import urllib.parse
import boto3
import uuid
from decimal import Decimal

print('Loading function')

dynamodb = boto3.resource('dynamodb')


def detect_labels(photo, bucket):
    client = boto3.client('rekognition')
    response = client.detect_labels(Image={'S3Object': {'Bucket': bucket, 'Name': photo}},
                                    MaxLabels=1)
    return response['Labels']

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))

    if len(event["Records"]) == 0:
        raise Exception("Records should not be empty")
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        label = detect_labels(key, bucket)
        table = dynamodb.Table('dynamo-vsugana')
        data = {
            'id': uuid.uuid4().hex,
            'FileName': key,
            'label': label[0]['Name'],
            'Confidence': Decimal(label[0]['Confidence'])
        }
        response = table.put_item(Item=data)
        print(data)

    except Exception as e:
        print(e)
        print(
            'Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(
                key, bucket))
        raise e
