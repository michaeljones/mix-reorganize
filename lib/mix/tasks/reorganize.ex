defmodule Mix.Tasks.Reorganize do
  use Mix.Task

  @shortdoc "Reorganizes files into domain based folders"
  @spec run(any) :: no_return
  def run(_) do
    config = Mix.Project.config()
    app = Keyword.get(config, :app)
    app_string = Atom.to_string(app)

    web_base = "lib/#{app_string}_web/"

    # Controllers
    controller_dir = Path.join(web_base, "controllers")

    File.ls!(controller_dir)
    |> Enum.filter(&String.ends_with?(&1, "_controller.ex"))
    |> Enum.map(&to_triplet(&1, web_base, controller_dir, "controller.ex"))
    |> Enum.each(&process/1)

    # Views
    view_dir = Path.join(web_base, "views")

    File.ls!(view_dir)
    |> Enum.filter(&String.ends_with?(&1, "_view.ex"))
    |> Enum.map(&to_triplet(&1, web_base, view_dir, "view.ex"))
    |> Enum.each(&process/1)

    # Tests
    test_dir = Path.join("test", app_string)

    File.ls!(test_dir)
    |> Enum.map(&move_triplet(&1, test_dir, "lib/#{app_string}/"))
    |> Enum.each(&process/1)

    # Controller Tests
    controller_test_dir = "test/#{app_string}_web/controllers"

    File.ls!(controller_test_dir)
    |> Enum.filter(&String.ends_with?(&1, "_controller_test.exs"))
    |> Enum.map(&to_triplet(&1, web_base, controller_test_dir, "controller_test.exs"))
    |> Enum.each(&process/1)
  end

  @type triplet :: {String.t(), String.t(), String.t()}

  @spec to_triplet(String.t(), String.t(), String.t(), String.t()) :: triplet
  defp to_triplet(file, base, directory, suffix) do
    name = String.replace_suffix(file, "_#{suffix}", "")
    {Path.join(directory, file), Path.join([base, name, suffix]), Path.join(base, name)}
  end

  @spec move_triplet(String.t(), String.t(), String.t()) :: triplet
  defp move_triplet(file, from_dir, to_dir) do
    {Path.join(from_dir, file), Path.join(to_dir, file), to_dir}
  end

  @spec process({String.t(), String.t(), String.t()}) :: no_return
  defp process({from, to, directory}) do
    IO.puts("mkdir #{directory}")
    File.mkdir_p!(directory)
    IO.puts("rename #{from} #{to}")
    File.rename(from, to)
  end
end
