module Capitomcat
  class AwsElbManager
    def initialize(region:, access_key_id:, secret_access_key:, load_balancer_name:)
      @load_balancer_name = load_balancer_name

      @client = Aws::ElasticLoadBalancing::Client.new(
        access_key_id: access_key_id,
        region: region,
        secret_access_key: secret_access_key)
    end

    def deregister_instance(instance_id)
      client.deregister_instances_from_load_balancer(
        {
          load_balancer_name: load_balancer_name,
          instances: [
            {
              instance_id: instance_id
            }
          ]
        }
      )
    end

    def register_instance(instance_id)
      client.register_instances_with_load_balancer(
        {
          load_balancer_name: load_balancer_name,
          instances: [
            {
              instance_id: instance_id
            }
          ]
        }
      )
    end

    def instance_state(instance_id)
      client.describe_instance_health(
        {
          load_balancer_name: load_balancer_name,
          instances: [
            {
              instance_id: instance_id
            }
          ]
        }
      ).instance_states.first.state
    end

    private

    attr_reader :load_balancer_name, :client
  end
end
