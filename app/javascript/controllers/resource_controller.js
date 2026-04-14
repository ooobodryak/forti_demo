import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {}

  static targets = ["pagination", "entries", "search_form", "count"]

  paginate(event) {
    event.preventDefault()

    let url

    if (event.target.tagName === "SELECT") {
      url = new URL(window.location.href)
      url.searchParams.set("per_page", event.target.value)
      url.searchParams.set("page", 1)
    } else {
      const link = event.target.closest("a")
      if (!link) return

      url = new URL(link.href)

      const select = this.element.querySelector('select[name="per_page"]')
      if (select) {
        url.searchParams.set("per_page", select.value)
      }
    }

    fetch(url.toString(), {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => {
      this.entriesTarget.innerHTML = data.entries
      this.paginationTargets.forEach(el => el.innerHTML = data.pagination)
      window.history.pushState({}, "", url.toString())
    })
  }

  search(event) {
    event.preventDefault()

    const form = event.target
    const url = new URL(form.action)
    const formData = new URLSearchParams(new FormData(form))

    url.search = formData.toString()

    const select = this.element.querySelector('select[name="per_page"]')
    if (select) {
      url.searchParams.set("per_page", select.value)
    }

    url.searchParams.set("page", 1)

    fetch(url, {
      headers: { "Accept": "application/json" }
    })
    .then(response => response.json())
    .then(data => {
      this.entriesTarget.innerHTML = data.entries
      this.paginationTargets.forEach(el => el.innerHTML = data.pagination)

      if (this.hasCountTarget) this.countTarget.innerText = data.entry_count

      window.history.pushState({}, "", url.toString())
    })
  }

  async destroy_entry(event) {
    const target = event.target.closest('[data-role="delete-button"]');
    if (!target) return;

    event.preventDefault();

    const url = target.dataset.url;
    const currentUrl = new URL(window.location.href);

    if (!url) {
      return;
    }

    try {
      const response = await fetch(url, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Accept": "application/json"
        }
      });

      const data = await response.json();
      
      if (data.flash) this.showFlash(data.flash);

      if (response.ok) {
        this.refreshTable(currentUrl);
      }
    } catch (error) {
      console.error("Ошибка при удалении:", error);
    }
  }

  async refreshTable(url) {
    const response = await fetch(url, {
      headers: { "Accept": "application/json" }
    })
    const data = await response.json()

    this.entriesTarget.innerHTML = data.entries
    this.paginationTargets.forEach(el => el.innerHTML = data.pagination)
    if (this.hasCountTarget) this.countTarget.innerText = data.entry_count
  }

  showFlash(htmlString) {
    const parser = new DOMParser()
    const doc = parser.parseFromString(htmlString, "text/html")
    const flashElement = doc.body.firstChild

    document.body.appendChild(flashElement)

    const closeBtn = flashElement.querySelector(".btn-close")
    if (closeBtn) {
      closeBtn.onclick = () => flashElement.remove()
    }

    setTimeout(() => {
      if (flashElement.parentElement) {
        flashElement.classList.remove("show")
        setTimeout(() => flashElement.remove(), 150)
      }
    }, 2000)
  }
}
