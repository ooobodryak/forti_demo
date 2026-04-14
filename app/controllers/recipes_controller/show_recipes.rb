
require_relative "_namespace"

class RecipesController
  class ShowRecipes < Sample::ShowRecords

    #--------------------------------------- Частное
    private

    # Для кого рендерим записи.
    # @return [Symbol] Например, <tt>:patient</tt>.
    def partial_owner
      igetset(__method__) { :recipe  }
    end

    # Вьюшка для отображаения {#records}.
    # @return [String]
    def records_partial
      igetset(__method__) { "recipes/row" }
    end

  end # class
end # namespace
