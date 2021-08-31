# frozen_string_literal: true

# Medical class
class Medical
  attr_reader :number, :period_date, :code, :doc_last_name, :fio

  def initialize(number, fio, period_date, code, doc_last_name)
    @number = number
    @fio = fio
    @period_date = period_date
    @code = code
    @doc_last_name = doc_last_name
  end

  def to_s
    "#{@number},#{@fio},#{@period_date},#{@code},#{@doc_last_name}"
  end
end
