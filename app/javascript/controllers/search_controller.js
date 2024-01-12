import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.setAttribute("data-action", "keyup->search#search")
    console.log("Search Controller connected!")
  }

  search(){
    let params = new URLSearchParams()
    params.append("query", this.element.value)
    fetch(`/search?${params}`, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    }).then(r => r.text()).then(html => Turbo.renderStreamMessage(html))
  }
}
