/* eslint-env jasmine */
/* global QuickEscapeBanner */

describe('Quick escape banner component', function () {
  'use strict'

  var container
  var quickEscapeBannerElement
  var quickEscapeBannerModule

  beforeEach(function () {
    container = document.createElement('div')
    container.innerHTML = '<div class="app-c-quick-escape-banner" data-module="app-quick-escape-banner">' +
                            '<div class="govuk-width-container">' +
                              '<div class="govuk-grid-row">' +
                                '<div class="govuk-grid-column-one-quarter app-c-quick-escape-banner__link">' +
                                  '<a class="gem-c-button govuk-button govuk-button--warning" role="button" rel="nofollow noreferrer noopener" data-id="app-quick-escape-banner-link" target="_blank" href="https://www.gov.uk/">Hide this page</a>' +
                                '</div>' +
                              '</div>' +
                            '</div>' +
                          '</div>'
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
    quickEscapeBannerElement.querySelector('[data-id="app-quick-escape-banner-link"]').click()
    expect(quickEscapeBannerModule.openNewPage).toHaveBeenCalledWith('https://www.gov.uk/', 'nofollow noreferrer noopener')
  })

  it('replaces the original page', function () {
    spyOn(quickEscapeBannerModule, 'replaceCurrentPage')
    quickEscapeBannerElement.querySelector('[data-id="app-quick-escape-banner-link"]').click()
    expect(quickEscapeBannerModule.replaceCurrentPage).toHaveBeenCalledWith('https://www.gov.uk/')
  })
})
