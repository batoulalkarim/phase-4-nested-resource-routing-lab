class ItemsController < ApplicationController
  #returns a 404 response if the user is not found for ALL methods
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

#returns an array of all items belonging to a user

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else 
    items = Item.all
    end
    render json: items, include: :user
  end

  #returns the item with the matching id

  def show 
    item = find_item 
    render json: item
  end

  #POST creates a new item belonging to a user
  #returns the newly created item
  #returns a 201 success code
  def create 
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private 

  #these are making our code DRY
  
  def find_item 
    Item.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end

end
