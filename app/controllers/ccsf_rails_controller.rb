class CcsfRailsController < ApplicationController
  def index
    @time = Time.now # Note the @time instance variable!
  end

  def hello
  end

  def login
  end

  def sign_out
  end

  def about
  end

  def bio
  end

  def mission_statment
  end

  def assignments
    @assignments =
    [
      {"name"=>"A1", "description"=>"What is Ruby"},
      {"name"=>"A2", "description"=>"What is Rails"},
      {"name"=>"A3", "description"=>"How to become a Rails Ninja"}
    ]
  end
  
end
