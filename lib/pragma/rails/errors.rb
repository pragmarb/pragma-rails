# frozen_string_literal: true

module Pragma
  module Rails
    # Raised when an operation doesn't set a +result.response+ skill.
    class NoResponseError < StandardError
      def initialize
        super <<~MESSAGE
          Your operation did not return a `result.response` skill, which might mean one of the following:

            * The execution of the operation halted early (maybe one of your steps returned a falsey value?).
            * You forgot to set a `result.response` skill in a custom operation.
        MESSAGE
      end
    end
  end
end
