defmodule SouboryWeb.FilesLive do
  use Phoenix.LiveView

  def mount(_session, _, socket) do
    socket = assign(socket, :count, 0)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1> Count: <%= @count%></h1>
    <button phx-click="increment"> ++</button>
    """
  end

  def handle_event("increment", _, socket) do
    count = socket.assings.count + 1
    # socket = assign(socket, :count, count)
    {:noreply, assign(socket, :count, count)}
  end
end
