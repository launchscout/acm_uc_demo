defmodule AcmUcDemoWeb.PageController do
  use AcmUcDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
