class RecipesController < ApplicationController
  AttrMagic.load(self)

  def index
    # Получаем множество очищенных полей.
    field_set = FieldSet.new(params: params)

    # Находим рецепты.
    fp = FindRecipes.new(field_set: field_set)
    recipes, pagy_obj = fp.result, fp.pagy_obj

    # Получаем данные для отображения в виде JSON.
    data_json = ShowRecipes.new({
      pagy: pagy_obj,
      records: recipes,
    })

    respond_to do |format|
      format.html { render :index, locals: { q: fp.ransack, pagy: pagy_obj, recipes: recipes }}
      format.json { render json: data_json }
    end
  end

  def show
    @recipe = recipe
  end

  def new
    @recipe = Recipe.new
  end

  def edit
    @recipe = recipe
  end

  def create
    if (@recipe = Recipe.new(recipe_params)).save
      redirect_to @recipe, notice: "Рецепт успешно создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if (@recipe = recipe).update(recipe_params)
      redirect_to @recipe, notice: "Успешно обновлено"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if recipe.destroy
      render json: {
        flash: render_to_string(
          partial: "shared/flash_message",
          formats: [:html],
          locals: { msg: "Рецепт удалён", type: "success" }
        )
      }, status: :ok
    else
      render json: {
        flash: render_to_string(
          partial: "shared/flash_message",
          formats: [:html],
          locals: { msg: recipe.errors.full_messages.join(", "), type: "danger" }
        )
      }, status: :unprocessable_entity
    end
  end

  private

  # Рецепт.
  # @return [Recipe]
  def recipe
    igetset(__method__) { Recipe.find(params[:id]) }
  end

  # Разрешённые параметры для Рецепта.
  # @return [ActionController::Parameters]
  def recipe_params
    out = params.require(:recipe).permit(
      :difficulty_type,
      :drug_list,
      :end_at,
      :patient_id,
      :start_at,
    )

    out[:drug_list] = out[:drug_list].split(',').map(&:strip).reject(&:blank?)
    out
  end
end
