defmodule SpotChatWeb.ProfileHelpers do
  def getProfile(%{room: room, message: message}) do
    upperbound_src = 70
    lowerbound_src = 0
    upperbound_num = 25
    lowerbound_num = 0

    hash =
      :crypto.hash(:sha256, room.id <> message.user_id)
      |> Base.encode16()

    {int_hash, _} = Integer.parse(hash, 16)
    index_num = rem(int_hash, upperbound_num - lowerbound_num) + lowerbound_num
    index_src = rem(int_hash, upperbound_src - lowerbound_src) + lowerbound_src
    room_user_id = room.user_id

    case message.user_id do
      ^room_user_id ->
        %{
          profile_picture_num: -1,
          profile_picture_src: "op.png"
        }

      _ ->
        %{
          profile_picture_num: index_num,
          profile_picture_src: pictures(index_src)
        }
    end
  end

  defp pictures(index) do
    urls = [
      "icons8-banana-split-48.png",
      "icons8-avocado-48.png",
      "icons8-bao-bun-48.png",
      "icons8-beet-48.png",
      "icons8-bento-48.png",
      "icons8-birthday-cake-48.png",
      "icons8-blueberry-48.png",
      "icons8-bread-48.png",
      "icons8-brigadeiro-48.png",
      "icons8-broccoli-48.png",
      "icons8-caviar-48.png",
      "icons8-cereal-48.png",
      "icons8-cheese-48.png",
      "icons8-cherry-48.png",
      "icons8-chocolate-bar-48.png",
      "icons8-cinnamon-roll-48.png",
      "icons8-coconut-48.png",
      "icons8-cookies-48.png",
      "icons8-corn-48.png",
      "icons8-cute-pumpkin-48.png",
      "icons8-dim-sum-48.png",
      "icons8-doughnut-48.png",
      "icons8-dragon-fruit-48.png",
      "icons8-eggplant-48.png",
      "icons8-gingerbread-house-48.png",
      "icons8-grapes-48.png",
      "icons8-greek-salad-48.png",
      "icons8-heinz-beans-48.png",
      "icons8-hot-dog-48.png",
      "icons8-jam-48.png",
      "icons8-kawaii-bread-48.png",
      "icons8-kawaii-coffee-48.png",
      "icons8-kawaii-cupcake-48.png",
      "icons8-kawaii-egg-48.png",
      "icons8-kawaii-french-fries-48.png",
      "icons8-kawaii-ice-cream-48.png",
      "icons8-kawaii-pizza-48.png",
      "icons8-kawaii-soda-48.png",
      "icons8-kawaii-steak-48.png",
      "icons8-kawaii-sushi-48.png",
      "icons8-kawaii-taco-48.png",
      "icons8-lasagna-48.png",
      "icons8-macaron-48.png",
      "icons8-melting-ice-cream-48.png",
      "icons8-merry-pie-48.png",
      "icons8-milk-carton-48.png",
      "icons8-mushroom-48.png",
      "icons8-noodles-48.png",
      "icons8-nut-48.png",
      "icons8-pancake-48.png",
      "icons8-peach-48.png",
      "icons8-pie-48.png",
      "icons8-pineapple-48.png",
      "icons8-popcorn-48.png",
      "icons8-porridge-48.png",
      "icons8-potato-chips-48.png",
      "icons8-pretzel-48.png",
      "icons8-pumpkin-48.png",
      "icons8-rack-of-lamb-48.png",
      "icons8-raspberry-48.png",
      "icons8-rice-bowl-48.png",
      "icons8-salad-48.png",
      "icons8-soy-sauce-48.png",
      "icons8-spam-can-48.png",
      "icons8-steak-48.png",
      "icons8-strawberry-48.png",
      "icons8-taco-48.png",
      "icons8-thanksgiving-48.png",
      "icons8-wrap-48.png",
      "icons8-yogurt-48.png"
    ]

    Enum.at(urls, index)
  end
end
