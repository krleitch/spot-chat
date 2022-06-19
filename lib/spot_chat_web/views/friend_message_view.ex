defmodule SpotChatWeb.FriendMessageView do
  use SpotChatWeb, :view

  # Has it been too long between messages we need a new block
  defp too_long(low, high) do
    min = 5 * 60
    DateTime.diff(low, high) >= min
  end

  def render("index.json", %{
        messages: messages,
        user_id: user_id,
        pagination: pagination
      }) do
    %{
      messages:
        Phoenix.View.render(
          SpotChatWeb.FriendMessageView,
          "block.json",
          %{
            messages: messages,
            user_id: user_id
          }
        ),
      pagination: pagination
    }
  end

  def render("block.json", %{
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

          {[
             %{
               insertedAt: message.inserted_at,
               owned: message.user_id == user_id,
               showDate: true,
               messages: [%{id: message.id, text: message.text, insertedAt: message.inserted_at}]
             }
           ], message}

        # otherwise get the last block and see if we add to it or make a new block
        {[block | list] = blocks, last_message} ->
          show_date = too_long(last_message.inserted_at, message.inserted_at)

          if message.user_id !== last_message.user_id || show_date do
            # create a new block

            {[
               %{
                 insertedAt: message.inserted_at,
                 owned: message.user_id == user_id,
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
                 owned: block.owned,
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

  def render("message.json", %{message: message, owned: owned}) do
    %{
      id: message.id,
      insertedAt: message.inserted_at,
      text: message.text,
      owned: owned
    }
  end
end
