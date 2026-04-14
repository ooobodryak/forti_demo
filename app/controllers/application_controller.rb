class ApplicationController < ActionController::Base
  include Pagy::Backend
  add_flash_types :info, :error, :warning
end
