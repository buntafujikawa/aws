import boto3
import time

# albから切り離してec2を停止させる
# INSTANCE_ID, ARNはlambdaの環境変数で設定
# エラーハンドリングもできてないし、ログも出ない

def lambda_handler(event, context):
    client = boto3.client('elbv2')
    elb_response = client.deregister_targets(
        TargetGroupArn = ARN,
        Targets = [
            {
                'Id': INSTANCE_ID,
                'Port': 80
            },
        ]
    )

    instance_status = ''
    while instance_status != 'unused':
        instance_health = client.describe_target_health(
            TargetGroupArn = ARN,
            Targets = [
                {
                    'Id': INSTANCE_ID,
                    'Port': 80
                },
            ]
        )
        instance_status = instance_health["TargetHealthDescriptions"][0]["TargetHealth"]["State"]
        time.sleep(1)

    ec2 = boto3.client('ec2')
    ec2_response = ec2.stop_instances(
        InstanceIds = [
            INSTANCE_ID,
        ]
    )