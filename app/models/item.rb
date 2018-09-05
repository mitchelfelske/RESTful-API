class Item < ApplicationRecord
  #Model Association
  belongs_to :todo

  #Validations
  validates_presence_of :name
end
