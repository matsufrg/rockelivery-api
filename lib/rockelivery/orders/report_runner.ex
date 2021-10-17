defmodule Rockelivery.Orders.ReportRunner do
  use GenServer

  require Logger

  alias Rockelivery.Orders.Report

  # CLIENT

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def schedule_generate_report do
    Process.send_after(self(), :generate, 1000 * 10)
  end

  # SERVER
  def init(state) do
    Logger.info("Report Runner Started")

    schedule_generate_report()

    {:ok, state}
  end

  def handle_info(:generate, state) do
    Logger.info("Generating Report!")

    Report.create()

    schedule_generate_report()

    {:noreply, state}
  end
end
