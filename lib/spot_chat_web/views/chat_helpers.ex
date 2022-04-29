defmodule SpotChatWeb.ChatHelpers do
  def getDefaultImage(%{room: room}) do
    upperbound_src = 22
    lowerbound_src = 0
    upperbound_num = 25
    lowerbound_num = 0

    hash =
      :crypto.hash(:sha256, room.id)
      |> Base.encode16()

    {int_hash, _} = Integer.parse(hash, 16)
    index_num = rem(int_hash, upperbound_num - lowerbound_num) + lowerbound_num
    index_src = rem(int_hash, upperbound_src - lowerbound_src) + lowerbound_src

    %{
      default_image_num: index_num,
      default_image_src: pictures(index_src)
    }
  end

  defp pictures(index) do
    urls = [
      "icons8-volcano-96.png",
      "icons8-venice-canal-96.png",
      "icons8-us-capitol-96.png",
      "icons8-triumphal-arch-96.png",
      "icons8-tower-of-pisa-96.png",
      "icons8-taj-mahal-96.png",
      "icons8-statue-of-liberty-96.png",
      "icons8-statue-of-christ-the-redeemer-96.png",
      "icons8-rheinturm-96.png",
      "icons8-kremlin-96.png",
      "icons8-island-on-water-96.png",
      "icons8-iceberg-96.png",
      "icons8-historic-ship-96.png",
      "icons8-grand-canyon-96.png",
      "icons8-gondola-96.png",
      "icons8-fuji-96.png",
      "icons8-eiffel-tower-96.png",
      "icons8-colosseum-96.png",
      "icons8-cn-tower-96.png",
      "icons8-brandenburg-gate-96.png",
      "icons8-big-ben-96.png",
      "icons8-alps-96.png",
      "icons8-25-de-abril-bridge-96.png"
    ]

    Enum.at(urls, index)
  end
end
