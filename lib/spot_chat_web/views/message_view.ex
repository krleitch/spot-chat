defmodule SpotChatWeb.MessageView do
  use SpotChatWeb, :view

  # Has it been too long between messages we need a new block
  defp too_long(low, high) do
    min = 5 * 60
    DateTime.diff(low, high) >= min
  end

  defp getChatProfileId(%{room: room, message: message}) do
    :crypto.hash(:sha256, room.id <> message.user_id)
    |> Base.encode16()
  end

  def render("index.json", %{
        room: room,
        messages: messages,
        user_id: user_id,
        pagination: pagination
      }) do
    %{
      messages:
        Phoenix.View.render(
          SpotChatWeb.MessageView,
          "block.json",
          %{
            room: room,
            messages: messages,
            user_id: user_id
          }
        ),
      pagination: pagination
    }
  end

  def render("block.json", %{
        room: room,
        messages: messages,
        user_id: user_id
      }) do
    # remember the last message id for creating new block
    Enum.reduce(messages, {[], nil}, fn message, acc ->
      # create a new message block if
      # time has passed > 5 mins
      # the user has changed
      case acc do
        {[], nil} ->
          # add the first message block
          profile = SpotChatWeb.ProfileHelpers.getProfile(%{room: room, message: message})

          {[
             %{
               insertedAt: message.inserted_at,
               profilePictureSrc: profile.profile_picture_src,
               profilePictureNum: profile.profile_picture_num,
               owned: message.user_id == user_id,
               chatProfileId: getChatProfileId(%{room: room, message: message}),
               showDate: true,
               messages: [%{id: message.id, text: message.text, insertedAt: message.inserted_at}]
             }
           ], message}

        # otherwise get the last block and see if we add to it or make a new block
        {[block | list] = blocks, last_message} ->
          show_date = too_long(last_message.inserted_at, message.inserted_at)
          if (message.user_id !== last_message.user_id || show_date) do
            # create a new block
            profile = SpotChatWeb.ProfileHelpers.getProfile(%{room: room, message: message})

            {[
               %{
                 insertedAt: message.inserted_at,
                 profilePictureSrc: profile.profile_picture_src,
                 profilePictureNum: profile.profile_picture_num,
                 owned: message.user_id == user_id,
                 chatProfileId: getChatProfileId(%{room: room, message: message}),
                 showDate: show_date,
                 messages: [
                   %{id: message.id, text: message.text, insertedAt: message.inserted_at}
                 ]
               }
               | blocks
             ], message}
          else
            # add to last block
            {[
               %{
                 # its the first message inserted at that the block has
                 insertedAt: message.inserted_at,
                 profilePictureSrc: block.profilePictureSrc,
                 profilePictureNum: block.profilePictureNum,
                 owned: block.owned,
                 chatProfileId: block.chatProfileId,
                 showDate: block.showDate,
                 messages: [
                   %{id: message.id, text: message.text, insertedAt: message.inserted_at}
                   | block.messages
                 ]
               }
               | list
             ], message}
          end
      end
    end)
    |> elem(0)
  end

  def render("message.json", %{room: room, message: message, owned: owned}) do
    profile = SpotChatWeb.ProfileHelpers.getProfile(%{room: room, message: message})

    %{
      id: message.id,
      insertedAt: message.inserted_at,
      text: message.text,
      chatProfileId: getChatProfileId(%{room: room, message: message}),
      profilePictureNum: profile.profile_picture_num,
      profilePictureSrc: profile.profile_picture_src,
      owned: owned
    }
  end
end
