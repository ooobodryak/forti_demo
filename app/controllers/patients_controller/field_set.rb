
require_relative "_namespace"

class PatientsController
  class FieldSet < Sample::FieldSet
    def ransack_params
      igetset(__method__) { validated_ransack_params }
    end

    #--------------------------------------- Частное
    private

    attr_writer :validated_ransack_params

    # Провалидированные фильтры для Ransack.
    # @return [Hash]
    def validated_ransack_params
      igetset(__method__) do
        next({}) unless out = prms[:q].presence

        # TODO: Расширить {Feature::Toor} переводилками + сделать приведение типов
        #       на уровне контроллеров.
        #
        # Не учитываем кол-во Рецептов для Пациента, когда ищем без них.
        if out[:recipes_id_null] == "true" && out.key?(:with_recipes_count)
          out = out.except(:with_recipes_count)
        end

        out
      end
    end

  end # class
end # namespace
