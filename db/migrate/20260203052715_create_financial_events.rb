class CreateFinancialEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_events do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :event_type, null: false
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.date :date, null: false
      t.string :hospital, null: false

      t.timestamps
    end
  end
end
