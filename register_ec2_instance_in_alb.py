import boto3

# ec2を立ち上げてalbに紐付ける
# INSTANCE_ID, ARNはlambdaの環境変数で設定
# エラーハンドリングもできてないし、ログも出ない

def lambda_handler(event, context):
    client = boto3.client('ec2')
    ec2_response = client.start_instances(
        InstanceIds = [
            INSTANCE_ID,
        ]
    )

    waiter = client.get_waiter('instance_running')
    waiter.wait(InstanceIds = [INSTANCE_ID])

    client = boto3.client('elbv2')
    elb_response = client.register_targets(
        TargetGroupArn = ARN,
        Targets = [
            {
                'Id': INSTANCE_ID,
                'Port': 80
            },
        ],
    )