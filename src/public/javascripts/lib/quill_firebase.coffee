uuid = require 'uuid'
Quill = require "quill"
{utils} = require '../common'
firebase = require './firebase_client'

class QuillFirebase

  constructor: (editor_div, toolbar_div) ->
    @id = uuid.v4()
    @Quill = new Quill editor_div, {
      modules:
        'authorship': {authorId: @id, enabled: true}
        'multi-cursor': true
        'toolbar': {container: toolbar_div}
        'link-tooltip': true
      theme: 'snow'
    }
    @other_senders = {}

    # Quill modules
    @_cursor_manager = @Quill.getModule('multi-cursor')
    @_authorship = @Quill.getModule('authorship')

  init: () ->
    @add_handlers()
    @add_listeners()

  add_handlers: () ->
    @Quill.on 'selection-change', (range) =>
      @send_event 'selection-change', range

    @Quill.on 'text-change', (delta, source) =>
      if source == 'user'
        @send_event 'text-change', delta

  add_listeners: () ->
    firebase.OPERATION_REF.on 'child_added', (snapshot) =>
      retrieved_event = snapshot.val()
      @process_event retrieved_event.type, retrieved_event.sender, retrieved_event.value

  send_event: (type, value) ->
    firebase.OPERATION_REF.push {
      type
      sender: @id
      value
    }

  process_event: (type, sender, value) ->
    # Don't re-process your own events
    if sender == @id
      return

    if sender not of @other_senders
      @add_new_sender(sender)

    if type == 'selection-change'
      range = value
      if range
        @_cursor_manager.moveCursor sender, range.end

    else if type == 'text-change'
      delta = value
      @Quill.updateContents(delta)

  add_new_sender: (new_sender) ->
    # TODO: Make this a more pretty name.
    pretty_name = new_sender.substring(0, 4)
    color = utils.random_color()
    @other_senders[new_sender] = {
      pretty_name: new_sender.substring(0, 4)
      color
    }
    @_cursor_manager.setCursor new_sender, 0, pretty_name, color
    @_authorship.addAuthor new_sender

module.exports = {QuillFirebase}