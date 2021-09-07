defmodule CommentsWeb.CommentsController do
  use CommentsWeb, :controller

  @doc """
  Get the UUIDs for the given section.

  So can then use the UUIDs for the other top-level calls.

  Output of the form:

  ```
  debf1af0-40ac-5457-ba31-20aa40759a56
  74c7a059-b044-582c-b9df-e68fb486acb2
  ac950d9b-ebe2-58e2-af22-c6f00de9fbb5
  [...]
  ```
  """
  def section_uuids(conn, params) do
    %{"section" => section} = params

    out =
      get_section_article_uuids(section)
      |> Enum.join("\n")

    text(conn, out)
  end

  @doc """
  Add a comment for the provided article_uuid.
  """
  def add_comment(conn, params) do
    article_uuid = params["article_uuid"]
    author = params["author"]
    body = params["body"]

    cond do
      is_nil(author)  or
      is_nil(body)  or
      String.length(author) == 0 or
      String.length(body) == 0 ->
        send_resp(conn, 400, "Missing 'author' and 'body'")

      true ->
        map = %{
          id: UUID.uuid1(),
          article_id: article_uuid,
          author: author,
          body: body,
          posted_at: DateTime.to_iso8601(DateTime.utc_now())
        }

        :ets.insert(:comments, {article_uuid, map})

        json(conn, map)
    end
  end

  @doc """
  Get comments for the provided article_uuid.
  """
  def get_comments(conn, params) do
    %{"article_uuid" => article_uuid} = params

    # Get the map as inserted in add_comment/2
    ret =
      :ets.lookup(:comments, article_uuid)
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort(&(&1.posted_at >= &2.posted_at))

    json(conn, ret)
  end

  @doc """
  Get summary of comments for the given section.
  """
  def get_section_counts(conn, _params) do
    conn = Plug.Conn.fetch_query_params(conn)
    qp = conn.query_params

    case qp["section"] do
      nil ->
        do_get_section_counts(conn, "home")

      section ->
        do_get_section_counts(conn, section)
    end
  end

  defp get_section_article_uuids(section) do
    get_results_list_for_section(section)
    |> Enum.map(&uuid_from_result/1)
  end

  def uuid_from_result(result) do
    result["uri"]
    |> String.split("/")
    |> List.last()
  end

  def do_get_section_counts(conn, section) do
    ret =
      get_results_list_for_section(section)
      |> Enum.map(&get_article_info/1)
      |> Enum.map(&create_output_for_article/1)

    json(conn, ret)
  end

  def create_output_for_article(article_info) do
    # Add the comment counts

    comments = :ets.lookup(:comments, article_info.id)

    case comments do
      [] ->
      article_info
      |> Map.put("comments_count", 0)
      |> Map.put("comments_path", "/articles/#{article_info.id}/comments")

      all ->
      article_info
      |> Map.put("comments_count", length(all))
      |> Map.put("comments_path", "/articles/#{article_info.id}/comments")
    end
  end


  @doc """
  Get the article_uuid, title, byline, and published_date.
  """
  def get_article_info(result) do
    %{"title" => title, "byline" => byline, "published_date" => published_date} = result
    article_uuid = uuid_from_result(result)

    %{
      id: article_uuid,
      title: title,
      byline: byline,
      published_date: published_date
    }
  end

  def get_results_list_for_section(section) do
    # We know it's set due to check in Comments.Application
    api_key = System.get_env("NYT_API_KEY")
    url = "https://api.nytimes.com/svc/topstories/v2/#{section}.json?api-key=#{api_key}"
    %{body: body} = HTTPoison.get!(url)

    Jason.decode!(body)
    |> Map.get("results")
  end

end
