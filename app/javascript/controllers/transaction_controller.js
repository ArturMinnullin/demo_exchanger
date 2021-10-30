import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['loader', 'rate', 'btcInput', 'usdtInput', 'exchangeRate', 'checkbox', 'submit']
  static values = { rate: Number }

  connect() {
    fetch('https://api.exchangerate.host/latest\?base\=USD\&symbols\=BTC')
      .then(response => response.json())
      .then(data => {
        this.rateValue = data.rates.BTC
        this.loaderTarget.classList.add('hidden')

        this.rateTarget.classList.remove('hidden')
        this.rateTarget.innerText = `1 USDT ~ ${this.rateValue} BTC`

        if (this.usdtInputTarget.value) {
          this.btcInputTarget.value = this.usdtInputTarget.value * this.rateValue
        }
      })
  }

  input() {
    this.btcInputTarget.value = this.usdtInputTarget.value * this.rateValue
    this.exchangeRateTarget.value = this.rateValue
  }

  check(e) {
    if (e.target.checked) {
      this.submitTarget.classList.remove('button--disabled')
      this.submitTarget.disabled = false
    } else {
      this.submitTarget.classList.add('button--disabled')
      this.submitTarget.disabled = true
    }
  }
}
