module BootstrapHelper
  def alert_class_for_flash_key(key)
    case key
    when :notice then "alert-info"
    when :alert then "alert-error"
    when :success then "alert-success"
    end
  end
end