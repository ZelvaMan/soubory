defmodule SouboryWeb.FileController do
  use SouboryWeb, :controller

  def show(conn, params) do
    path = params["path"]

    render(conn, "file_detail.html",
      info: Soubory.FileHelper.get_file_info(path),
      parent: Soubory.FileHelper.get_parent(path)
    )
  end
end
