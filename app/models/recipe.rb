# Рецепт.
class Recipe < ApplicationRecord
  ### Поля.

  # @!attribute difficulty_type
  #   Тип сложности.
  #   @return [String] Может быть одним из <tt>["simple", "hard"]</tt>.

  # @!attribute start_at
  #   Время действия ОТ.
  #   @return [Date]

  # @!attribute end_at
  #   Время действия ДО.
  #   @return [Date]

  # @!attribute drug_list
  #   Список лекарств.
  #   @return [Array<String>] Например, <tt>["феназепам", "морфин"].

  ### Колбэки.

  before_validation :set_difficulty_type

  ### Связи.

  # @!attribute patient
  #   Связанный {Patient}.
  #   @return [Patient]
  belongs_to :patient

  ### Скоупы.

  # @!method with_drugs
  #   +Scope+: Рецепты, список лекраств которых содержит значения из +arr+.
  #   @param [Array<String>] arr
  #   @return [Array<Recipe>]
  scope :with_drugs, ->(arr) {
    where("drug_list @> ARRAY[?]::varchar[]", arr)
  }

  ### Валидации.

  validates :difficulty_type, inclusion: { in: %w[simple hard] }
  validates :end_at, presence: true
  validates :start_at, comparison: { less_than: :end_at }
  validate :drug_list_cannot_be_empty

  #--------------------------------------- Частное
  private

  # {#drug_list} не может быть пустым или содержать
  # хотя бы одну пустую строку.
  def drug_list_cannot_be_empty
    if drug_list.blank? || drug_list.any?(&:blank?)
      errors.add(:drug_list, "не может быть пустым")
    end
  end

  # Устанавливаем значение {#difficulty_type}
  # на основе количества лекарств из {#drug_list}
  def set_difficulty_type
    self.difficulty_type = if drug_list.size > 1
      "hard"
    else
      "simple"
    end

    nil
  end

  # Разрешённые атрибуты для поиска.
  # @return [Array<String>]
  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      difficulty_type
      drug_list
      end_at
      id
      patient_id
      start_at
      updated_at
    ]
  end

  # Разрешённые связи для поиска.
  # @return [Array<String>]
  def self.ransackable_associations(auth_object = nil)
    ["patient"]
  end

  # Разрешённые скоупы для поиска.
  # @return [Array<String>]
  def self.ransackable_scopes(auth_object = nil)
    ["with_drugs"]
  end  

end
