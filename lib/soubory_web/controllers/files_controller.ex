defmodule SouboryWeb.FilesController do
  use SouboryWeb, :controller
  alias Soubory.FileHelper

  def index(conn, params) do
    path =
      if(params["path"] != nil) do
        params["path"]
      else
        "C:/"
      end

    file_infos = FileHelper.get_infos(path)

    order_method =
      if conn.params["orderby"] != nil do
        String.to_atom(conn.params["orderby"])
      else
        :type_dec
      end

    render(conn, "index.html",
      files: FileHelper.order_infos(file_infos, order_method),
      path: path,
      parent: FileHelper.get_parent(path)
    )
  end
end
