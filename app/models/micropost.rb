class Micropost < ApplicationRecord
  belongs_to :user
  # default_scope, which among other things can be used to set the default order 
  # in which elements are retrieved from the database. 
  # To enforce a particular order, we’ll include the order argument in 
  # default_scope, which lets us order by the created_at column
  # Here DESC is SQL for “descending”, i.e., in descending order from newest to oldest
  default_scope -> { order(created_at: :desc) }
  
  # The way to tell CarrierWave to associate the image with a model is to use 
  # the mount_uploader method, which takes as arguments a symbol representing 
  # the attribute and the class name of the generated uploader
  mount_uploader :picture, PictureUploader # add an image to the Micropost model
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
