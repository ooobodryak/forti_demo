
require_relative "_namespace"

class RecipesController
  class FindRecipes < Sample::FindRecords

    #--------------------------------------- Частное
    private

    def base_scope
      igetset(__method__) { Recipe.order(created_at: :desc) }
    end

  end # class
end # namespace
