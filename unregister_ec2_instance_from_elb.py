import boto3
import time

# albから切り離してec2を停止させる
# INSTANCE_ID, ARNはlambdaの環境変数で設定
# エラーハンドリングもできてないし、ログも出ない

def lambda_handler(event, context):
    elb = boto3.client('elb')
    elb_response = elb.deregister_instances_from_load_balancer(
        LoadBalancerName = LOAD_BALANCER_NAME,
        Instances=[
            {
                'InstanceId': INSTANCE_ID
            },
        ]
    )
    print elb_response

    instance_status = ''
    while instance_status != 'OutOfService':
        instance_health = elb.describe_instance_health(
            LoadBalancerName = LOAD_BALANCER_NAME,
            Instances=[
                {
                    'InstanceId': INSTANCE_ID
                },
            ]
        )
        instance_status = instance_health["InstanceStates"][0]["State"]
        print instance_status
        time.sleep(1)

    ec2 = boto3.client('ec2')
    ec2_response = ec2.stop_instances(
        InstanceIds = [
            INSTANCE_ID,
        ]
    )
    print ec2_response