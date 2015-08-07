class CreateMolecules < ActiveRecord::Migration
  def change
    create_table :molecules do |t|

      t.timestamps null: false
    end
  end
end
