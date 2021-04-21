/* eslint-env jasmine */
/* global QuickEscapeBanner */

describe('Quick escape banner component', function () {
  'use strict'

  var container
  var quickEscapeBannerElement
  var quickEscapeBannerModule

  beforeEach(function () {
    container = document.createElement('div')
    container.innerHTML = '<a class="app-c-quick-escape-banner govuk-link" rel="nofollow noreferrer noopener" target="_blank" data-module="app-quick-escape-banner" data-track-label="need-help-with" href="https://www.gov.uk/">Leave this site</a>'
    document.body.appendChild(container)
    quickEscapeBannerElement = document.querySelector('[data-module="app-quick-escape-banner"]')
    quickEscapeBannerModule = new QuickEscapeBanner(quickEscapeBannerElement)
    quickEscapeBannerModule.replaceCurrentPage = function () {}
    quickEscapeBannerModule.init()
  })

  afterEach(function () {
    document.body.removeChild(container)
  })

  it('opens a new page', function () {
    spyOn(quickEscapeBannerModule, 'openNewPage')
    quickEscapeBannerElement.click()
    expect(quickEscapeBannerModule.openNewPage).toHaveBeenCalledWith('https://www.gov.uk/', 'nofollow noreferrer noopener')
  })

  it('replaces the original page', function () {
    spyOn(quickEscapeBannerModule, 'replaceCurrentPage')
    quickEscapeBannerElement.click()
    expect(quickEscapeBannerModule.replaceCurrentPage).toHaveBeenCalledWith('https://www.gov.uk/')
  })
})
