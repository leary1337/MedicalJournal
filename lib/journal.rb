# frozen_string_literal: true

require 'csv'
require_relative 'medical'

# Journal class
class Journal
  attr_reader :journal

  def initialize
    @journal = []
  end

  def add(other)
    @journal.append(other)
  end

  def read_in_csv_data(file_name)
    CSV.foreach(file_name, headers: true, col_sep: ';') do |row|
      medical = Medical.new(row[0], row[1], row[2], row[3], row[4])
      add(medical)
    end
  end

  def count_medical
    @journal.size
  end

  def count_medical_by_code
    medical_code_hash = Hash.new(0)
    @journal.each do |med|
      medical_code_hash[med.code] += 1
    end
    medical_code_hash
  end

  def count_medical_close_by_year
    close_medical_hash = Hash.new(0)
    @journal.each do |med|
      period = med.period_date.split(' - ')
      close_year = period[1].split('-')[0]
      close_medical_hash[close_year] += 1
    end
    close_medical_hash
  end

  def save_in_csv(file_name)
    CSV.open(file_name, 'w', col_sep: ';') do |csv|
      csv << ['Номер больничного', 'ФИО нетрудоспособного',
              'Период нетрудоспособности', 'Код причины нетрудоспособности',
              'Фамилия врача']

      @journal.each do |med|
        csv << [med.number, med.fio, med.period_date, med.code, med.doc_last_name]
      end
    end
  end

  def subjournal_by_doctor(doctor)
    subjournal = Journal.new
    medicals_by_doc = close_medicals_by_doctor(doctor)
    medicals_by_doc_sorted = sort_medicals_by_code(medicals_by_doc)
    medicals_by_doc_sorted.each do |med|
      subjournal.add(med)
    end
    subjournal
  end

  def list_doctors
    @journal.map(&:doc_last_name).uniq
  end

  def close_medicals_by_doctor(doctor_name)
    @journal.select { |med| med.doc_last_name == doctor_name }
  end

  def sort_medicals_by_code(medicals)
    medicals.sort_by(&:code)
  end
end
