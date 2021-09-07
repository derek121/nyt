defmodule CommentsWeb.Router do
  use CommentsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CommentsWeb do
    pipe_through :api

    # Outputs all the article_uuid values for the given section, which can
    # then be used in calls to the other endpoints
    get  "/article_uuids/:section", CommentsController, :section_uuids

    post "/articles/:article_uuid/comments", CommentsController, :add_comment
    get  "/articles/:article_uuid/comments", CommentsController, :get_comments

    get "/articles", CommentsController, :get_section_counts
  end
end
