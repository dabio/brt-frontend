class Event < Sequel::Model

  one_to_many :participations, :on_delete => :cascade
  many_to_many :people, :join_table => :participations

  dataset_module do
    def ordered
      order(:date).reverse
    end
  end

  set_dataset ordered

  def date_formatted(format='%-d. %B %Y')
    R18n::l(date, format)
  end

end
