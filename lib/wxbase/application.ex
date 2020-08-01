defmodule Wxbase.Application do
  use Application

  def start(_type, _args) do

    {:wx_ref, _, _, pid} = Wxbase.Mainframe.start_link()
    ref = Process.monitor(pid)

    receive do
      {:DOWN, ^ref, _, _, _} ->
        {:ok,self()}
    end

  end
end
