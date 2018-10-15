require "./controller_base"

module MyServer
  module HttpAPI
    module ProgramController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_programs(ctx)
        begin
          user = verify_token(ctx)
          items = Program.get_programs
          arr = [] of String
          items.each do |i|
            arr << i.to_json
          end
          json_array(arr)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
