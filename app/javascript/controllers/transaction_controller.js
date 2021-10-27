import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['loader', 'rate', 'btcInput', 'usdtInput', 'exchangeRate']
  static values = { rate: Number }

  connect() {
    fetch('http://api.coinlayer.com/api/live?access_key=617388153a22fa0d941bcc44fc711566&target=BTC&symbols=USDT')
      .then(response => response.json())
      .then(data => {
        this.rateValue = data.rates.USDT
        this.loaderTarget.classList.add('hidden')

        this.rateTarget.classList.remove('hidden')
        this.rateTarget.innerText = `1 USDT ~ ${this.rateValue} BTC`
      })
  }

  input() {
    this.btcInputTarget.value = this.usdtInputTarget.value * this.rateValue
    this.exchangeRateTarget.value = this.rateValue
  }
}
