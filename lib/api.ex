defmodule ExHttpMock.API do
  @moduledoc false

  alias ExHttpMock.{
    Parse,
    State
  }

  import Plug.Conn


  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    {:ok, data} = parse_yml(conn.request_path)
    status_code = build_status_code(data)
    response = build_response(data)

    conn
    |> build_headers(data)
    |> send_resp(status_code, response)
  end


  # ---------------------------------------------
  #                    PRIVATE
  # ---------------------------------------------
  defp parse_yml(path) do
    path
    |> State.get_path()
    |> Parse.read_file()
  end

  defp build_status_code(%{"response" => %{"status_code" => status_code}}) do
    status_code
  end

  defp build_status_code(_), do: 200

  defp build_response(%{"response" => %{"body" => body}}) when body != %{}do
    Poison.encode!(body)
  end

  defp build_response(_), do: ""

  defp build_headers(conn, %{"response" => %{"headers" => headers}}) do
    Enum.reduce(headers, conn, fn {key, value}, _->
      key = String.downcase(key)
      value = handle_header_list(value)

      put_resp_header(conn, key, value)
    end)
  end

  defp build_headers(conn, _resp) do
    conn
  end

  defp handle_header_list(value) when is_list(value) do
    list_to_string(value, "")
  end

  defp handle_header_list(value), do: value

  defp list_to_string([hd], string), do: string <> " #{hd}"

  defp list_to_string([hd|tl], string), do: list_to_string(tl, string <> " #{hd};")
end
