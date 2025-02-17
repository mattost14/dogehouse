defmodule KousaTest.Broth.FollowInfoTest do
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

  describe "the websocket follow_info operation" do
    test "retrieves following info", t do
      user_id = t.user.id

      followed = %{id: followed_id} = Factory.create(User)
      followed_ws = WsClientFactory.create_client_for(followed)

      Kousa.Follow.follow(t.user.id, followed_id, true)

      ref =
        WsClient.send_call(
          t.client_ws,
          "follow_info",
          %{"userId" => followed_id}
        )

      WsClient.assert_reply(
        ref,
        %{
          "followsYou" => false,
          "youAreFollowing" => true
        },
        t.client_ws
      )

      ref =
        WsClient.send_call(
          followed_ws,
          "follow_info",
          %{"userId" => user_id}
        )

      WsClient.assert_reply(
        ref,
        %{
          "followsYou" => true,
          "youAreFollowing" => false
        },
        followed_ws
      )
    end
  end
end
