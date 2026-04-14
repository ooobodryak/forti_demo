export const handleSearchSubmit = async (event, controller) => {
  event.preventDefault()

  const form = event.currentTarget
  const url = `${form.action}?${new URLSearchParams(new FormData(form))}`

  const response = await fetch(url, { headers: { "Accept": "application/json" } })

  if (response.ok) {
    const data = await response.json()

    if (data.entries) controller.entriesTarget.innerHTML = data.entries

    if (controller.hasCountTarget && data.entries_count !== undefined) {
      controller.countTarget.textContent = data.entries_count
    }

    if (data.pagination) {
      controller.navTargets.forEach(nav => nav.innerHTML = data.pagination)
      const { setPagyHandler } = await import("./pagy")
      setPagyHandler(controller)
    }

    window.history.pushState({}, "", url)
  }
}