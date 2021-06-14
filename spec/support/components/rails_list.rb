# frozen_string_literal: true

module Support
  module Components
    class RailsList
      def initialize(list_element)
        @list_element = list_element
        yield self if block_given?
      end

      def list_items
        list_items = @list_element.all("li")
        list_items.map { |item| item.text.split("\n") }
      end
    end
  end
end
