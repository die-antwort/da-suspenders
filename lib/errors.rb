# User errors

module DaSuspenders
  class InvalidInput < Exception; end

  module Errors
    def error_with_message(msg)
      STDERR.puts msg
      exit 1
    end
  end
end
