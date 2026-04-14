# Scene 1:
#   Создаём 1000 пациентов, для которых раз-через-раз:
#   * либо создаём рецепт/-ы,
#   * либо НЕ создаём рецепт/-ы.
#
#   В каждом рецепте:
#   * может быть от 1 до 15 лекраственных средств,
#   * случайная длительноть разрешения на использование.
#   * уникальный {Recipe#code} из {Patient#id} + {Recipe#id}.
#

if ENV['RESET_DATA'] == '1'
  puts "Зачищаем старые данные..."
  Recipe.destroy_all
  Patient.destroy_all
end

puts "Начинаем импорт данных..."

available_drugs = [
  "Морфин", "Анальгин", "Аспирин", "Парацетамол", "Ибупрофен",
  "Диклофенак", "Омепразол", "Амоксициллин", "Лоратадин", "Дексаметазон",
  "Фуросемид", "Каптоприл", "Метформин", "Аторвастатин", "Азитромицин",
  "Левофлоксацин", "Цефтриаксон", "Диазепам", "Феназепам", "Нитроглицерин"
]

patients_attrs = 1000.times.map do
  {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    age: rand(18..90),
    created_at: Time.current,
    updated_at: Time.current
  }
end

patient_ids = Patient.insert_all(patients_attrs, returning: %w[id]).map { |r| r["id"] }

patient_ids.each_with_index do |p_id, index|
  next unless [true, false].sample

  rand(1..3).times do
    start_date = Date.today + rand(-10..10).days

    Recipe.create!(
      patient_id: p_id,
      start_at:   start_date,
      end_at:     start_date + rand(7..90).days,
      drug_list:  available_drugs.sample(rand(1..15))
    )
  end
end

puts "Импорт данных завершён"
