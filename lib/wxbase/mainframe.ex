defmodule Wxbase.Mainframe do
  @behaviour :wx_object

  @title "WXBASE"
  @size {600, 600}

  def start_link() do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    wx = :wx.new
    frame = :wxFrame.new(wx, -1, @title, size: @size)
    :wxFrame.connect(frame, :size)
    :wxFrame.connect(frame, :close_window)

    panel = :wxPanel.new(frame, [])
    :wxPanel.connect(panel, :paint, [:callback])

    btn1 = :wxButton.new(panel,-1,[{:label,"Hello"},{:pos,{100,100}},{:size,{100,100}}])
    :wxButton.connect(btn1,:command_button_clicked,[:callback])


    :wxFrame.show(frame)
    state = %{panel: panel}
    {frame, state}
  end

  def handle_event({:wx, _, _, _, {:wxSize, :size, size, _}}, state = %{panel: panel}) do
    :wxPanel.setSize(panel, size)
    {:noreply, state}
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_sync_event({:wx, _, _, _, {:wxPaint, :paint}}, _, _state = %{panel: panel}) do
    brush = :wxBrush.new
    :wxBrush.setColour(brush, {255, 0, 0, 255})

    dc = :wxPaintDC.new(panel)
    :wxDC.setBackground(dc, brush)
    :wxDC.clear(dc)
    :wxPaintDC.destroy(dc)
    :ok
  end

  def handle_sync_event({:wx,_id,obj,_usrdata,{:wxCommand,:command_button_clicked,[],0,0}},evtref,_state) do
    :io.format("A:~p~nB:~p~n",[obj,evtref])
    :ok
  end
end





# handle_sync_event(event_record,event_ref,stat)
# 09:40:57.658 [error] :wxe_server:288: Callback fun crashed with
# {'EXIT, :function_clause,
#   [
#      {Canvas, :handle_sync_event,
#          [{:wx, -31992,
#               {:wx_ref, 40, :wxButton, []},
#               [],
#               {:wxCommand, :command_button_clicked, [], 0, 0}
#           },
#           {:wx_ref, 49, :wxCommandEvent, []},
#           %{panel: {:wx_ref, 38, :wxPanel, []}}
#          ],
#          [file: 'exwx.exs', line: 39]
#      },
#      {:wxe_server, :"-invoke_callback/3-fun-0-", 4,
#          [file: 'wxe_server.erl', line: 280]
#      }
#   ]
# }
