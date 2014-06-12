React = require 'react/addons'
window.jQuery = window.$ = require 'jquery'
Textarea = require('react-textarea-autosize')
marked = require 'marked'

module.exports = React.createClass
  getInitialState: ->
    state = {
      active: 'write'
    }
    # Let consumers of component set the intial value of the textarea.
    if @props.value?
      state.value = @props.value
    else
      state.value = ""

    return state

  toggleTab: (e) ->
    # Ignore clicks not on an li
    unless e.target.tagName is "LI" then return
    # Ignore clicks on the active tab.
    if e.target.className is "active" then return

    if @state.active is "write"
      @setState active: 'preview'
    else
      @setState active: 'write'

  handleChange: (e) ->
    @setState value: @refs.textarea.getDOMNode().value

  render: ->
    # Class names
    cx = React.addons.classSet
    writeTabClasses = cx({
      'react-markdown-textarea__nav__item': true
      'react-markdown-textarea__nav__item--active': @state.active is "write"
    })
    previewTabClasses = cx({
      'react-markdown-textarea__nav__item': true
      'react-markdown-textarea__nav__item--active': @state.active is "preview"
    })

    ulStyles = {
      display: 'inline-block'
    }
    liStyles = {
      listStyle: 'none'
      float: 'left'
      cursor: 'pointer'
    }
    textareaStyles = {
      border: 'none'
      display: 'block'
      resize: 'none'
    }

    # Are we writing or previewing.
    if @state.active is 'write'
      textarea = @transferPropsTo(<Textarea
        className="react-markdown-textarea__textarea-wrapper__textarea"
        autosize
        onChange={@handleChange}
        ref="textarea"
        defaultValue={@state.value}
        style={textareaStyles}
       />)
    else
      textarea = <div
          className="react-markdown-textarea__textarea-wrapper__preview"
          style={padding: '6.5px'}
          dangerouslySetInnerHTML={__html: marked(@state.value)}>
      </div>

    # Add preview?
    unless @props.noPreview
      tabs =
        <ul className="react-markdown-textarea__nav" onMouseDown={@toggleTab} style={ulStyles}>
          <li className={writeTabClasses} style={liStyles}>Write</li>
          <li className={previewTabClasses} style={liStyles}>Preview</li>
        </ul>

    return (
      <div className="react-markdown-textarea">
        {tabs}
        <div className="react-markdown-textarea__textarea-wrapper">
          {textarea}
        </div>
      </div>
    )