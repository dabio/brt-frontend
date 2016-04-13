class Participation < Sequel::Model

  many_to_one :person
  many_to_one :event

  dataset_module do
    def ordered
      order(:date).reverse.order(:position_overall)
    end
  end

  set_dataset ordered

end
