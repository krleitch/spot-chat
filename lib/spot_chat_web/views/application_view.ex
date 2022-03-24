defmodule SpotChatWeb.ApplicationView do
  use SpotChatWeb, :view

  def render("not_found.json", _) do
    %{error: "Not found"}
  end
end
