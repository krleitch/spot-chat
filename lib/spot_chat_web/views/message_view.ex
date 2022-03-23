defmodule SpotChatWeb.MessageView do
  use SpotChatWeb, :view

  def render("index.json", %{messages: messages, pagination: pagination}) do
    %{
      data: render_many(messages, SpotChatWeb.MessageView, "message.json"),
      pagination: pagination
    }
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      text: message.text,
      user: %{
        id: message.user_id
      }
    }
  end
end
