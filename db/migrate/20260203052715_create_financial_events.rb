class CreateFinancialEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_events do |t|

      t.timestamps
    end
  end
end
