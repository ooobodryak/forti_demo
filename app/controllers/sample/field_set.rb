
require_relative "_namespace"

module Sample
  # Набор очищенных полей из +params+.
  class FieldSet
    AttrMagic.load(self)
    Feature::Toor.load(self)

    # Параметры пришедшего запроса.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_accessor :params

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # Номер страницы для пагинации.
    # @return [Integer] По умолчанию +1+.
    def page
      igetset(__method__) do
        out = to_int_or(prms[:page]) { 1 }
        out < 0 ? 1 : out
      end
    end

    # Количество элементов на странице.
    # @return [Integer] От +5+ до +50+.
    def per_page
      igetset(__method__) do
        out = to_int_or(prms[:per_page]) { 5 }
        out.clamp(5, 50)
      end
    end

    # Параметры поиска для {Ransack}.
    # @return [Hash] Всегда, как минимум, +{}+.
    def ransack_params
      igetset(__method__) { prms[:q] || {} }
    end

    #--------------------------------------- Частное
    private

    attr_writer(
      :page,
      :per_page,
      :prms,
      :ransack_params
    )

    # Гарантированные {#params}.
    # @return [Hash] Всегда, как минимум, +{}+.
    def prms
      igetset(__method__) { params.permit(:page, :per_page, q: {}).to_h }
    end

  end # class
end # namespace
