function QuickEscapeBanner ($module) {
  this.$module = $module
}

QuickEscapeBanner.prototype.init = function () {
  var $module = this.$module

  if (!$module) return

  $module
    .querySelector('[data-id="app-quick-escape-banner-link"]')
    .addEventListener('click', this.handleClick.bind(this))

  this.stickyEnhancement($module)
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

QuickEscapeBanner.prototype.stickyEnhancement = function ($module) {
  var isIE = (navigator.userAgent.indexOf('MSIE') !== -1) || (!!document.documentMode === true)

  if (!isIE) return

  var offset = $module.getBoundingClientRect()
  window.addEventListener('scroll', function () {
    if (window.pageYOffset > offset.top) $module.style.position = 'fixed'
    else $module.style.position = 'relative'
  })
}

var $quickEscapeBanner = document.querySelector('[data-module="app-quick-escape-banner"]')
new QuickEscapeBanner($quickEscapeBanner).init()
