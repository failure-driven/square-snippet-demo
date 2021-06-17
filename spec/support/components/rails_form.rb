# rubocop:disable Metrics/AbcSize
module Support
  module Components
    class RailsForm
      def initialize(form)
        @form = form
      end

      def fill_in(args = {})
        args.each do |label_text, value|
          if value == true
            @form.check(label_text)
          elsif value == false
            @form.uncheck(label_text)
          elsif value.instance_of?(String)
            @form.fill_in(label_text, with: value)
          end
        end
      end

      def is_checked(label)
        @form.find_field(label, disabled: :all).checked?
      end

      def is_disabled(label)
        @form.find_field(label, disabled: :all).disabled?
      end

      def select(args)
        args.each do |label_text, value|
          @form.select(value, from: label_text)
        end
      end

      def submit(args = {})
        fill_in(args)
        @form.find("[type=submit]").click
      end

      def submit_button_exists?
        @form.all("input").select { |i| i["type"] == "submit" }.any?
      end

      def readonly_form?
        @form.find("fieldset").disabled?
      end

      def text_value_for(label_text)
        @form.find_field(label_text, disabled: :all).value
      end

      def select_value_for(label_text)
        binding.pry
        @form.all("input").select { |i| i["name"] == label_text }.value
        # @form.find("select")
        # @form.find_field(label_text, disabled: :all).value
      end

      def update(args = {})
        if args.empty?
          @form.find_all(".form-group").select do |form_group|
            ele = form_group.find("input")
            ele.set("") unless ele.disabled?
          end
        end

        args.each do |field_name, value|
          ele = @form.find_field(field_name, disabled: false)
          ele.set(value)
        end

        @form.find("[type=submit]").click
      end

      def fields
        @form
          .find_all(".form-group")
          .reduce({}) do |accumulator, form_group|
          label = form_group.find("label").text.strip
          error = form_group.find_all(".invalid-feedback", wait: false).map(&:text).map(&:strip).join("\n")
          input = form_group.find("input")
          input_and_error = {
            # strip is workaround for strange flake where an empty field sometimes contained " " instead of ""
            value: input.value.strip,
          }
          input_and_error[:readonly] = input.readonly? if input.readonly?
          input_and_error[:error] = error unless error.empty?
          accumulator.merge(label => input_and_error)
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
