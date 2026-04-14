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

  # @!method recipes_count_eq
  #   +Scope+: Пациенты, у которых +value+ связанных {Recipe}.
  #   @return [Array<Patient>]
  scope :recipes_count_eq, ->(value) {
    joins(:recipes).group(:id).having("count(recipes.id) = ?", value)
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
    ["recipes_count_eq"]
  end

end
