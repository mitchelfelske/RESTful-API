class Todo < ApplicationRecord

  # Validations
  validates_presence_of :title, :created_by

end
