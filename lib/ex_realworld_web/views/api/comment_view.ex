defmodule ExRealworldWeb.Api.CommentView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.CommentView
  alias ExRealworldWeb.Api.ContentsUserView

  def render("comments.json", %{comments: comments}) do
    %{
      comments: render_many(comments, CommentView, "comment.json")
    }
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      createdAt: comment.inserted_at,
      updatedAt: comment.updated_at,
      body: comment.body
      # TODO: Read more about preloading nested resource, then enable this.
      # author: render_one(comment.author, ContentsUserView, "user.json")
    }
  end

  def render("show.json", %{comment: comment}) do
    %{
      comment: render_one(comment, CommentView, "comment.json")
    }
  end
end
