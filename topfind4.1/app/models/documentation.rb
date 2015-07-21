class Documentation < ActiveRecord::Base
  def self.add
    change_table :documentation do |t|
      t.string :name
      t.string :title
      t.text :long
      t.text :short
      t.string :category
      t.integer :position, :default => 0
      t.boolean :show, :default => false

      t.timestamps
    end
  end
end
