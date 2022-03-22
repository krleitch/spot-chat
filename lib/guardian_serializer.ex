defmodule SpotChat.Guardian do
  use Guardian, otp_app: :SpotChat

  def subject_for_token(%{id: id}, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    IO.puts('Setting resource')
    sub = to_string(id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    url = "http://localhost:3000/user"
    headers = ["Authorization": "Bearer #{id}", "Accept": "Application/json; Charset=utf-8"]
    IO.puts('getting resource')
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        user = Poison.decode!(body)
        {:ok, user["user"]}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        :error
      {:error, %HTTPoison.Error{reason: _reason}} ->
        :error
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
