
require_relative "_namespace"

class PatientsController
  class ShowPatients < Sample::ShowRecords

    #--------------------------------------- Частное
    private

    # Для кого рендерим записи.
    # @return [Symbol] Например, <tt>:patient</tt>.
    def partial_owner
      igetset(__method__) { :patient  }
    end

    # Вьюшка для отображаения {#records}.
    # @return [String]
    def records_partial
      igetset(__method__) { "patients/row" }
    end

  end # class
end # namespace
