module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exceptions::QueryError do |e|
      json_response({ message: e.message }, :bad_request)
    end
  end
end
