Rack::Timeout.timeout = Rails.env.development? ? 0 : 20
