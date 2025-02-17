defmodule KousaTest.Broth.GetUserProfileTest do
  use ExUnit.Case, async: true
  use Kousa.Support.EctoSandbox

  alias Beef.Schemas.User
  alias Beef.Users
  alias Broth.WsClient
  alias Broth.WsClientFactory
  alias Kousa.Support.Factory

  require WsClient

  setup do
    user = Factory.create(User)
    client_ws = WsClientFactory.create_client_for(user)

    {:ok, user: user, client_ws: client_ws}
  end

  describe "the websocket get_user_profile operation" do
    test "can get your own user info", t do
      user_id = t.user.id

      ref =
        WsClient.send_call(
          t.client_ws,
          "get_user_profile",
          %{"userId" => t.user.id}
        )

      WsClient.assert_reply(
        ref,
        %{
          "id" => ^user_id
        }
      )
    end

    @tag :skip
    test "you can't stalk someone who has blocked you"
  end
end
