defmodule SpotChatWeb.PaginationHelpers do
  def pagination(page) do
    %{
      after: page.metadata.after,
      before: page.metadata.before,
      limit: page.metadata.limit,
      total_count: page.metadata.total_count
    }
  end
end
