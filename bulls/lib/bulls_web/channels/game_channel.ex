defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  @impl true
  def join("game:" <> _id, payload, socket) do
    if authorized?(payload) do
			game = Bulls.Game.new()
			socket = assign(socket, :game, game)
			view = Bulls.Game.view(game)
      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

	# handles guesses submitted by the player
	# delegates to Bulls.Game which will validate and return state	
	# Note: will always return ok message, may not change state if game is 'over'
	@impl true
	def handle_in("guess", digits, socket) do
		gameBefore = socket.assigns[:game]
		gameAfter = Bulls.Game.guess(gameBefore, digits)
		socket = assign(socket, :game, gameAfter)
		view = Bulls.Game.view(gameAfter)
		{:reply, {:ok, view}, socket}	
	end

	# handles a reset game
	@impl true
	def handle_in("reset", payload, socket) do
		gameAfter = Bulls.Game.new()
		socket = assign(socket, :game, gameAfter)
		view = Bulls.Game.view(gameAfter)
		{:reply, {:ok, view}, socket}
	end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
