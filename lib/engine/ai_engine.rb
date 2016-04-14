module NUSBotgram
  module AI
    class AIEngine
      CONFIG = YAML.load_file("lib/config/config.yml")

      def initialize
        @client = ApiAiRuby::Client.new(
            :client_access_token => CONFIG[4][:APIAI_CLIENT_ACCESS_TOKEN],
            :subscription_key => CONFIG[4][:APIAI_SUBSCRIPTION_KEY])
      end

      def learn(query = '')
        response = @client.text_request(query.to_s)

        intent = intentions(response)

        if intent == Global::WISDOM_UNKNOWN
          Global::WISDOM_UNKNOWN
        else
          if intent[0].eql?("request-timetable")
            [intent[2], entities(intent[1])]
          elsif intent[0].eql?("greetings")
            [intent[1], intent[2]]
          end
        end
      end

      def intentions(response)
        intent = JSON.parse(response.to_json)

        if intent["result"]["contexts"].eql?("") || intent["result"]["contexts"] == nil
          Global::WISDOM_UNKNOWN
        else
          [intent["result"]["contexts"][0]["name"], intent["result"]["contexts"][0]["parameters"], intent["result"]["action"]]
        end
      end

      def entities(query)
        result = JSON.parse(query.to_json)
        res_entities = Array.new

        res_entities.push result["date"]
        res_entities.push result["task"]
        res_entities.push result["type"]
        res_entities.push result["timing"]

        res_entities.reject { |e| e.empty? }
      end
    end
  end
end
