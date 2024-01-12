class CreatePromptData < ActiveRecord::Migration[7.0]
  def change
    create_table :prompt_data do |t|
      t.text :content

      t.timestamps
    end
  end
end
