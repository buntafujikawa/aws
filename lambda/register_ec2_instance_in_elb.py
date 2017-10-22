import boto3

# ec2を立ち上げてelbに紐付ける
# INSTANCE_ID, ARNはlambdaの環境変数で設定
# エラーハンドリングもできてないし、ログも出ない

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    ec2_response = ec2.start_instances(
        InstanceIds = [
            INSTANCE_ID,
        ]
    )
    print ec2_response

    waiter = ec2.get_waiter('instance_running')
    waiter.wait(InstanceIds = [INSTANCE_ID])

    elb = boto3.client('elb')
    elb_response = elb.register_instances_with_load_balancer(
        LoadBalancerName = LOAD_BALANCER_NAME,
        Instances=[
            {
                'InstanceId': INSTANCE_ID
            },
        ]
    )

    print elb_response