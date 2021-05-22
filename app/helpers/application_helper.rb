# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :notice then 'alert-info'
    when :alert then 'alert-info'
    when :success then 'alert-success'
    when :error || :alert then 'alert-danger'
    else "alert-#{flash_type}"
    end
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(
        content_tag(
          :div,
          message,
          class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show",
          role: 'alert'
        ) do
          concat content_tag(
            :button,
            nil,
            class: 'btn-close',
            data: { "bs-dismiss": 'alert' },
            "aria-lable": 'Close'
          )
          concat content_tag(
            :span,
            message,
            data: { testid: 'message' }
          )
        end
      )
    end
    nil
  end
end
