defmodule AcmUcDemo.Repo do
  use Ecto.Repo,
    otp_app: :acm_uc_demo,
    adapter: Ecto.Adapters.Postgres
end
