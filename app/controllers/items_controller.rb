class ItemsController < ApplicationController

  def index
    @items = []
    @items << Item.all
  end

end
