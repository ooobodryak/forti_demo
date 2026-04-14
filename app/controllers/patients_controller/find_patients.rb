
require_relative "_namespace"

class PatientsController
  class FindPatients < Sample::FindRecords

    #--------------------------------------- Частное
    private

    def base_scope
      igetset(__method__) { Patient.includes(:recipes) }
    end

  end # class
end # namespace
