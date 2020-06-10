module CsvStreamBuilderHelper
  class CsvBuilder

    attr_accessor :output, :header, :data

    def initialize(header, data, output = "")
      @output = output
      @header = header
      @data = data
    end

    def build
      output << CSV.generate_line(header)
      data.to_a.each do |row|
        output << CSV.generate_line(row)
      end
      output
    end
  end

  def build_csv_enumerator(header, data)
    Enumerator.new do |y|
      CsvBuilder.new(header, data, y).build
    end
  end

  def set_headers
    headers["X-Accel-Buffering"] = "no"
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] =
        %(attachment; filename="#{csv_filename}")
  end

  private

  def csv_filename
    "tickets-report-#{Time.zone.now.to_date.to_s}.csv"
  end
end
