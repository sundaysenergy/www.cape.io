React = require 'react'
{RouteHandler} = require 'react-router'
_ = require 'lodash'

Header = require './header'
Main = require './main'
Footer = require './footer'

module.exports = React.createClass
  contextTypes: {
    router: React.PropTypes.func.isRequired
  }
  render: ->
    {db, title, sha, domains, theme, currentYear, startYear, me, pages} = @props
    {author, description, wufoo, tagline, lead} = db
    {css, js, meta, settings, navTitle} = theme
    {primaryMenu, homepageId, titleInNav, display, defaultDisplay} = settings
    {pageId, contentId} = @context.router.getCurrentParams()
    if currentRoutes = @context.router.getCurrentRoutes()
      currentRouteIndex = currentRoutes.length-1
      currentRoute = currentRoutes[currentRouteIndex]
      parentRoute = currentRoutes[currentRouteIndex-1]
    # Theme overrides the settings in index.yaml.
    pageId = pageId or currentRoute?.name or homepageId or db.homepageId or 'homepage'
    displayType = display?[pageId] or defaultDisplay or 'imageGrid'

    # Grab pageData
    if pageId is 'mixer' or parentRoute?.name is 'mixer'
      pageData = {user: me}
    else if contentId
      pageData = db[pageId]?[contentId] or {}
    else
      pageData = db[pageId] or db
    pageData._sectionId = pageId
    #console.log pageId, displayType, pageData._sectionId

    pageData.displayType = displayType
    pageData.theme = settings
    pageTitle = if pageData.title then "#{title} | #{pageData.title}" else title

    <html>
      <head>
        <title>{pageTitle}</title>
        <meta charSet="utf-8" />
        {
          _.map meta, (metaArr, i) ->
            <meta key={'m'+i} name={metaArr[0]} content={metaArr[1]} />
        }
        {
          _.map css, (cssFilePath, i) ->
            <link key={'c'+i} rel="stylesheet" type="text/css" href={cssFilePath} />
        }
        {
          _.map js, (jsFilePath, i) ->
            <script key={'j'+i} type="text/javascript" src={jsFilePath} async defer />
        }
      </head>
      <body>
        <div className="container">
          <Header primaryMenu={primaryMenu} title={title} titleInNav={titleInNav} />
          <Main pageData={pageData} tagline={tagline} lead={lead} title={title} pages={pages} />
          <Footer currentYear={currentYear} startYear={startYear} author={author} title={title} />
          <div id="fb-root"></div>
        </div>
      </body>
    </html>
