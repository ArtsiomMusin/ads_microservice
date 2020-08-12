module AuthService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }
    option :repry_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    attr_accessor :result

    def self.fetch
      Thread.current['ads_service.rpc_client'] ||= new.start
    end

    def start
      @repry_queue.subscribe do |delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          self.result = payload
          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('amq.rabbitmq.reply-to', durable: true)
    end

    def publish(payload, opts = {})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        res = @queue.publish(
          payload,
          opts.merge(
            app_id: Settings.app.name,
            correlation_id: @correlation_id,
            reply_to: @repry_queue.name,
            headers: {
              request_id: Thread.current[:request_id]
            }
          )
        )
        @condition.wait(@lock)
      end

      self
    end
  end
end
