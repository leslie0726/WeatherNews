class CreateWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :weathers do |t|
      t.string :siteName
      t.string :windDirection
      t.integer :windPower
      t.string :temperature
      t.string :weather
      t.timestamp :dataCreationDate

      t.timestamps
    end
  end
end
