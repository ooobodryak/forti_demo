export const setPagyHandler = (controller) => {
  controller.navTargets.forEach(nav => {
    if (nav.dataset.pagyBound) return

    nav.addEventListener("click", (event) => {
      handlePagination(event, controller)
    })
  })
}

const handlePagination = async (event, controller) => {
  const link = event.target.closest("a")
  if (!link) return

  event.preventDefault()
  const url = link.href

  const response = await fetch(url, {
    headers: { "Accept": "application/json" }
  })

  if (response.ok) {
    const data = await response.json()
    refreshInterface(data, url, controller)
  }
}

const refreshInterface = (data, url, controller) => {
  if (data.entries) {
    controller.entriesTarget.innerHTML = data.entries
  }

  if (data.pagination) {
    controller.navTargets.forEach(nav => {
      nav.innerHTML = data.pagination
    })
  }

  window.history.pushState({}, "", url)
}