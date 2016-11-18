class CreateJobPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :job_preferences do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
