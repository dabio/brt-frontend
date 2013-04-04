# encoding: utf-8

module Pagination
  module ClassMethods

    # Allows the model to paginate
    def paginated(options={})
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || 5

      options.reverse_merge!({
        :order => [:id.desc]
      })

      page_count = (count(options.except(:order)).to_f / per_page).ceil

      options.merge!({
        :limit => per_page,
        :offset => (page - 1) * per_page
      })

      [ page_count, all(options) ]
    end

  end
end

DataMapper::Model.append_extensions(Pagination::ClassMethods)
