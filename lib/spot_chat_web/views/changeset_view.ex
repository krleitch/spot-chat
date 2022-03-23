defmodule SpotChatWeb.ChangesetView do
  use SpotChatWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors as a JSON object
    %{errors: translate_errors(changeset)}
  end
end
