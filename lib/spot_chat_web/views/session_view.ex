defmodule SpotChatWeb.SessionView do
  use SpotChatWeb, :view

  def render("show.json", %{jwt: jwt}) do
    %{
      meta: %{token: jwt}
    }
  end

  def render("error.json", _) do
    %{error: 'Invalid token'}
  end

  def render("forbidden.json" ,%{error: error}) do
    %{error: error}
  end

end
