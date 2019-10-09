defmodule ExHttpMock.Parse do
  @moduledoc false

  def mock_file_path do
    files_path = Application.get_env(:ex_http_mock, :mock_path)

    with {:ok, list} <- File.ls(files_path) do
      Enum.reduce(list, %{}, fn path, acc ->
        full_path = files_path <> "/" <> path

        case read_file(full_path) do
          {:ok, data} -> Map.put(acc, data["request"]["path"], full_path)
          _ -> acc
        end
      end)
    end
  end

  def read_file(path) do
    with true <- valid_file(path) do
      path
      |> EEx.eval_file()
      |> YamlElixir.read_from_string()
    end
  end


  # ---------------------------------------------
  #                    PRIVATE
  # ---------------------------------------------
  defp valid_file(path) do
    path = Path.join(File.cwd!(), path)
    Regex.match?(~r/(yml|yaml)$/, path)
  end
end
