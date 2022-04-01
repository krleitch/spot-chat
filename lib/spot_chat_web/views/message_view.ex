defmodule SpotChatWeb.MessageView do
  use SpotChatWeb, :view

  def render("index.json", %{
        messages: messages,
        user_id: user_id,
        pagination: pagination
      }) do
    %{
      messages:
        Enum.map(messages, fn message ->
          render_one(
            %{
              message: message,
              user_id: user_id,
              profile:
                SpotChatWeb.ProfileHelpers.getProfile(%{message: message, user_id: user_id})
            },
            SpotChatWeb.MessageView,
            "message.json"
          )
        end),
      pagination: pagination
    }
  end

  def render("message.json", %{message: %{message: message, user_id: user_id, profile: profile}}) do
    %{
      id: message.id,
      insertedAt: message.inserted_at,
      text: message.text,
      profilePictureNum: profile.profile_picture_num,
      profilePictureSrc: profile.profile_picture_src,
      owned: message.user_id == user_id
    }
  end
end
