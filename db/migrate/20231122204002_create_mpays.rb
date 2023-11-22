class CreateMpays < ActiveRecord::Migration[7.1]
  def change
    create_table :mpays do |t|
      t.string :checkoutRequestID
      t.string :merchantRequestID
      t.string :amount
      t.string :mpesaReceiptNumber
      t.string :phoneNumber

      t.timestamps
    end
  end
end
