module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  private

  def paginate(scope)
    total_count = scope.count
    records = scope.limit(per_page).offset((page - 1) * per_page)

    {
      data: records,
      meta: {
        page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: (total_count / per_page.to_f).ceil
      }
    }
  end

  def page
    [ params[:page].to_i, 1 ].max
  end

  def per_page
    requested = params[:per_page].to_i
    requested = Paginatable::DEFAULT_PER_PAGE if requested <= 0
    [ requested, Paginatable::MAX_PER_PAGE ].min
  end
end
