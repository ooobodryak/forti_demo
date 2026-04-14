module Sample
  # Отображаем целевые записи в нужном нам виде.
  class ShowRecords
    AttrMagic.load(self)

    # Записи, которые отображаем.
    # @return [Array<Klass>]
    attr_accessor :records

    # Земпляр {Pagy} для правильного рендера вьюшки.
    # @return [Pagy]
    attr_accessor :pagy

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # В виде хэша.
    # @return [Hash]
    def as_json(options = {})
      {
        entries: records_html,
        pagination: pagy_html,
        entry_count: pagy_count
      }
    end

    #--------------------------------------- Частное
    private

    attr_writer(
      :pagy_count,
      :pagy_html,
      :partial_owner,
      :records_html,
      :records_partial,
    )

    # Кол-во записей внутри {#pagy}.
    # @return [Integer]
    def pagy_count
      igetset(__method__) { pagy.count }
    end

    # Отрендеренная пагинация.
    # @return [String]
    def pagy_html
      igetset(__method__) do
        render_to_string(
          partial: "pagy/nav",
          locals: { pagy: pagy },
          as: partial_owner,
          formats: [:html],
        )
      end
    end

    # Для кого рендерим записи.
    # @abstract
    # @return [Symbol] Например, <tt>:patient</tt>.
    def partial_owner
      raise "#{__method__} нужно переопределить в текущем классе!"
    end

    # Отрендеренная страница для {#records}.
    # @return [String]
    def records_html
      igetset(__method__) do
        render_to_string(
          partial: records_partial,
          collection: records,
          as: partial_owner,
          formats: [:html],
        )
      end
    end

    # Вьюшка для отображаения {#records}.
    # @abstract
    # @return [String] Например, <tt>"patients/row"</tt>.
    def records_partial
      raise "#{__method__} нужно переопределить в текущем классе!"
    end

    # Рендерим вьюшку и получаем её в виде строки.
    # @param [Hash] opts Опции для рендера.
    # @return [String]
    def render_to_string(opts)
      ApplicationController.renderer.render(opts) 
    end

  end # class
end # namespace
