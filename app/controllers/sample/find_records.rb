module Sample
  # Находим целевые записи.
  class FindRecords
    AttrMagic.load(self)
    include Pagy::Backend

    # Множество очищенных полей из параметров.
    # @return [FieldSet]
    attr_accessor :field_set

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # Земпляр пагинации, нужен для правильного рендера вьюшки.
    # @return [Pagy]
    def pagy_obj
      igetset(__method__) { pagy_arr.first }
    end

    # Земпляр поисковика {Ransack::Search}.
    # @return [Ransack::Search]
    def ransack
      igetset(__method__) { base_scope.ransack(field_set.ransack_params) }
    end

    # Результат выборки.
    # @return [Array<Patient>]
    def result
      igetset(__method__) { pagy_arr.second }
    end

    #--------------------------------------- Частное
    private

    attr_writer(
      :base_scope,
      :full_scope,
      :pagy_arr,
      :pagy,
      :ransack,
      :result
    )

    # Базовый scope.
    # @abstract
    # @return [Klass::ActiveRecord_Relation]
    def base_scope
      raise "#{__method__} нужно переопределить в текущем классе!"
    end

    # Полный scope без пагинации.
    # @return [Klass::ActiveRecord_Relation]
    def full_scope
      igetset(__method__) { ransack.result(distinct: true) }
    end

    # Массив с элементами пагинации.
    # @return [Array<Pagy, Klass::ActiveRecord_Relation]
    def pagy_arr
      igetset(__method__) { pagy(full_scope, limit: field_set.per_page, page: field_set.page) }
    end

  end # class
end # namespace
