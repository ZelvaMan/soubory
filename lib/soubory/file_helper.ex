defmodule Soubory.FileHelper do
  alias Soubory.Models.SimpleFile
  alias Soubory.Models.FileInfo

  def get_infos(path) do
    Enum.map(File.ls!(path), fn x ->
      info_tuple = File.stat(path <> x)
      file = %SimpleFile{name: x}

      file =
        if elem(info_tuple, 0) === :ok do
          # we were able to get file info
          info = elem(info_tuple, 1)

          %{
            file
            | size:
                if info.type == :regular do
                  info.size
                end,
              extension: Path.extname(path <> x),
              type: info.type,
              fullpath:
                if info.type == :directory do
                  path <> x <> "/"
                else
                  path <> x
                end
          }
        else
          file
        end

      file
    end)
  end

  # return parent directory of path
  def get_parent(path) do
    s = String.replace(path, Path.basename(path) <> "/", "")
    String.replace(s, Path.basename(path), "")
  end

  def get_file_info(path) do
    info_tuple = File.stat(path)

    if elem(info_tuple, 0) === :ok do
      info = elem(info_tuple, 1)

      %FileInfo{
        name: Path.basename(path),
        size: info.size,
        extension: Path.extname(path),
        fullpath: path,
        access: info.access
      }
    else
    end
  end

  # orders SimpleFiles
  def order_infos(files, order) do
    case order do
      :type_dec ->
        # default sort
        Enum.sort(files, fn x, _y ->
          if x.type === :directory do
            true
          else
            false
          end
        end)

      :type_inc ->
        Enum.sort(files, fn x, _y ->
          if x.type === :directory do
            false
          else
            true
          end
        end)

      # by alphabet
      :name_dec ->
        Enum.sort(files, fn x, y ->
          if String.downcase(x.name) > String.downcase(y.name) do
            false
          else
            true
          end
        end)

      :name_inc ->
        Enum.sort(files, fn x, y ->
          if String.downcase(x.name) < String.downcase(y.name) do
            false
          else
            true
          end
        end)

      :size_dec ->
        Enum.sort(files, fn x, y ->
          if x.size < y.size do
            false
          else
            true
          end
        end)

      :size_inc ->
        Enum.sort(files, fn x, y ->
          if x.size > y.size do
            false
          else
            true
          end
        end)

      _ ->
        files
    end
  end
end
