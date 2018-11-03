defmodule ZaZaarWeb.LiveStreamView do
  use ZaZaarWeb, :view

  def cal_time_diff(dt0, dt1) do
    seconds_diff =
      NaiveDateTime.diff(dt0, dt1)
      |> abs

    seconds = rem(seconds_diff, 60)
    minutes = div(seconds_diff, 60)
    hours = div(seconds_diff, 3600)

    [hours, minutes, seconds]
    |> Enum.join(":")
  end
end
