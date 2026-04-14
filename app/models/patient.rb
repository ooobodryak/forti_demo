# Пациент.
class Patient < ApplicationRecord
  # @!attribute last_name
  #   Фамилия.
  #   @return [String]

  # @!attribute first_name
  #   Имя.
  #   @return [String]

  # @!attribute age
  #   Возраст.
  #   @return [Integer]

  ### Связи.

  # @!attribute recipes
  #   Связь один-ко-многим {Recipe}.
  #   @return [Array<Recipe>] +[]+, если нет связанных.
  has_many :recipes, dependent: :nullify

  ### Скоупы.

  # @!method with_recipes_count
  #   +Scope+: Пациенты, у которых +value+ связанных {Recipe}.
  #   @param [Integer] value
  #   @return [Array<Patient>]
  scope :with_recipes_count, ->(value) {
    # NOTE: При сложных выборках могут возникать конфликты
    #       по типу `PG::GroupingError`.
    subquery = Patient.joins(:recipes)
                    .group("patients.id")
                    .having("count(recipes.id) = ?", value)
                    .select("patients.id")
    where(id: subquery)
  }

  ### Валидации.

  validates :first_name, presence: true, format: {
    with: /\A\p{L}+\z/,
    message: "должно содержать только буквы"
  }

  validates :last_name, presence: true, format: {
    with: /\A\p{L}+\z/,
    message: "должно содержать только буквы"
  }

  validates :age, numericality: { greater_than: 0 }

  ### Методы.

  # Полное имя с айдишником.
  # @return [String]
  def name_with_id
    "#{first_name}_#{last_name}_#{id}"
  end

  # Разрешённые атрибуты для поиска.
  # @return [Array<String>]
  def self.ransackable_attributes(auth_object = nil)
    %w[
        first_name
        last_name
        age
      ]
  end

  # Разрешённые связи для поиска.
  # @return [Array<String>]
  def self.ransackable_associations(auth_object = nil)
    ["recipes"]
  end

  # Разрешённые скоупы для поиска.
  # @return [Array<String>]
  def self.ransackable_scopes(auth_object = nil)
    [:with_recipes_count]
  end

  # АХТУНГ!
  # Ransack вредный -- принимает 1/"1", 0/"0", false/"false", true/"true"
  # как что-то родственное по умолчанию, из-за чего невозможно адекватное поведение
  # в кастомных скоупах.
  # Пропускаем.
  def self.ransackable_scopes_skip_sanitize_args
    [:with_recipes_count]
  end

end
