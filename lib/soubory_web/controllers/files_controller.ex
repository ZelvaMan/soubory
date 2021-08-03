defmodule SouboryWeb.FilesController do
  use SouboryWeb, :controller
  alias Soubory.FileHelper

  def index(conn, params) do
    path = FileHelper.make_path_valid(params["path"] || FileHelper.allowed_path())

    file_infos = FileHelper.get_infos(path)

    order_method =
      case conn.params["orderby"] do
        nil -> String.to_existing_atom(conn.params["orderby"])
        _ -> :type_dec
      end

    render(conn, "index.html",
      files: FileHelper.order_infos(file_infos, order_method),
      path: path,
      parent: FileHelper.get_parent(path)
    )
  end

  def search(conn, params) do
    path = FileHelper.make_path_valid(params["path"] || FileHelper.allowed_path())
    s_q = params["search_query"]
    files = FileHelper.search_files(path, s_q)

    render(conn, "index.html",
      files:
        if length(files) < 1 do
          []
        else
          files
        end,
      path: path,
      parent: path
    )
  end
end
