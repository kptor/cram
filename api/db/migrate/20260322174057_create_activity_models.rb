class CreateActivityModels < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :activity_parts do |t|
      t.references :activity, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.references :partable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :activity_parts, [:activity_id, :position]

    create_table :activity_multiple_choices do |t|
      t.text :prompt, null: false

      t.timestamps
    end

    create_table :activity_multiple_choice_choices do |t|
      t.references :activity_multiple_choice, null: false, foreign_key: true
      t.string :label, null: false
      t.boolean :correct, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :activity_multiple_choice_choices, [:activity_multiple_choice_id, :position],
              name: "idx_mc_choices_on_mc_id_and_position"

    create_table :assignments do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :assignments, [:activity_id, :user_id], unique: true
  end
end
