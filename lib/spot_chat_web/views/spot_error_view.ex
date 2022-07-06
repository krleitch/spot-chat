defmodule SpotChatWeb.SpotErrorView do
  use SpotChatWeb, :view

  def render("error.json", %{spot_error: spot_error}) do
    %{
      statusCode: spot_error.statusCode,
      status: spot_error.status,
      name: spot_error.name,
      message: spot_error.message,
      body: spot_error.body
    }
  end
end
