import { Controller } from "@hotwired/stimulus"

let elements
const csrfToken = document.getElementsByName("csrf-token")[0].content
const stripe = Stripe(
  document.getElementsByName("stripe-public-key")[0].content
)

export default class extends Controller {
  static values = {
    item: String,
    returnURl: String,
  }

  static targets = ["element", "submit", "form", "name", "email"]

  async initialize() {
    console.log("stripe key", stripe)
    const response = await fetch("/payment-intent", {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify(this.itemValue),
    })

    const { clientSecret } = await response.json()
    const appearance = {
      theme: "stripe",
    }
    elements = stripe.elements({ appearance, clientSecret })

    const paymentElement = elements.create("payment")
    paymentElement.mount(this.elementTarget)
  }
}
