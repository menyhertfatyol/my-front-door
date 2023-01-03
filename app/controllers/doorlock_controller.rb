class DoorlockController < ApplicationController
  def index
    @doorlock = OpenStruct.new(StatusStorage.read_state[:item])
  end
end
