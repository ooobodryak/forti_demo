class PatientsController < ApplicationController
  AttrMagic.load(self)

  def index
    # Получаем множество очищенных полей.
    field_set = FieldSet.new(params: params)

    # Находим пациентов.
    fp = FindPatients.new(field_set: field_set)
    patients, pagy_obj = fp.result, fp.pagy_obj

    # Получаем данные для отображения в виде JSON.
    data_json = ShowPatients.new({
      pagy: pagy_obj,
      records: patients,
    })

    respond_to do |format|
      format.html { render :index, locals: { q: fp.ransack, pagy: pagy_obj, patients: patients }}
      format.json { render json: data_json }
    end
  end

  def show
    @patient = patient
  end

  def new
    @patient = Patient.new
  end

  def edit
    @patient = patient
  end

  def create
    if (@patient = Patient.new(patient_params)).save
      redirect_to patient, notice: "Пациент успешно создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if (@patient = patient).update(patient_params)
      redirect_to @patient, notice: "Успешно обновлено"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if patient.destroy
      render json: {
        flash: render_to_string(
          partial: "shared/flash_message",
          formats: [:html],
          locals: { msg: "Пациент удалён", type: "success" }
        )
      }, status: :ok
    else
      render json: {
        flash: render_to_string(
          partial: "shared/flash_message",
          formats: [:html],
          locals: { msg: patient.errors.full_messages.join(", "), type: "danger" }
        )
      }, status: :unprocessable_entity
    end
  end

  private

  # Пациент.
  # @return [Patient]
  def patient
    igetset(__method__) { Patient.find(params[:id]) }
  end

  # Разрешённые параметры Пациента.
  # @return [ActionController::Parameters]
  def patient_params
    params.require(:patient).permit(
      :age,
      :first_name,
      :last_name,
    )
  end
end
