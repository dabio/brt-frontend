class Person < Sequel::Model

  one_to_many :participations, :on_delete => :cascade
  many_to_many :events, :join_table => :participations

  dataset_module do
    def ordered
      order(:last_name, :first_name)
    end
  end

  set_dataset ordered

  def name
    "#{first_name} #{last_name}"
  end

  def link
    "/team/#{slug}"
  end

  def encrypted_email
    email.gsub(/@/, ' [at] ').gsub(/\./, ' . ')
  end

  def results
    results ||= Event.where(people: self){date < Date.today}
  end

  def results_by_year
    results.select_group{ Sequel.extract(:year, date) }
  end

  def total_distance
    results.sum(:distance)
  end

end
