# Make it possible to use #localize (#l) like this:
#
#     "#{l @date}" # now returns an empty string if @date is nil
#     <%=l @date || "n.a." %>
#
# If the given object does not respond to #strftime, we just return the object itself.
module ActionView::Helpers::TranslationHelper

  def localize_with_fallback(object, options = {})
    # Duplicate the check from I18n, see https://github.com/svenfuchs/i18n/blob/v0.6.0/lib/i18n/backend/base.rb#L48
    return object unless object.respond_to?(:strftime)

    localize_without_fallback(object, options)
  end
  alias :l_with_fallback :localize_with_fallback

  alias_method_chain :localize, :fallback
  alias_method_chain :l, :fallback
end
