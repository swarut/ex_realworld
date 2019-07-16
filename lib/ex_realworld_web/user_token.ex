defmodule ExRealworldWeb.UserToken do
  use Guardian, otp_app: :ex_realworld

  def subject_for_token(resource, _claim) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    email = claims["email"]
    resource = %{id: id, email: email}
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
