function QuickEscapeBanner ($module) {
  this.$module = $module
}

QuickEscapeBanner.prototype.init = function () {
  var $module = this.$module

  if (!$module) {
    return
  }
  $module.addEventListener('click', this.handleClick.bind(this))
}

QuickEscapeBanner.prototype.handleClick = function (event) {
  event.preventDefault()

  var url = event.target.getAttribute('href')
  var rel = event.target.getAttribute('rel')

  this.openNewPage(url, rel)
  this.replaceCurrentPage(url)
}

QuickEscapeBanner.prototype.openNewPage = function (url, rel) {
  var newWindow = window.open(url, rel)
  newWindow.opener = null
}

QuickEscapeBanner.prototype.replaceCurrentPage = function (url) {
  window.location.replace(url)
}

var $quickEscapeBanner = document.querySelector('[data-module="app-quick-escape-banner"]')
new QuickEscapeBanner($quickEscapeBanner).init()
