defmodule SpotChatWeb.PaginationHelpers do
  def pagination(page) do
    %{
      pageNumber: page.page_number,
      pageSize: page.page_size,
      totalPages: page.total_pages,
      totalEntries: page.total_entries
    }
  end
end
