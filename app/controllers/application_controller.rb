class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "skuroki", password: ENV['TIME_CARD_PASSWORD']
end
