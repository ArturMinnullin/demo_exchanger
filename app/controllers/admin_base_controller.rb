# frozen_string_literal: true

class AdminBaseController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'password'
end
