require "pagy"
require "pagy/extras/bootstrap"
require "pagy/extras/overflow"

# Заставляем показывать последнюю страницу, когда выходим за лимит доступных.
Pagy::DEFAULT[:overflow] = :last_page
