class Inhibition2evidence < ActiveRecord::Base
  def self.add

    change_table :inhibition2evidence do |t|  
      t.timestamps
    end
   end
  belongs_to :evidence
  belongs_to :inhibition
  belongs_to :traceable, :polymorphic => true 
end
