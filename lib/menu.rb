# frozen_string_literal: true

require 'tty-prompt'
require 'csv'
require_relative 'journal'

# Menu class
class Menu
  POLYCLINIC_FILE = File.expand_path('../data/polyclinic_log.csv', __dir__)

  def initialize
    @prompt = TTY::Prompt.new
    @journal_list = Journal.new
    @journal_list.read_in_csv_data(POLYCLINIC_FILE)
  end

  def show_menu
    loop do
      action = @prompt.select('Выберите действие') do |menu|
        menu.choice name: 'Составить статистику', value: :send_statistic
        menu.choice name: 'Разделить список по врачам', value: :split_list_by_doc
        menu.choice name: 'Завершить работу', value: :exit
      end

      break if action == :exit

      send_statistic if action == :send_statistic
      make_list_by_doctor if action == :split_list_by_doc
    end
  end

  def send_statistic
    nums_medical = @journal_list.count_medical
    medical_code_hash = @journal_list.count_medical_by_code
    count_close_medical_hash = @journal_list.count_medical_close_by_year

    puts "Общее количество больничных: #{nums_medical}"

    medical_code_hash.each_pair do |code, count|
      puts "Код: #{code} - #{count} больничных"
    end

    count_close_medical_hash.each_pair do |year, count|
      puts "Год: #{year} - закрыто #{count} больничных"
    end
  end

  def make_list_by_doctor
    # create directory doctor
    dir_name = File.expand_path('../doctors', __dir__)
    make_dir(dir_name)

    doctors_name = @journal_list.list_doctors
    doctors_name.each do |doc|
      subj = @journal_list.subjournal_by_doctor(doc)
      file_name = dir_name + "/#{doc}.csv"
      subj.save_in_csv(file_name)
    end
    puts "Было создано файлов: #{doctors_name.size}"
  end

  def make_dir(dir_name)
    Dir.mkdir(dir_name) unless File.exist?(dir_name)
  end
end
