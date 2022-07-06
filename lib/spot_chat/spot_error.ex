defmodule SpotChat.SpotError do
  defstruct statusCode: 500, status: "Error", name: "SpotError", message: "Error", body: nil
end
