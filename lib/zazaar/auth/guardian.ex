defmodule ZaZaar.Auth.Guardian do
  use Guardian, otp_app: :zazaar

  alias ZaZaar.Account
  alias Account.User

  def subject_for_token(%User{id: user_id}, _claims) do
    {:ok, user_id}
  end

  def subject_for_token(_, _) do
    {:error, :cannot_encode_jwt}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    user = Account.get_user(user_id)
    {:ok, user}
  end

  def resource_from_claims(_) do
    {:error, :cannot_decode_jwt}
  end
end
