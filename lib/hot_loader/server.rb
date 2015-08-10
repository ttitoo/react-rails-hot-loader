require 'em-websocket'

module React
  module Rails
    module HotLoader
      class Server
        attr_reader :host, :port, :change_set_class

        def initialize(host:  "0.0.0.0", port: React::Rails::HotLoader.port || 8082, change_set_class: React::Rails::HotLoader::AssetChangeSet)
          @host = host
          @port = port
          @change_set_class = change_set_class
        end

        # Restarts the server _if_ it has stopped
        def restart
          return if running?
          start
        rescue StandardError => err
          React::Rails::HotLoader.error(err)
        end

        private

        def running?
          @server_thread && @server_thread.alive?
        end

        def start
          @server_thread = Thread.new do
            begin
              serve
            rescue StandardError => err
              React::Rails::HotLoader.error(err)
            end
          end
        end

        def serve
          EM.run {
            React::Rails::HotLoader.log("starting WS server: ws://#{host}:#{port}")

            EM::WebSocket.run(host: host, port: port) do |ws|
              ws.onopen     { React::Rails::HotLoader.log("opened a connection") }
              ws.onmessage  { |msg| handle_message(ws, msg) }
              ws.onclose    { React::Rails::HotLoader.log("closed a connection") }
            end

            React::Rails::HotLoader.log("started WS server")
          }
        end

        # Check for any changes since `msg`, respond if there are any changes
        def handle_message(ws, msg)
          # React::Rails::HotLoader.log("received message: #{msg}")
          since_time =  Time.at(msg.to_i)
          changes = change_set_class.new(since: since_time)
          if changes.any?
            React::Rails::HotLoader.log("sent changes: #{changes.changed_file_names}")
            ws.send(changes.to_json)
          end
        rescue StandardError => err
          React::Rails::HotLoader.error(err)
        end
      end
    end
  end
end
