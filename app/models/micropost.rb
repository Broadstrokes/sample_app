class Micropost < ApplicationRecord
  belongs_to :user
  # default_scope, which among other things can be used to set the default order 
  # in which elements are retrieved from the database. 
  # To enforce a particular order, we’ll include the order argument in 
  # default_scope, which lets us order by the created_at column
  # Here DESC is SQL for “descending”, i.e., in descending order from newest to oldest
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
