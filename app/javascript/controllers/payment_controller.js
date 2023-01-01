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

  async checkout(event) {
    event.preventDefault()

    this.setLoading(true)

    const { error } = await stripe.confirmPayment({
      elements,
      redirect: "if_required",
    })

    if (error) {
      if (error.type === "card_error" || error.type === "validation_error") {
        this.showMessage(error.message)
      } else {
        this.showMessage("An unexpected error occurred.")
      }
    } else {
      this.formTarget.submit()
      this.setLoading(false)
    }
  }

  setLoading(isLoading) {
    this.submitTarget.disabled = isLoading ? true : false
    if (isLoading) {
      this.submitTarget.classList.add("opacity-50")
    } else {
      this.submitTarget.classList.remove("opacity-50")
    }
    this.submitTarget.value = isLoading ? "Processing..." : "Schedule booking"
  }

  showMessage(text) {
    const ONE_SECOND = 1000
    console.log('messageTarget', this.messageTarget)
    this.messageTarget.classList.remove("hidden")
    this.messageTarget.textContent = text

    setTimeout(() => {
      this.messageTarget.classList.add("hidden")
      this.messageTarget.textContent = ""
    }, ONE_SECOND * 4)
  }
}
